# syntax=docker/dockerfile:1.4
FROM node:20-alpine

# Install minimal dependencies
RUN apk add --no-cache tini git

# Install n8n globally (with npm cache)
RUN --mount=type=cache,id=npm-cache,target=/root/.npm \
    npm install -g n8n

# Install n8n-nodes-puppeteer community node (with npm cache)
RUN --mount=type=cache,id=npm-cache,target=/root/.npm \
    cd /usr/local/lib/node_modules/n8n && \
    npm install --legacy-peer-deps n8n-nodes-puppeteer

# Configure Puppeteer to connect to remote browserless
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Set n8n environment variables
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=https
ENV GENERIC_TIMEZONE=UTC
ENV TZ=UTC

# Create n8n user for security
RUN addgroup -S n8n && adduser -S -G n8n n8n
RUN mkdir -p /home/n8n/.n8n && chown -R n8n:n8n /home/n8n

USER n8n
WORKDIR /home/n8n

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["n8n", "start"]
