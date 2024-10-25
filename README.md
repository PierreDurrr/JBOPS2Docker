# JBOPS2Docker

Lightweight dockerized version of [blacktwin's JBOPS scripts](https://github.com/blacktwin/JBOPS)

docker-compose.yml example :

```yaml
version: '3'
services:
  jbops:
    build: .
    container_name: jbops2docker
    environment:
      - PLEXAPI_CONFIG_PATH=/app/config.ini  # Set the environment variable for plexapi
    volumes:
      - /docker_data2/jbops2docker/config:/app  # Map the repository to the host
    restart: unless-stopped # Ensure container restarts if it crashes
```
