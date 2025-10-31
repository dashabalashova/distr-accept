# Dockerfile: python3 + CUDA 12.8 + deepspeed
FROM nvcr.io/nvidia/pytorch:24.07-py3

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 -m pip install deepspeed

COPY train.py /workspace/train.py
CMD ["python3", "/workspace/train.py"]