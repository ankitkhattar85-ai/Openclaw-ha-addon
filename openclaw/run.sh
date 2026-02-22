#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json
OPENCLAW_HOME=/data/openclaw

# Read config from HA add-on options
ANTHROPIC_KEY=$(jq -r '.anthropic_api_key' $CONFIG_PATH)
TELEGRAM_TOKEN=$(jq -r '.telegram_bot_token // empty' $CONFIG_PATH)
TELEGRAM_USERS=$(jq -r '.telegram_allowed_users | join(",")' $CONFIG_PATH)
HA_TOKEN=$(jq -r '.ha_token // empty' $CONFIG_PATH)

# Get HA URL from supervisor
HA_URL="http://supervisor/core/api"

echo "========================================="
echo "  OpenClaw Home Assistant Add-on"
echo "========================================="
echo "OpenClaw home: ${OPENCLAW_HOME}"

# Create workspace if first run
mkdir -p "${OPENCLAW_HOME}/workspace"
mkdir -p "${OPENCLAW_HOME}/workspace/memory"

# Write SOUL.md for home-focused assistant if not exists
if [ ! -f "${OPENCLAW_HOME}/workspace/SOUL.md" ]; then
    cat > "${OPENCLAW_HOME}/workspace/SOUL.md" << 'SOUL'
# SOUL.md - Home Brain

You are the Khattar home's AI brain, running on Home Assistant.

## Core Purpose
- Manage the smart home: lights, climate, presence, automations
- Learn household patterns and optimize comfort + energy
- Be proactive: suggest automations, flag anomalies, optimize routines
- Report important home events to Ankit via Telegram

## Personality
- Efficient and quiet — don't spam notifications
- Speak up when something matters (unusual activity, energy spikes, weather changes)
- Think like a butler, not a chatbot

## Home Setup
- Home Assistant on Raspberry Pi 4 (HAOS)
- FP2 presence sensor in basement (7 zones)
- 10 lights, 2 climate, 2 locks, 12 media players, 20 switches
- Projector: media_player.xr16a

## Rules
- Never lock people out
- Never disable security features
- Climate changes: only within reasonable bounds (65-78°F)
- Big changes: ask first via Telegram
SOUL
    echo "Created default SOUL.md"
fi

# Write OpenClaw config if not exists
if [ ! -f "${OPENCLAW_HOME}/openclaw.json" ]; then
    cat > "${OPENCLAW_HOME}/openclaw.json" << EOF
{
  "meta": {
    "lastTouchedVersion": "2026.2.22"
  },
  "llm": {
    "defaultModel": "anthropic/claude-sonnet-4-5",
    "providers": {
      "anthropic": {
        "apiKey": "${ANTHROPIC_KEY}"
      }
    }
  },
  "gateway": {
    "port": 18789,
    "host": "0.0.0.0"
  }
}
EOF

    # Add Telegram config if token provided
    if [ -n "$TELEGRAM_TOKEN" ]; then
        python3 -c "
import json
with open('${OPENCLAW_HOME}/openclaw.json') as f:
    cfg = json.load(f)
cfg['channels'] = {
    'telegram': {
        'accounts': [{
            'botToken': '${TELEGRAM_TOKEN}',
            'dmPolicy': 'allowlist',
            'groupPolicy': 'disabled',
            'allowFrom': '${TELEGRAM_USERS}'.split(',')
        }]
    }
}
with open('${OPENCLAW_HOME}/openclaw.json', 'w') as f:
    json.dump(cfg, f, indent=2)
"
    fi
    echo "Created OpenClaw config"
fi

# Set environment
export OPENCLAW_HOME
export ANTHROPIC_API_KEY="${ANTHROPIC_KEY}"

# Start OpenClaw gateway
echo "Starting OpenClaw gateway..."
cd "${OPENCLAW_HOME}"
exec openclaw gateway start --foreground
