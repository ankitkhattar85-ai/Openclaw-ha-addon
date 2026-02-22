ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install dependencies (Alpine-based)
RUN apk add --no-cache \
    curl \
    git \
    bash \
    jq \
    ca-certificates \
    python3 \
    npm \
    nodejs

# Verify node version, upgrade if needed
RUN node --version && npm --version

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Create data directory
RUN mkdir -p /data/openclaw/workspace

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
