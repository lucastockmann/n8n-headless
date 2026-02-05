FROM docker.n8n.io/n8nio/n8n:latest

# Community nodes (n8n-nodes-puppeteer) are installed via the n8n UI:
#   Settings > Community Nodes > Install > n8n-nodes-puppeteer
# They persist on the data volume (/home/node/.n8n) across restarts.

# Configure Puppeteer to skip local Chrome (connects to remote browserless)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
