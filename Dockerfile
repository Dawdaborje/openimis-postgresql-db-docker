ARG POSTGRES_VERSION=16
FROM postgres:${POSTGRES_VERSION}

# Accept build arguments
ARG DB_NAME=openimis
ARG DB_USER=openimis_user
ARG INIT_SCRIPT=fullDemoDatabase.sql

# Set environment variables from build args
ENV DB_NAME=${DB_NAME}
ENV DB_USER=${DB_USER}
ENV INIT_SCRIPT=${INIT_SCRIPT}

# Copy initialization script
COPY init-db.sh /docker-entrypoint-initdb.d/init-db.sh
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# Optional: Add labels for better image management
LABEL maintainer="OpenIMIS Team"
LABEL description="PostgreSQL database for OpenIMIS with configurable parameters"
LABEL version="1.0"
