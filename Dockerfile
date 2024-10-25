# Use a lightweight OS base image like Alpine Linux
FROM alpine:latest

# Install git, bash, and cron
RUN apk update && \
    apk add --no-cache git bash openrc

# Create the directories for mounting
RUN mkdir -p /app

# Copy entrypoint script to container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set environment variable for PLEXAPI to look for config.ini
ENV PLEXAPI_CONFIG_PATH=/app/config/config.ini

# Use entrypoint to handle cloning logic
ENTRYPOINT ["/entrypoint.sh"]
