# n8n Headless

Self-hosted n8n workflow automation with headless Chrome, configured for Railway deployment.

## Features

- n8n workflow automation platform
- Headless Chrome/Chromium for browser automation
- Pre-installed `n8n-nodes-puppeteer` community node
- Ready for Railway deployment

## Deploy to Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)

### Quick Setup

1. Fork this repository
2. Connect your Railway account to GitHub
3. Create a new project from this repo
4. Set the required environment variables (see below)
5. **Important:** Set RAM limit to at least 2GB (Settings > Resource Limits)
6. Deploy

### Required Environment Variables

Set these in your Railway project settings:

| Variable | Description |
|----------|-------------|
| `N8N_ENCRYPTION_KEY` | Encryption key for credentials. Generate with: `openssl rand -hex 32` |
| `WEBHOOK_URL` | Your Railway app URL (e.g., `https://your-app.railway.app`) |

### Recommended Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `N8N_BASIC_AUTH_ACTIVE` | `false` | Enable basic authentication |
| `N8N_BASIC_AUTH_USER` | - | Username for basic auth |
| `N8N_BASIC_AUTH_PASSWORD` | - | Password for basic auth |
| `GENERIC_TIMEZONE` | `UTC` | Timezone for n8n |

### Resource Requirements

Headless Chrome requires significant memory:

| Configuration | RAM | Notes |
|--------------|-----|-------|
| Minimum | 1 GB | May struggle with complex pages |
| Recommended | 2-4 GB | Good for most use cases |
| Per browser tab | +100-300 MB | Additional memory per concurrent tab |

Configure in Railway Dashboard: Settings > Resource Limits

### Database Options

By default, n8n uses SQLite. For production, consider adding a PostgreSQL database:

1. Add a PostgreSQL service in Railway
2. Set these environment variables:

```
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=${{Postgres.PGHOST}}
DB_POSTGRESDB_PORT=${{Postgres.PGPORT}}
DB_POSTGRESDB_DATABASE=${{Postgres.PGDATABASE}}
DB_POSTGRESDB_USER=${{Postgres.PGUSER}}
DB_POSTGRESDB_PASSWORD=${{Postgres.PGPASSWORD}}
```

## Headless Chrome / Puppeteer

This image includes Chromium and the `n8n-nodes-puppeteer` community node pre-installed.

### Available Operations

The Puppeteer node provides these operations:

| Operation | Description |
|-----------|-------------|
| **Get Page Content** | Scrape HTML/text from web pages (with JavaScript rendering) |
| **Get Screenshot** | Capture page screenshots (PNG/JPEG) |
| **Get PDF** | Generate PDF documents from pages |
| **Execute Script** | Run custom Puppeteer scripts |

### Use Cases

- Web scraping with JavaScript rendering
- Automated screenshot capture
- PDF generation from HTML
- Form submission automation
- Visual regression testing

### Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "Failed to launch browser" | Chrome not found | Verify `PUPPETEER_EXECUTABLE_PATH` is set |
| Chrome crashes immediately | Insufficient shared memory | Increase RAM limit in Railway |
| Out of memory errors | RAM limit too low | Set Railway RAM to 2GB+ |
| Timeout errors | Page load too slow | Increase timeout in node settings |
| Font rendering issues | Missing fonts | Most common fonts are included |

## Local Development

1. Copy environment file:
   ```bash
   cp .env.example .env
   ```

2. Update `.env` with your settings

3. Run with Docker Compose:
   ```bash
   docker-compose up -d
   ```

4. Access n8n at http://localhost:5678

The `docker-compose.yml` includes `shm_size: 1gb` which is required for Chrome to function properly.

## Volumes and Persistence

Railway provides persistent storage. n8n data is stored in `/home/node/.n8n`.

For important production deployments, use PostgreSQL for data persistence.

## Resources

- [n8n Documentation](https://docs.n8n.io/)
- [Railway Documentation](https://docs.railway.app/)
- [n8n Environment Variables](https://docs.n8n.io/hosting/configuration/environment-variables/)
- [n8n-nodes-puppeteer](https://www.npmjs.com/package/n8n-nodes-puppeteer)
