# JBOPS2Docker

```yaml
version: '3'
services:
  jbops:
    build: .
    container_name: jbops_container
    volumes:
      - ./host_jbops:/app  # Map the repository to the host
    restart: always  # Ensure container restarts if it crashes
```
