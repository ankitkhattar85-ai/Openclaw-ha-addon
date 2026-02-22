ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install Node.js 22
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    curl \
    bash \
    python3 \
    make \
    g++

# Install Node 22 via n if system node is too old
RUN npm install -g n && n 22 || true

# Install OpenClaw
RUN npm install -g openclaw@latest

# Create data directory
RUN mkdir -p /data/openclaw/workspace

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
