# paw_pin_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Backend

A Spring Boot service that communicates with Anthropic Claude is available under [`backend/`](backend/). This service has been renamed **llm-service** and now exposes both its original REST API and a new gRPC interface defined in [`protos/llm.proto`](protos/llm.proto).

An additional lightweight Python gateway is provided under [`gateway/`](gateway/). The gateway accepts REST requests and forwards them to `llm-service` using gRPC.

## AWS Deployment

See [docs/aws_setup.md](docs/aws_setup.md) for instructions on deploying the backend and Flutter app using Amazon EKS and other free tier AWS services.
