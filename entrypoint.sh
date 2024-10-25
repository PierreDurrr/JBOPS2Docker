#!/bin/sh

# Check if /app is empty
if [ ! "$(ls -A /app)" ]; then
  echo "/app is empty. Cloning JBOPS repository..."

  # Clone the JBOPS repository directly into /app
  git clone https://github.com/blacktwin/JBOPS.git /app

  echo "JBOPS repository has been cloned into /app."
else
  echo "/app already has contents. Skipping initialization."
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

# Create log file and start cron
touch /var/log/cron.log  # Ensure the log file exists
echo "Starting cron and logging output..."
crond -f -l 2 &  # Start cron in the background
tail -f /var/log/cron.log  # Show the cron log in the console
