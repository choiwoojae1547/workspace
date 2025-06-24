#!/bin/bash

SLURM_CLUSTER="C2"
hostname=$(hostname -s)

# Load averages
load_averages=$(uptime | awk -F'load average: ' '{print $2}' | tr -d ',')
r1m=$(echo "$load_averages" | awk '{printf "%.2f", $1}')
r5m=$(echo "$load_averages" | awk '{printf "%.2f", $2}')
r15s=$(echo "$load_averages" | awk '{printf "%.2f", $3}')

# CPU info
cpu=$(nproc)

# ut 계산
avg=$(echo "($r1m + $r5m + $r15s)/3" | bc -l)
ut=$(echo "$avg / $cpu * 100" | bc -l | awk '{printf "%d%%", $1}')

# 상태 확인
state=$(scontrol show node "$hostname" | awk -F= '/State=/{print $2}' | cut -d' ' -f1)
case "$state" in
  IDLE) status="ok" ;;
  ALLOCATED|ALLOC|MIXED) status="closed" ;;
  DOWN|DRAIN|FAIL) status="unavail" ;;
  *) status=$(echo "$state" | tr 'A-Z' 'a-z') ;;
esac

#TmpDisk 및 FreeMem 추출
tmp=$(scontrol show node "$hostname" | awk '{for(i=1;i<=NF;i++) if($i ~ /^TmpDisk=/){split($i,a,"="); print a[2]"G"}}')
freemem=$(scontrol show node "$hostname" | awk '{for(i=1;i<=NF;i++) if($i ~ /^FreeMem=/){split($i,a,"="); print a[2]}}')
mem=$(echo "$freemem" | awk '{printf "%.1fG", $1 / 1024}')

# 고정값
pg="0.0"; ls="1"; it="0"; swp="1G"

# 출력
printf "%-10s %-15s %-15s %-14s %5s %5s %5s %5s %5s %3s %5s %8s %8s %8s\n" \
  "SLURM" "$SLURM_CLUSTER" "$hostname" "$status" "$r15s" "$r1m" "$r5m" "$ut" "$pg" "$ls" "$it" "$tmp" "$swp" "$mem"
