# AWS Deployment Guide

This document outlines the steps to deploy the Flutter application and the Spring Boot backend on AWS using only free tier services.

## Prerequisites

- AWS account with IAM user and programmatic access.
- AWS CLI configured locally (`aws configure`).
- `eksctl` and `kubectl` installed.
- Docker installed for building container images.

## Steps

1. **Create an ECR repository** for the backend container:
   ```bash
   aws ecr create-repository --repository-name paw-pin-backend --profile pawpin
   ```
2. **Build and push the Docker image**:
   ```bash
   cd ../backend
   aws ecr get-login-password --region eu-central-1 --profile pawpin | \
   docker login --username AWS --password-stdin 574067620045.dkr.ecr.eu-central-1.amazonaws.com | \
   docker buildx build --platform linux/amd64 -t paw-pin-backend . |  \
   docker tag paw-pin-backend:latest 574067620045.dkr.ecr.eu-central-1.amazonaws.com/paw-pin-backend:latest | \
   docker push 574067620045.dkr.ecr.eu-central-1.amazonaws.com/paw-pin-backend:latest
   ```
   
[//]: # (TODO delete cluster.yaml, we will deploy EKS from AWS)
[//]: # (3. **Provision the EKS cluster** using `eksctl`:)

[//]: # (   ```bash)

[//]: # (   eksctl create cluster -f infra/eks/cluster.yaml)

[//]: # (   ```)

1. **Deploy Kubernetes resources**:
   ```bash
   kubectl apply -f ../k8s/namespace.yaml
   # kubectl apply -f k8s/secret-example.yaml   # Edit with real values
   kubectl apply -f ../k8s/deployment.yaml
   kubectl apply -f ../k8s/service.yaml
   ```
2. **Access the application**: obtain the service's external IP:
   ```bash
   kubectl get svc -n paw-pin
   ```
3. **Cleanup** when done to stay within the free tier:
   ```bash
   eksctl delete cluster --name paw-pin-cluster
   aws ecr delete-repository --repository-name paw-pin-backend --force
   ```

## CI/CD

A sample GitHub Actions workflow is located in `.github/workflows/deploy.yml`. It builds the Docker image, pushes it to ECR, and deploys to EKS on every push to `main`.

