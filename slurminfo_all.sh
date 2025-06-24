#!/bin/bash

# 현재 호스트 이름
my_hostname=$(hostname -s)

# 노드 리스트
nodes=$(/opt/meta_scheduler/bin/host_list.sh)

# 각 노드에 slurminfo_local.sh 실행 요청
for node in $nodes; do
  if [[ "$node" == "$my_hostname" ]]; then
    /opt/meta_scheduler/bin/slurminfo.sh
  else
    ssh "$node" /opt/meta_scheduler/bin/slurminfo.sh
  fi
done
