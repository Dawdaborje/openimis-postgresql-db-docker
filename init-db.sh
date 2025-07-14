#!/bin/bash
set -e

echo "Running fullDemoDatabase.sql with error skipping..."

psql -v ON_ERROR_STOP=0 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /fullDemoDatabase.sql || true
