# AWS Deployment Guide

This document outlines the steps to deploy the Flutter application and the Spring Boot backend on AWS using only free tier services.

## Prerequisites

- AWS account with IAM user and programmatic access.
- AWS CLI configured locally (`aws configure`).
- `eksctl` and `kubectl` installed.
- Docker installed for building container images.

## Steps

1. **Create ECR repositories** for all services:
   ```bash
   aws ecr create-repository --repository-name paw-pin-llm-service --profile pawpin
   aws ecr create-repository --repository-name paw-pin-rds-service --profile pawpin
   aws ecr create-repository --repository-name paw-pin-central-service --profile pawpin
   aws ecr create-repository --repository-name paw-pin-gateway --profile pawpin
   ```
   
2. **Build and push the llm-service Docker image**:
   ```bash
   cd ../backend
   aws ecr get-login-password --region eu-central-1 --profile pawpin | \
   docker login --username AWS --password-stdin 574067620045.dkr.ecr.eu-central-1.amazonaws.com | \
   docker buildx build --platform linux/amd64 -t paw-pin-llm-service . |  \
   docker tag paw-pin-llm-service:latest 574067620045.dkr.ecr.eu-central-1.amazonaws.com/paw-pin-llm-service:latest | \
   docker push 574067620045.dkr.ecr.eu-central-1.amazonaws.com/paw-pin-llm-service:latest
   ```

3. **Build and push the rds-service Docker image**:
   ```bash
   cd ../rds-service
   aws ecr get-login-password --region eu-central-1 --profile pawpin | \
   docker login --username AWS --password-stdin 574067620045.dkr.ecr.eu-central-1.amazonaws.com | \
   docker buildx build --platform linux/amd64 -t paw-pin-rds-service . | \
   docker tag paw-pin-rds-service:latest 574067620045.dkr.ecr.eu-central-1.amazonaws.com/paw-pin-rds-service:latest | \
   docker push 574067620045.dkr.ecr.eu-central-1.amazonaws.com/paw-pin-rds-service:latest
   ```

4. **Build and push the central-service Docker image**:
   ```bash
   cd ../central-service
   aws ecr get-login-password --region eu-central-1 --profile pawpin | \
   docker login --username AWS --password-stdin 574067620045.dkr.ecr.eu-central-1.amazonaws.com
   docker buildx build --platform linux/amd64 -t paw-pin-central-service .
   docker tag paw-pin-central-service:latest 574067620045.dkr.ecr.eu-central-1.amazonaws.com/paw-pin-central-service:latest
   docker push 574067620045.dkr.ecr.eu-central-1.amazonaws.com/paw-pin-central-service:latest
   ```
   
5. **Build and push the grpc gateway image**:
   ```bash
   cd ../gateway
   aws ecr get-login-password --region eu-central-1 --profile pawpin | \
   docker login --username AWS --password-stdin 574067620045.dkr.ecr.eu-central-1.amazonaws.com
   docker buildx build --platform linux/amd64 -t paw-pin-gateway .
   docker tag paw-pin-gateway:latest 574067620045.dkr.ecr.eu-central-1.amazonaws.com/paw-pin-gateway:latest
   docker push 574067620045.dkr.ecr.eu-central-1.amazonaws.com/paw-pin-gateway:latest
   ```

6. **Deploy Kubernetes resources**:
   ```bash
   kubectl apply -f ../k8s/namespace.yaml
   kubectl apply -f ../k8s/rds-deployment.yaml
   kubectl apply -f ../k8s/rds-service.yaml
   kubectl apply -f ../k8s/central-deployment.yaml
   kubectl apply -f ../k8s/central-service.yaml
   kubectl apply -f ../k8s/gateway-deployment.yaml
   kubectl apply -f ../k8s/gateway-service.yaml
   kubectl apply -f ../k8s/llm-deployment.yaml
   kubectl apply -f ../k8s/llm-service.yaml
   ```
   
7. **Access the application**: obtain the service's external IP:
   ```bash
   kubectl get svc -n paw-pin
   ```

## CI/CD
A sample GitHub Actions workflow is located in `.github/workflows/deploy.yml`. It builds the Docker image, pushes it to ECR, and deploys to EKS on every push to `main`.

