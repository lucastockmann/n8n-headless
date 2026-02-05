# n8n Headless

Self-hosted n8n workflow automation configured for Railway deployment.

## Deploy to Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)

### Quick Setup

1. Fork this repository
2. Connect your Railway account to GitHub
3. Create a new project from this repo
4. Set the required environment variables (see below)
5. Deploy

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

## Volumes and Persistence

Railway provides persistent storage. n8n data is stored in `/home/node/.n8n`.

For important production deployments, use PostgreSQL for data persistence.

## Resources

- [n8n Documentation](https://docs.n8n.io/)
- [Railway Documentation](https://docs.railway.app/)
- [n8n Environment Variables](https://docs.n8n.io/hosting/configuration/environment-variables/)
