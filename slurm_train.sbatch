#!/bin/bash
#SBATCH --job-name=distr-accept
#SBATCH --nodes=0
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --hint=nomultithread
#SBATCH --gres=gpu:0
#SBATCH --output=logs/distr-accept_%j.out
#SBATCH --error=logs/distr-accept_%j.err

set -euo pipefail
mkdir -p logs

MASTER_ADDR=$(scontrol show hostnames $SLURM_JOB_NODELIST | head -n 1)
MASTER_PORT=12345
export OMP_NUM_THREADS=1

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

if srun --jobid $SLURM_JOBID --container-image="$SLURM_SUBMIT_DIR/deepspeed-train-3.sqsh" \
        --container-mounts="$SLURM_SUBMIT_DIR:/workspace" \
        bash -c '$LAUNCHER --node_rank $SLURM_PROCID $CMD'; then
  echo "✅ job success"
else
  echo "❌ job fail"  
  
  # ./push_container.sh
  # PUSH_SCRIPT="${SLURM_SUBMIT_DIR}/push_container.sh"
  # chmod +x "$PUSH_SCRIPT"
  # echo "pushing container ..."
  # bash -c "$PUSH_SCRIPT"
  # echo "✅ container pushed"
# else
  # echo "❌ job failed"
# fi