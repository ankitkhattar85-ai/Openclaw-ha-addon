# OpenClaw Home Assistant Add-on

An AI assistant that lives inside your Home Assistant and manages your smart home.

## Setup

1. Add this repository to your Home Assistant Add-on Store
2. Install the OpenClaw add-on
3. Configure your Anthropic API key in the add-on settings
4. Optionally add your Telegram bot token for remote control
5. Start the add-on

## Configuration

| Option | Required | Description |
|--------|----------|-------------|
| `anthropic_api_key` | Yes | Your Anthropic API key |
| `telegram_bot_token` | No | Telegram bot token for messaging |
| `telegram_allowed_users` | No | List of allowed Telegram user IDs |
| `ha_token` | No | Long-lived HA access token (auto-detected if using Supervisor API) |

## What it does

- Monitors your home sensors and devices
- Creates and manages automations
- Learns your routines over time
- Sends smart notifications via Telegram
- Optimizes energy usage and comfort
