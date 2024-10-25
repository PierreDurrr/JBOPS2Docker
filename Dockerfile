# Use a lightweight OS base image like Alpine Linux
FROM alpine:latest

# Install git, bash, and crond
RUN apk update && \
    apk add --no-cache git bash openrc

# Set the working directory
WORKDIR /app

# Copy entrypoint script to container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set environment variable for PLEXAPI to look for config.ini in /app
ENV PLEXAPI_CONFIG_PATH=/app/config/config.ini

# Ensure cron log directory exists
RUN mkdir -p /var/log && touch /var/log/cron.log

# Entrypoint script will handle cloning/updating and cron startup
ENTRYPOINT ["/entrypoint.sh"]
