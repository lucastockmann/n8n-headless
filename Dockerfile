FROM node:20-alpine

# Install Chromium and dependencies
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    font-noto-emoji \
    tini

# Install n8n globally
RUN npm install -g n8n

# Install n8n-nodes-puppeteer community node
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install n8n-nodes-puppeteer

# Configure Puppeteer to use system Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_ARGS="--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu"

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

# Expose the n8n port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

# Use tini as init system and start n8n
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["n8n", "start"]
