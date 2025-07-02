
# Spring Boot Backend

This directory contains a minimal Spring Boot application that exposes a REST API for retrieving users from a PostgreSQL database.

## Building
=======
# Backend Docker Container

This folder contains a sample `Dockerfile` for packaging the Spring Boot backend.
Replace the contents with your backend source before building.

Build the image:
```bash
docker build -t paw-pin-backend .
```

## Running Locally

Provide the database connection information via environment variables:

```bash
docker run -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://<RDS_ENDPOINT>:5432/<DB_NAME> \
  -e SPRING_DATASOURCE_USERNAME=<DB_USER> \
  -e SPRING_DATASOURCE_PASSWORD=<DB_PASSWORD> \
  paw-pin-backend
```

The API will be available at `http://localhost:8080/users`.
=======
Run locally:

```bash
docker run -p 8080:8080 paw-pin-backend
```
