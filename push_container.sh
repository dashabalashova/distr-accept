#!/usr/bin/env bash
set -euo pipefail


GHCR_IMAGE="${GHCR_IMAGE:-ghcr.io/dashabalashova/deepspeed-train:latest}"

echo "Pushing deepspeed-train:latest -> $GHCR_IMAGE on root@worker-0"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@worker-0 "cd /root/distr-accept/ \
  && docker tag deepspeed-train:latest '$GHCR_IMAGE' \
  && docker push '$GHCR_IMAGE'"