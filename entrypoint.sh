#!/bin/sh

# Check if /app is empty; if so, populate it from /jbops_repo
if [ -z "$(ls -A /app)" ]; then
  echo "Populating /app with JBOPS repository contents..."
  
  # Copy all contents, including hidden files, to /app
  cp -a /jbops_repo/. /app
  echo "Repository populated in /app."
else
  echo "/app already has contents. Skipping initialization."
fi

# Set up a cron job to check for updates every 15 minutes
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

# Start cron and output log to console
echo "Starting cron and logging output..."
crond -f -l 2 & tail -f /var/log/cron.log
