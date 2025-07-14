#!/bin/bash
set -e

# Use environment variables from build args or defaults
DB_NAME=${DB_NAME:-openimis}
DB_USER=${DB_USER:-openimis_user}
INIT_SCRIPT=${INIT_SCRIPT:-fullDemoDatabase.sql}

echo "Initializing database: $DB_NAME with user: $DB_USER"

# Create database if it doesn't exist
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    SELECT 'CREATE DATABASE $DB_NAME'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$DB_NAME')\gexec
EOSQL

# Import the SQL file if it exists
if [ -f "/$INIT_SCRIPT" ]; then
    echo "Importing $INIT_SCRIPT into database $DB_NAME"
    psql -v ON_ERROR_STOP=1 --username "$DB_USER" --dbname "$DB_NAME" <"/$INIT_SCRIPT"
    echo "Database initialization completed successfully"
else
    echo "Warning: $INIT_SCRIPT not found, skipping import"
fi
