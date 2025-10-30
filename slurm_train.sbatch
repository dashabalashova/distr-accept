#!/bin/bash
#SBATCH --job-name=dist-accept
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --hint=nomultithread
#SBATCH --gres=gpu:8
#SBATCH --output=logs/deepspeed_%j.out
#SBATCH --error=logs/deepspeed_%j.err

set -euo pipefail
mkdir -p logs

MASTER_ADDR=$(scontrol show hostnames $SLURM_JOB_NODELIST | head -n 1)
MASTER_PORT=12345

GPUS_PER_NODE=8
NNODES=2

export LAUNCHER="python3 -u -m torch.distributed.launch \
    --nproc_per_node $GPUS_PER_NODE \
    --nnodes $NNODES \
    --master_addr $MASTER_ADDR \
    --master_port $MASTER_PORT \
    "

export CMD=" \
    /workspace/train.py
    --distributed-backend nccl \
    --deepspeed \
    "

echo $CMD

srun --jobid $SLURM_JOBID --container-image="$HOME/dist-accept-v0/deepspeed-train.sqsh" \
  --container-mounts="$SLURM_SUBMIT_DIR:/workspace" \
  bash -c '$LAUNCHER --node_rank $SLURM_PROCID $CMD'
