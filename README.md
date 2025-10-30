# dist-accept

```
export CR_PAT=<ghp_...>
export GIT_USER=<git_user>
echo "$CR_PAT" | docker login ghcr.io -u "$GIT_USER" --password-stdin
```

```
git clone https://github.com/dashabalashova/distr-accept.git
cd distr-accept
chmod +x docker.sh
./docker.sh
```

```
NODES=$(scontrol show nodes | grep -c '^NodeName')
GPUS=$(scontrol show nodes | sed -n 's/.*CfgTRES=.*gres\/gpu=\([0-9][0-9]*\).*/\1/p' | head -n1)
sed -e "s/^#SBATCH --nodes=.*/#SBATCH --nodes=${NODES}/" \
    -e "s/^#SBATCH --gres=gpu:.*/#SBATCH --gres=gpu:${GPUS}/" \
    slurm_train.sbatch > slurm_train.submit.sbatch
sbatch --export=ALL,GPUS_PER_NODE="$GPUS",NNODES="$NODES" slurm_train.submit.sbatch
```

```
tail -f logs/distr-accept_<N>.*
```