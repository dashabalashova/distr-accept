#!/usr/bin/env bash
set -euo pipefail

echo "Launch on root@worker-0 ..."
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@worker-0 bash <<'REMOTE_EOF'
set -euo pipefail
cd /root/distr-accept/
echo "Building docker image in $(pwd)..."
docker build -t deepspeed-train:latest .
enroot import --output deepspeed-train.sqsh dockerd://deepspeed-train:latest
echo "Done: deepspeed-train.sqsh created in $(pwd)"
REMOTE_EOF