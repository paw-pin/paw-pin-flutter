# Backend Docker Container

This folder contains a sample `Dockerfile` for packaging the Spring Boot backend.
Replace the contents with your backend source before building.

Build the image:

```bash
docker build -t paw-pin-backend .
```

Run locally:

```bash
docker run -p 8080:8080 paw-pin-backend
```
