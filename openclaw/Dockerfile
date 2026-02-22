ARG BUILD_FROM
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Node 22 + build deps
RUN apk add --no-cache \
    bash jq git curl ca-certificates \
    python3 make g++ cmake linux-headers \
    libstdc++ libgcc \
    && curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install 22 \
    && nvm use 22 \
    && ln -sf "$NVM_DIR/versions/node/$(nvm current)/bin/node" /usr/local/bin/node \
    && ln -sf "$NVM_DIR/versions/node/$(nvm current)/bin/npm" /usr/local/bin/npm \
    && ln -sf "$NVM_DIR/versions/node/$(nvm current)/bin/npx" /usr/local/bin/npx \
    && node --version && npm --version

# Install OpenClaw
RUN npm install -g openclaw@latest

# Cleanup build deps
RUN apk del make g++ cmake linux-headers python3

# Create data directory
RUN mkdir -p /data/openclaw/workspace

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
