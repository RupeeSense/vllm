FROM us-central1-docker.pkg.dev/ardent-firefly-398508/rs-docker/vllm/base:cuda11.8.0-ubuntu22.04-python310v0.4

ARG TOKEN
ARG ARTIFACTS_REPO_URI

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash

COPY ./requirements.txt ./
RUN pip install -r requirements.txt --no-cache-dir

# Install vllm
RUN pip install --upgrade --no-cache-dir vllm --extra-index-url=https://oauth2accesstoken:$TOKEN@$ARTIFACTS_REPO_URI && rm -rf /root/.cache/pip