# 🧾 Workspace: Business Records & Workflow

This repository documents the data collection workflow within a Slurm-based cluster using SSH and simple shell scripts.

---

## 📊 Data Flow Overview

<pre><code>```############################################################

Data Flow Overview
[Login Server]
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
############################################################ ```</code></pre>


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
