# Use a lightweight OS base image like Alpine Linux
FROM alpine:latest

# Install necessary system packages
RUN apk update && \
    apk add --no-cache python3 py3-pip git bash openrc

# Create a virtual environment for Python packages
RUN python3 -m venv /venv

# Activate the virtual environment and install the plexapi package
RUN . /venv/bin/activate && pip install plexapi

# Copy entrypoint script to container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set environment variables
ENV PATH="/venv/bin:$PATH" \
    PLEXAPI_CONFIG_PATH=/app/config/config.ini

# Ensure /app directory is available for cloning
RUN mkdir -p /app

# Use entrypoint to handle cloning logic
ENTRYPOINT ["/entrypoint.sh"]
