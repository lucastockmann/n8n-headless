FROM docker.n8n.io/n8nio/n8n:latest

# Community nodes (n8n-nodes-puppeteer) are installed via the n8n UI:
#   Settings > Community Nodes > Install > n8n-nodes-puppeteer
# They persist on the data volume (/home/node/.n8n) across restarts.

# Configure Puppeteer to skip local Chrome (connects to remote browserless)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Task runner defaults (external mode for Python/JS code node support)
# N8N_RUNNERS_AUTH_TOKEN must be set at deploy time (matching the runner service)
ENV N8N_RUNNERS_ENABLED=true
ENV N8N_RUNNERS_MODE=external
ENV N8N_RUNNERS_BROKER_LISTEN_ADDRESS=0.0.0.0

# Community packages
ENV N8N_COMMUNITY_PACKAGES_ENABLED=true
