# Dockerfile: python3 + CUDA 12.8 + deepspeed
FROM nvcr.io/nvidia/pytorch:24.07-py3

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      cmake \
      git \
      libopenmpi-dev \
      python3-dev \
      ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install --no-cache-dir --prefer-binary deepspeed

COPY train.py /workspace/train.py

CMD ["python3", "/workspace/train.py"]