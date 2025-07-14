#!/bin/bash
set -e

echo "Starting database initialization..."

# Wait for PostgreSQL to be ready
until pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

echo "PostgreSQL is ready. Running fullDemoDatabase.sql..."

# Check if the SQL file exists and is readable
if [ ! -f /fullDemoDatabase.sql ]; then
    echo "ERROR: fullDemoDatabase.sql not found!"
    exit 1
fi

if [ ! -r /fullDemoDatabase.sql ]; then
    echo "ERROR: fullDemoDatabase.sql is not readable!"
    exit 1
fi

# Run the SQL file with better error handling
echo "Executing SQL file with error tolerance..."
psql -v ON_ERROR_STOP=0 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /fullDemoDatabase.sql

# Check if the operation completed
if [ $? -eq 0 ]; then
    echo "Database initialization completed successfully!"
else
    echo "Database initialization completed with some errors (this may be normal)"
fi

# Optional: Show some basic info about the database
echo "Database info:"
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "\dt" || true
