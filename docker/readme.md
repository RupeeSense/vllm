# Docker Operations with Google Cloud Artifacts Registry

This guide describes the process of building and pushing a VLLM base docker image to the Google Cloud Artifacts Registry.

## Prerequisites

Ensure you have the following tools installed:
- Docker CLI
- `gcloud` SDK

## Steps

### 1. Authenticate Docker CLI with GCloud Artifacts Registry

To allow Docker to push and pull images from the Google Cloud Artifacts Registry, run:

```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

### 2. Build the Base Docker Image

Use the following command to build the base Docker image:

```bash
docker build --platform linux/amd64 -t us-central1-docker.pkg.dev/ardent-firefly-398508/llm-experiments/vllm/base:v0.1 -f docker/base.dockerfile .
```

### 3. Push the Base Docker Image to the Registry

Once the build completes, push the Docker image to the Google Cloud Artifacts Registry using:

```bash
docker push us-central1-docker.pkg.dev/ardent-firefly-398508/llm-experiments/vllm/base:v0.1
```
---