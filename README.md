# 🧾 Workspace: Business Records & Workflow

This repository tracks workflow and data collection across a Slurm-based distributed environment.

---

## 📊 Data Flow Overview

############################################################

Data Flow Overview
[Login Server]
│
│ ssh
▼
[smaster] ──────────────┐
    └─ slurminfo_all.sh │
        └─ slurminfo.sh │
                        │
┌───────────────────────┴────────────────────┐
│ ssh by smaster                             │ ssh by smaster
▼                                            ▼
[snode01] ─ slurminfo.sh                 [snode02] ─ slurminfo.sh
┌────────────────────────────────────────────────────────┐
│   smaster collects the results from all slurminfo.sh   │
│           results and sends them to stdout             │
└────────────────────────────────────────────────────────┘
                        │
                        ▼
[Login Server] ←←←←← Output collected and formatted
############################################################



## 🛠 Components

| Role           | Description                                 |
|----------------|---------------------------------------------|
| `Login Server` | Starts the collection process via SSH       |
| `smaster`      | Runs `slurminfo_all.sh`, aggregates results |
| `snode01/02`   | Executes `slurminfo.sh`, returns metrics    |

## ▶️ Usage

```bash
ssh smaster './slurminfo_all.sh'
Results will be collected and shown on the login server terminal.

📁 Directory Structure
.
├── slurminfo_all.sh
├── slurminfo.sh
└── README.md
