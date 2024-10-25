# Use a lightweight OS base image like Alpine Linux
FROM alpine:latest

# Install git, bash, and crond
RUN apk update && \
    apk add --no-cache git bash openrc

# Clone JBOPS repository to a separate location
RUN mkdir -p /jbops_repo && \
    git clone https://github.com/blacktwin/JBOPS.git /jbops_repo

# Copy entrypoint script to container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Environment variable for PLEXAPI to look for config.ini
ENV PLEXAPI_CONFIG_PATH=/app/config/config.ini

# Set cron log location
RUN mkdir -p /var/log && touch /var/log/cron.log

# Use entrypoint to handle mounting and cloning logic
ENTRYPOINT ["/entrypoint.sh"]
