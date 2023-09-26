## VSCode Remote Kernel Setup

- [Setup Guide](https://github.com/RupeeSense/llm-experiments/blob/main/dev-utilities/gcp/vscode_remote_kernel_setup/readme.md)

## Creating a Conda Virtual Environment

To create and activate a new Conda environment named `rs-vllm`:

```bash
conda create -n rs-vllm python=3.10 -y
conda activate rs-vllm
conda install -c conda-forge accelerate
```

## Building `vllm` from Source

### Installing Dependencies

To install the necessary Python packages in "editable" or "develop" mode:

```bash
pip install -r requirements.txt
pip install -e .  # This may take several minutes.
```

### To run locally

To get hf access token: https://huggingface.co/settings/tokens

```bash
huggingface-cli login
python -m vllm.entrypoints.openai.api_server \
--model meta-llama/Llama-2-7b-hf
```

### Sample test request

```python
curl http://localhost:8000/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
        "model": "meta-llama/Llama-2-7b-hf",
        "messages": '[{"role":"system", "content": "be a good bot! "}, {"role": "user", "content": "Hi, how are you?"}]',
        "max_tokens": 1024,
        "temperature": 0.8,
        "ignore_eos": false
    }'
```

### Creating Distribution Archives

To generate distribution archives:

```bash
python setup.py sdist bdist_wheel  # This may take several minutes.
```

## Setting vanilla llama2 for testing
```bash
cd ~
conda create -n rs-vanilla-llama python=3.10 -y
conda activate rs-vanilla-llama
git clone https://github.com/facebookresearch/llama.git
cd llama
pip install -r requirements.txt
mkdir llama-model
gsutil cp -r gs://llm-experiments-bucket/ llama-model/
torchrun --nproc_per_node 1 example_chat_completion.py \
    --ckpt_dir llama-model/llm-experiments-bucket/llama-model/llama-2-7b/ \
    --tokenizer_path llama-model/llm-experiments-bucket/llama-model/tokenizer.model \
    --max_seq_len 512 --max_batch_size 6
```

## Pushing the Built VLLM Package to GCP Artifacts Registry

1. **Authenticate with gcloud**
    Ensure you are authenticated with the gcloud CLI and have selected the correct project:
    
    ```bash
    gcloud auth login
    gcloud config set project ardent-firefly-398508
    ```

2. **Upload vllm python Package**

   To push the package:

   ```bash
   sh upload_to_artifacts_registry.sh
   ```
## Building and pushing vllm Docker Image

1. **Authenticate Docker CLI with GCloud Artifacts Registry**

   To grant permissions to interact with the Google Cloud Artifacts Registry:

   ```bash
   gcloud auth configure-docker us-central1-docker.pkg.dev
   ```

2. **Build docker image**
    ```bash
    TOKEN=$(gcloud auth print-access-token)
    echo $TOKEN
    docker build \
    --build-arg TOKEN=$TOKEN \
    --build-arg ARTIFACTS_REPO_URI="us-central1-python.pkg.dev/ardent-firefly-398508/rs-pypi/simple/" \
    --platform linux/amd64 \
    -t us-central1-docker.pkg.dev/ardent-firefly-398508/rs-docker/vllm/vllm:cuda11.8.0-ubuntu22.04-python310v0.1 \
    -f Dockerfile .
    ```

3. **Push docker image**
    ```bash
    docker push us-central1-docker.pkg.dev/ardent-firefly-398508/rs-docker/vllm/vllm:cuda11.8.0-ubuntu22.04-python310v0.1
    ```

4. **To test docker image in local**
    ```bash
    docker run --network="host" \
    --gpus all \
    -it \
    us-central1-docker.pkg.dev/ardent-firefly-398508/rs-docker/vllm/vllm:cuda11.8.0-ubuntu22.04-python310v0.1 \
    python -m vllm.entrypoints.openai.api_server     --model facebook/opt-125m
    ```

## Building the Base Docker Image

For instructions on building the base Docker image, refer to the [Base Docker Build Guide](https://github.com/RupeeSense/vllm/blob/rs-dev/docker/readme.md).

---