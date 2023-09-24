# Use an official CUDA runtime as a parent image
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash

# Update, upgrade, install packages and clean up
RUN apt-get update --yes && \
    apt-get upgrade --yes && \
    apt install --yes --no-install-recommends git wget curl bash software-properties-common nginx && \
    apt install python3.10-dev python3.10-venv -y --no-install-recommends && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

# Create vllm user
RUN useradd -ms /bin/bash vllm

# Set up Python and pip as root
RUN ln -s /usr/bin/python3.10 /usr/bin/python && \
    rm /usr/bin/python3 && \
    ln -s /usr/bin/python3.10 /usr/bin/python3 && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Setup virtual environment and install packages
RUN python3 -m venv /home/vllm/venvs/vllm && \
    . /home/vllm/venvs/vllm/bin/activate && \
    pip install --upgrade pip && \
    pip install --no-cache-dir "pandas>=1.3"

# Switch to vllm user
USER vllm

# Define environment variable to use virtual environment
ENV PATH="/home/vllm/venvs/vllm/bin:$PATH"
