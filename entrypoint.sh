#!/bin/sh

# Define a temporary directory for cloning
TEMP_DIR="/tmp/jbops"

# Check if /app is empty or missing .git directory, then clone if needed
if [ ! -d "/app/.git" ]; then
  echo "Initializing JBOPS repository in /app..."

  # Clean up any previous temp clone
  rm -rf $TEMP_DIR
  mkdir -p $TEMP_DIR

  # Clone JBOPS repository to the temporary directory
  git clone https://github.com/blacktwin/JBOPS.git $TEMP_DIR

  # Copy contents to /app
  cp -r $TEMP_DIR/* /app
  echo "Repository initialized in /app."
else
  echo "JBOPS repository already initialized in /app."
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
