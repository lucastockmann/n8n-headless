FROM node:20-alpine

# Install minimal dependencies (py3-pip needed for venv support)
RUN apk add --no-cache tini git python3 py3-pip

# Install n8n globally
RUN npm install -g n8n

# Install n8n-nodes-puppeteer community node
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install --legacy-peer-deps n8n-nodes-puppeteer

# Set up Python virtual environment for n8n Code node
RUN python3 -m venv /opt/n8n-python-venv

# Configure Puppeteer to connect to remote browserless
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Set n8n environment variables
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV GENERIC_TIMEZONE=UTC
ENV TZ=UTC
ENV N8N_PYTHON_VENV_PATH=/opt/n8n-python-venv

# Create n8n user for security
RUN addgroup -S n8n && adduser -S -G n8n n8n
RUN mkdir -p /home/n8n/.n8n && chown -R n8n:n8n /home/n8n
RUN chown -R n8n:n8n /opt/n8n-python-venv

USER n8n
WORKDIR /home/n8n

EXPOSE 5678

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["n8n", "start"]
