# JBOPS2Docker

```yaml
version: '3'
services:
  jbops:
    build: .
    container_name: jbops2docker
    volumes:
      - /docker_data2/jbops2docker/config:/app  # Map the repository to the host
    restart: unless-stopped # Ensure container restarts if it crashes
```
