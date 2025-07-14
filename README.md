# OpenIMIS Docker PostgreSQL

This is a configurable Docker setup for the OpenIMIS database using PostgreSQL with support for multiple environments and customizable parameters.

## Overview

This Docker Compose configuration sets up a PostgreSQL database for OpenIMIS with automatic initialization from a demo database SQL file. The setup includes proper volume mounting for data persistence, health checks, and flexible configuration through environment variables and build arguments.

## Prerequisites

- Docker and Docker Compose installed
- SQL initialization file (default: `fullDemoDatabase.sql`) in the project directory
- `init-db.sh` script in the project directory

## Files Structure

```
openimis-docker-postgresql/
├── docker-compose.yml
├── Dockerfile
├── init-db.sh
├── .env
├── fullDemoDatabase.sql
└── README.md
```

## Quick Start

1. **Make the initialization script executable:**

   ```bash
   chmod +x ./init-db.sh
   ```

2. **Start the database with default settings:**

   ```bash
   docker-compose up -d
   ```

3. **Check the logs:**
   ```bash
   docker-compose logs -f postgres
   ```

## Configuration

### Default Settings

- **Database Name:** `openimis`
- **Username:** `openimis_user`
- **Password:** `SuperSafePassword`
- **Port:** `5432`
- **PostgreSQL Version:** `16`
- **Init Script:** `fullDemoDatabase.sql`

### Environment Variables

All settings can be customized using environment variables. Create or modify the `.env` file:

```env
# Database Configuration
DB_NAME=openimis
DB_USER=openimis_user
DB_PASSWORD=SuperSafePassword
DB_PORT=5432

# Container Configuration
CONTAINER_NAME=openimis_postgresql
POSTGRES_VERSION=16

# Initialization Script
INIT_SCRIPT=fullDemoDatabase.sql
```

### Build Arguments

You can also specify configuration at build time:

```bash
docker-compose build --build-arg DB_NAME=custom_db --build-arg POSTGRES_VERSION=15
```

## Usage Examples

### Use Default Configuration

```bash
docker-compose up -d
```

### Override Specific Settings

```bash
DB_NAME=myapp DB_USER=myuser docker-compose up -d
```

### Use Different Database Name

```bash
DB_NAME=production_db DB_PASSWORD=SecurePassword123 docker-compose up -d
```

### Use Different PostgreSQL Version

```bash
POSTGRES_VERSION=15 docker-compose up -d
```

### Use Custom Init Script

```bash
INIT_SCRIPT=myCustomDatabase.sql docker-compose up -d
```

## Initialization Process

The database is automatically initialized with:

1. PostgreSQL container startup (configurable version)
2. Database and user creation using specified parameters
3. Execution of the specified SQL file via the `init-db.sh` script
4. Error-tolerant SQL execution with proper logging

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
# Using default settings
docker-compose exec postgres psql -U openimis_user -d openimis

# Using custom settings (replace with your values)
docker-compose exec postgres psql -U $DB_USER -d $DB_NAME
```

### Reset the database (fresh start)

```bash
docker-compose down -v
docker volume prune -f
docker-compose up -d
```

### Rebuild with new configuration

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Multiple Environment Setup

### Development Environment

```bash
# .env.dev
DB_NAME=openimis_dev
DB_USER=dev_user
DB_PASSWORD=DevPassword123
CONTAINER_NAME=openimis_dev_postgresql
```

### Production Environment

```bash
# .env.prod
DB_NAME=openimis_prod
DB_USER=prod_user
DB_PASSWORD=VerySecureProductionPassword
CONTAINER_NAME=openimis_prod_postgresql
DB_PORT=5433
```

Use specific environment files:

```bash
docker-compose --env-file .env.dev up -d
docker-compose --env-file .env.prod up -d
```

## Troubleshooting

### Database won't start

- Check if the specified port is available
- Verify all required files exist
- Check Docker logs for specific errors
- Ensure environment variables are properly set

### Initialization script fails

- Ensure `init-db.sh` is executable: `chmod +x ./init-db.sh`
- Check if the specified SQL file exists and is readable
- Review logs for SQL-specific errors
- Verify the `INIT_SCRIPT` environment variable points to the correct file

### Permission issues

If you encounter permission errors with the init script:

1. Make sure the script is executable on the host system
2. Check file ownership and permissions
3. Consider rebuilding the container: `docker-compose build --no-cache`

### Environment variable issues

- Verify your `.env` file syntax
- Check for typos in variable names
- Ensure no spaces around the `=` sign in environment variables
- Test with explicit environment variables: `DB_NAME=test docker-compose up -d`

### Clean slate reset

If you need to completely reset the database:

```bash
docker-compose down -v
docker system prune -f
docker volume prune -f
docker-compose up -d
```

### Health check failures

Monitor the health status:

```bash
docker-compose ps
```

If health checks fail, check the logs and verify the database configuration.

## Data Persistence

Database data is persisted in a Docker volume named `pgdata`. This ensures your data survives container restarts and updates.

## Security Considerations

- The default password `SuperSafePassword` is for development only
- For production deployments, use strong, unique passwords
- Consider using Docker secrets for sensitive information
- Regularly update PostgreSQL version for security patches
- Restrict network access to the database port

### Production Security Example

```bash
# Use environment variables for production
export DB_PASSWORD=$(openssl rand -base64 32)
docker-compose up -d
```

## Health Check

The container includes a health check that verifies PostgreSQL is ready to accept connections using the configured database name and user. You can check the health status with:

```bash
docker-compose ps
```

## Advanced Configuration

### Custom PostgreSQL Configuration

You can mount custom PostgreSQL configuration files:

```yaml
# Add to docker-compose.yml volumes section
- ./postgresql.conf:/etc/postgresql/postgresql.conf:ro
- ./pg_hba.conf:/etc/postgresql/pg_hba.conf:ro
```

### Multiple Databases

Modify the `init-db.sh` script to create multiple databases:

```bash
# Add to init-db.sh
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE secondary_db;
EOSQL
```

## Monitoring and Maintenance

### View database size

```bash
docker-compose exec postgres psql -U $DB_USER -d $DB_NAME -c "SELECT pg_size_pretty(pg_database_size('$DB_NAME'));"
```

### Backup database

```bash
docker-compose exec postgres pg_dump -U $DB_USER $DB_NAME > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore database

```bash
docker-compose exec -T postgres psql -U $DB_USER -d $DB_NAME < backup_file.sql
```

## Support

You are on your own!!

---

**Note:** This setup is designed for flexibility and ease of use across different environments. Always review and test configurations before deploying to production systems.
