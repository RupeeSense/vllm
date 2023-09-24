FROM us-central1-docker.pkg.dev/ardent-firefly-398508/rs-docker/vllm/base:cuda11.8.0-ubuntu22.04-python310v0.1

# Accept the TOKEN as a build argument
ARG TOKEN
ARG ARTIFACTS_REPO_URI

ENV PYTHON_EXECUTABLE python3

RUN grep -w 'ID=debian\|ID_LIKE=debian' /etc/os-release || { echo "ERROR: Supplied base image is not a debian image"; exit 1; }
RUN $PYTHON_EXECUTABLE -c "import sys; sys.exit(0) if sys.version_info.major == 3 and sys.version_info.minor >=8 and sys.version_info.minor <=11 else sys.exit(1)" \
    || { echo "ERROR: Supplied base image does not have 3.8 <= python <= 3.11"; exit 1; }

COPY ./requirements.txt ./
RUN pip install --upgrade pip && \
    pip install -r requirements.txt --no-cache-dir

RUN pip install vllm --extra-index-url=https://oauth2accesstoken:$TOKEN@$ARTIFACTS_REPO_URI