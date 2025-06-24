# 🧾 Workspace: Business Records & Workflow

This repository is used to track workflow and data collection within a distributed Slurm-based cluster environment.

---

## 🔄 Workflow Overview

The system is composed of the following nodes:

- **Login Server**: Entry point for users.
- **smaster**: Central node responsible for orchestrating data collection.
- **snode01 / snode02**: Worker nodes executing Slurm info scripts.

---

## 📊 Data Flow Diagram

[Login Server]
│
│ ssh
▼
[smaster] ──────────────┐
└─ slurminfo_all.sh │
└─ slurminfo.sh │
│
┌────────────────────┴────────────────────┐
│ ssh by smaster │ ssh by smaster
▼ ▼
[snode01] ─ slurminfo.sh [snode02] ─ slurminfo.sh

┌────────────────────────────────────────────────────────┐
│ smaster collects the results from all slurminfo.sh │
│ results and sends them to stdout │
└────────────────────────────────────────────────────────┘
│
▼
[Login Server] ←←←←← Output collected and formatted

yaml
복사
편집

---

## 🛠 Scripts Used

| Script            | Location   | Description                                |
|-------------------|------------|--------------------------------------------|
| `slurminfo.sh`    | All nodes  | Collects local Slurm node info             |
| `slurminfo_all.sh`| smaster    | Aggregates results from all compute nodes  |

---

## 📦 How to Use

1. SSH into the login server.
2. Execute the orchestration script:
   ```bash
   ssh smaster './slurminfo_all.sh'
View the collected output returned to the login server's terminal.

📁 Directory Structure
복사
편집
.
├── slurminfo_all.sh
├── slurminfo.sh
└── README.md
📌 Notes
Ensure ssh access is configured between smaster and all compute nodes.

The slurminfo.sh script should be executable and located in the same directory across all nodes.

yaml
복사
편집

