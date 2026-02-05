# n8n Headless

Self-hosted n8n workflow automation with headless Chrome via Browserless sidecar, configured for Railway deployment.

## Architecture

```
┌─────────────────────────────────────────────┐
│              Railway Project                │
│                                             │
│  ┌─────────────┐      ┌─────────────────┐  │
│  │    n8n      │ ───► │   Browserless   │  │
│  │  (port 5678)│  ws  │   (port 3000)   │  │
│  └─────────────┘      └─────────────────┘  │
│                                             │
└─────────────────────────────────────────────┘
```

- **n8n**: Workflow automation (lightweight, no Chrome)
- **Browserless**: Headless Chrome service (handles all browser tasks)

## Deploy to Railway

### Step 1: Deploy n8n Service

1. Create a new Railway project
2. Add a new service from this GitHub repo
3. Set environment variables:

| Variable | Description |
|----------|-------------|
| `N8N_ENCRYPTION_KEY` | Generate with: `openssl rand -hex 32` |
| `WEBHOOK_URL` | Your Railway app URL |
| `N8N_BASIC_AUTH_ACTIVE` | `true` |
| `N8N_BASIC_AUTH_USER` | Your username |
| `N8N_BASIC_AUTH_PASSWORD` | Your password |
| `PUPPETEER_WS_ENDPOINT` | `ws://browserless.railway.internal:3000` |

### Step 2: Deploy Browserless Service

1. In the same Railway project, click "New Service"
2. Select "Docker Image"
3. Enter: `browserless/chrome:latest`
4. Set environment variables:

| Variable | Value |
|----------|-------|
| `MAX_CONCURRENT_SESSIONS` | `5` |
| `CONNECTION_TIMEOUT` | `60000` |

5. **Important**: In service settings, set the internal hostname to `browserless`

### Step 3: Configure Networking

Railway services communicate via internal networking:
- n8n connects to browserless at `ws://browserless.railway.internal:3000`
- No need to expose browserless to the public internet

### Resource Requirements

| Service | RAM | Notes |
|---------|-----|-------|
| n8n | 512MB - 1GB | Lightweight without Chrome |
| Browserless | 1GB - 2GB | Handles Chrome processes |

## Headless Chrome / Puppeteer

The `n8n-nodes-puppeteer` community node is pre-installed and configured to connect to Browserless.

### Available Operations

| Operation | Description |
|-----------|-------------|
| **Get Page Content** | Scrape HTML/text with JavaScript rendering |
| **Get Screenshot** | Capture page screenshots (PNG/JPEG) |
| **Get PDF** | Generate PDF documents from pages |
| **Execute Script** | Run custom Puppeteer scripts |

### Use Cases

- Web scraping with JavaScript rendering
- Automated screenshot capture
- PDF generation from HTML
- Form submission automation

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

5. Browserless dashboard at http://localhost:3000

## Database Options

By default, n8n uses SQLite. For production, add a PostgreSQL database:

1. Add a PostgreSQL service in Railway
2. Set these environment variables on the n8n service:

```
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=${{Postgres.PGHOST}}
DB_POSTGRESDB_PORT=${{Postgres.PGPORT}}
DB_POSTGRESDB_DATABASE=${{Postgres.PGDATABASE}}
DB_POSTGRESDB_USER=${{Postgres.PGUSER}}
DB_POSTGRESDB_PASSWORD=${{Postgres.PGPASSWORD}}
```

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "Failed to connect to browser" | Browserless not reachable | Check `PUPPETEER_WS_ENDPOINT` and service hostname |
| Browser operations timeout | Browserless resource limits | Increase RAM on browserless service |
| "Connection refused" | Services not linked | Verify internal hostname is `browserless` |

## Security Notes

- Browserless should NOT be exposed publicly (no public domain needed)
- n8n connects via Railway's internal network
- Set `BROWSERLESS_TOKEN` if you need additional security

## Resources

- [n8n Documentation](https://docs.n8n.io/)
- [Railway Documentation](https://docs.railway.app/)
- [Browserless Documentation](https://www.browserless.io/docs/)
- [n8n-nodes-puppeteer](https://www.npmjs.com/package/n8n-nodes-puppeteer)
