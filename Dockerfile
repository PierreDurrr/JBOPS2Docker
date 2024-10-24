# Use a lightweight OS base image like Alpine Linux
FROM alpine:latest

# Install git, cron, and bash
RUN apk update && \
    apk add --no-cache git bash curl crond

# Set the working directory inside the container
WORKDIR /app

# Clone the repository during build
RUN git clone https://github.com/blacktwin/JBOPS.git .

# Create a symbolic link from the repository's config.ini to the expected plexapi config location
RUN mkdir -p /root/.config/plexapi && \
    ln -s /app/config.ini /root/.config/plexapi/config.ini

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

# Make the script executable
RUN chmod +x /app/update_repo.sh

# Ensure the cron log directory and file exist
RUN mkdir -p /var/log && touch /var/log/cron.log

# Set up cron to run the update script every 15 minutes
RUN echo "*/15 * * * * /bin/bash /app/update_repo.sh >> /var/log/cron.log 2>&1" > /etc/crontabs/root

# Start cron and keep the container running, tailing the cron log
CMD crond && tail -f /var/log/cron.log
