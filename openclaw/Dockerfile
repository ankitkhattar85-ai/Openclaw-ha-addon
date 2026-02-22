ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install build deps + cmake (needed for koffi native module)
RUN apk add --no-cache \
    bash \
    jq \
    git \
    curl \
    ca-certificates \
    python3 \
    make \
    g++ \
    cmake \
    linux-headers \
    libstdc++ \
    libgcc

# Install Node.js 22 via unofficial builds for Alpine
RUN curl -fsSL https://unofficial-builds.nodejs.org/download/release/v22.14.0/node-v22.14.0-linux-arm64-musl.tar.xz \
    -o /tmp/node.tar.xz \
    && tar -xf /tmp/node.tar.xz -C /usr/local --strip-components=1 \
    && rm /tmp/node.tar.xz \
    && node --version && npm --version

# Install OpenClaw
RUN npm install -g openclaw@latest

# Cleanup build deps to save space
RUN apk del make g++ cmake linux-headers

# Create data directory
RUN mkdir -p /data/openclaw/workspace

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
