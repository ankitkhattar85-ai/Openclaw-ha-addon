ARG BUILD_FROM
FROM node:22-alpine AS node

FROM ${BUILD_FROM}

# Copy Node.js from official image
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

# Install minimal deps
RUN apk add --no-cache bash jq git curl libstdc++ libgcc

# Install OpenClaw
RUN npm install -g openclaw@latest 2>&1 || echo "Trying with --unsafe-perm" && npm install -g --unsafe-perm openclaw@latest

# Create data directory
RUN mkdir -p /data/openclaw/workspace

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
