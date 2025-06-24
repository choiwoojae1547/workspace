# 🧾 Workspace: Business Records & Workflow

This repository documents the data collection workflow within a Slurm-based cluster using SSH and simple shell scripts.

lsf + slurm 명령어 통합을 위한 메타 스케줄러 커맨드 통합 스크립트 작업 내용입니다.
lsf의 명령어 + slurm의 명령어 조합을 통해 공통된 m 커맨드 스크립트 입니다.
예) mhosts -> bhosts + sinfo 정보 파싱..

전체적인 작업 개요는
프록시 서버를 통해 로그인 서버로 접속합니다.
로그인 서버에서 m 커맨드를 적용시켜야 하며 
LSF의 클러스터 명은 c1 / 마스터 명은 lmaster
SLURM의 클러스터 명은 c2 / 마스터 명은 lmaster
입니다.
자세한 데이터 흐름 개요는 밑은 도식표를 참고해주세요.
---

## 📊 Data Flow Overview

<pre><code>```

Data Flow Overview
[Proxy Server]
    │
    │ ssh
    ▼             ssh
[Login Server] ──────────▶ lmaster
    │
    │ ssh
    ▼
[smaster] ──────────────┐
    ├─ slurminfo_all.sh │
    └─ slurminfo.sh     │
                        │
┌───────────────────────┴────────────────────┐
│ ssh by smaster                             │ ssh by smaster
▼                                            ▼
[snode01] ─ slurminfo.sh                 [snode02] ─ slurminfo.sh
┌────────────────────────────────────────────────────────┐
│   smaster collects the results from all slurminfo.sh   │
│            results and sends them to stdout            │
└────────────────────────────────────────────────────────┘
                         │
                         ▼
                   [Login Server] ←←←←← Output collected and formatted
 ```</code></pre>


## 🧩 Components

| Role           | Description                                        |
|----------------|----------------------------------------------------|
| `Login Server` | Starts the collection process via SSH              |
| `smaster`      | Runs `slurminfo_all.sh`, aggregates results        |
| `snode01/02`   | Executes `slurminfo.sh`, returns metrics to master |

---

## ▶️ Usage

```bash
ssh smaster './slurminfo_all.sh'
Results will be collected from all compute nodes and displayed on the login server terminal.

📁 Directory Structure
.
├── slurminfo_all.sh     # Orchestration script on smaster
├── slurminfo.sh         # Node-level data collection script
└── README.md            # This file
