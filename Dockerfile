# Use a lightweight OS base image like Alpine Linux
FROM alpine:latest

# Install git, bash, and crond
RUN apk update && \
    apk add --no-cache git bash openrc

# Set the working directory inside the container
WORKDIR /app

# Clone the JBOPS repository into /app
RUN git clone https://github.com/blacktwin/JBOPS.git .

# Create a placeholder config directory within /app for mounting
RUN mkdir -p /app/config

# Set the environment variable for PLEXAPI to look for config.ini in /app/config
ENV PLEXAPI_CONFIG_PATH=/app/config/config.ini

# Create a script that will periodically check for updates
RUN echo '#!/bin/bash\n\
cd /app\n\
git fetch origin\n\
LOCAL=$(git rev-parse @)\n\
REMOTE=$(git rev-parse @{u})\n\
if [ "$LOCAL" != "$REMOTE" ]; then\n\
  echo "New updates detected. Pulling changes..."\n\
  git reset --hard origin/master\n\
  echo "Repository updated to the latest version."\n\
else\n\
  echo "No updates found."\n\
fi' > /app/update_repo.sh

# Make the update script executable
RUN chmod +x /app/update_repo.sh

# Ensure the cron log directory and file exist
RUN mkdir -p /var/log && touch /var/log/cron.log

# Set up crontab to run the update script every 15 minutes
RUN echo "*/15 * * * * /bin/bash /app/update_repo.sh >> /var/log/cron.log 2>&1" > /etc/crontabs/root

# Start crond in the foreground and tail the log output to the console
CMD ["sh", "-c", "crond -f -l 2 & tail -f /var/log/cron.log"]
