FROM docker.n8n.io/n8nio/n8n:latest

USER root

# Pre-install puppeteer community node to a separate directory
# (n8n v2 uses pnpm catalog: protocol in its own package.json, so we
# cannot npm install into n8n's node_modules directly)
RUN mkdir -p /opt/n8n-custom-nodes && \
    cd /opt/n8n-custom-nodes && \
    npm init -y && \
    npm install n8n-nodes-puppeteer && \
    chown -R node:node /opt/n8n-custom-nodes

# Configure Puppeteer to skip local Chrome (connects to remote browserless)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
# Tell n8n where to find the pre-installed community node
ENV N8N_CUSTOM_EXTENSIONS=/opt/n8n-custom-nodes/node_modules/n8n-nodes-puppeteer

USER node
