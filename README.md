# OpenIMIS Docker PostgreSQL

This is my Docker setup for the OpenIMIS database using PostgreSQL 16.

## Overview

This Docker Compose configuration sets up a PostgreSQL database for OpenIMIS with automatic initialization from a demo database SQL file. The setup includes proper volume mounting for data persistence and initialization scripts.

## Prerequisites

- Docker and Docker Compose installed
- `fullDemoDatabase.sql` file in the project directory
- `init-db.sh` script in the project directory

## Files Structure

```
openimis-docker-postgresql/
├── docker-compose.yml
├── init-db.sh
├── fullDemoDatabase.sql
└── README.md
```

## Quick Start

1. **Make the initialization script executable:**
   ```bash
   chmod +x ./init-db.sh
   ```

2. **Start the database:**
   ```bash
   docker-compose up -d
   ```

3. **Check the logs:**
   ```bash
   docker-compose logs -f postgres
   ```

## Configuration

### Database Settings
- **Database Name:** `openimis`
- **Username:** `openimis_user`
- **Password:** `SuperSafePassword`
- **Port:** `5432`

### Environment Variables
The following environment variables are configured:
- `POSTGRES_DB`: Database name
- `POSTGRES_USER`: Database user
- `POSTGRES_PASSWORD`: Database password
- `POSTGRES_INITDB_ARGS`: Additional initialization arguments

## Initialization Process

The database is automatically initialized with:
1. PostgreSQL 16 container startup
2. Database and user creation
3. Execution of `fullDemoDatabase.sql` via the `init-db.sh` script
4. Error-tolerant SQL execution (continues on non-critical errors)

## Common Commands

### Start the database
```bash
docker-compose up -d
```

### Stop the database
```bash
docker-compose down
```

### View logs
```bash
docker-compose logs -f postgres
```

### Connect to the database
```bash
docker-compose exec postgres psql -U openimis_user -d openimis
```

### Reset the database (fresh start)
```bash
docker-compose down -v
docker volume prune -f
docker-compose up -d
```

## Troubleshooting

### Database won't start
- Check if port 5432 is available
- Verify all required files exist
- Check Docker logs for specific errors

### Initialization script fails
- Ensure `init-db.sh` is executable: `chmod +x ./init-db.sh`
- Check if `fullDemoDatabase.sql` exists and is readable
- Review logs for SQL-specific errors

### Permission issues
If you encounter permission errors with the init script:
1. Make sure the script is executable on the host system
2. Consider using the Dockerfile approach for better permission handling

### Clean slate reset
If you need to completely reset the database:
```bash
docker-compose down -v
docker system prune -f
docker volume prune -f
docker-compose up -d
```

## Data Persistence

Database data is persisted in a Docker volume named `pgdata`. This ensures your data survives container restarts and updates.

## Security Note

The default password `SuperSafePassword` is used for development purposes. For production deployments, use a strong, unique password and consider using Docker secrets or environment files for sensitive information.

## Health Check

The container includes a health check that verifies PostgreSQL is ready to accept connections. You can check the health status with:
```bash
docker-compose ps
```

## Support
You are on your own!!
