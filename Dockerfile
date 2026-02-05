FROM docker.n8n.io/n8nio/n8n:latest

USER root

# Install git (needed for some community nodes)
RUN apk add --no-cache git

# Install n8n-nodes-puppeteer community node
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install --legacy-peer-deps n8n-nodes-puppeteer

# Configure Puppeteer to skip local Chrome (connects to remote browserless)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

USER node
