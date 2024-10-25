#!/bin/sh

# If /app is empty, clone the repository
if [ -z "$(ls -A /app)" ]; then
  echo "Initializing JBOPS repository..."
  git clone https://github.com/blacktwin/JBOPS.git /app
else
  echo "JBOPS repository already present, skipping clone."
fi

# Create a cron job to check for updates every 15 minutes
echo "*/15 * * * * cd /app && git fetch origin && \
LOCAL=$(git rev-parse @) && \
REMOTE=$(git rev-parse @{u}) && \
if [ \"$LOCAL\" != \"$REMOTE\" ]; then \
  echo \"New updates detected. Pulling changes...\"; \
  git reset --hard origin/master; \
  echo \"Repository updated to the latest version.\"; \
else \
  echo \"No updates found.\"; \
fi >> /var/log/cron.log 2>&1" > /etc/crontabs/root

# Start cron and tail log
echo "Starting cron and logging output..."
crond -f -l 2 & tail -f /var/log/cron.log
