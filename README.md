# 🧾 Workspace: Business Records & Workflow

This repository documents the **data collection and integration workflow** within a Slurm-based and LSF-based cluster using SSH and simple shell scripts.

---

## 🎯 Purpose

This project focuses on building a **meta-scheduler command wrapper** that unifies **LSF + Slurm commands** into a single, easy-to-use interface.

✅ Example:
- `mhosts` → parses and merges outputs from both `bhosts` (LSF) and `sinfo` (Slurm)
- Other commands (e.g., `mqueues`, `mload`) follow the same logic

These meta-commands allow operators to manage mixed scheduling environments more efficiently from one command namespace (`m*`).

---

## 🏗 Architecture & Configuration

- **Login Access**: Connect to the system via a **proxy server → login server**
- **Command Execution Point**: All `m*` scripts are executed on the **login server**
- **Cluster Names**:
  - **LSF**:
    - Cluster name: `c1`
    - Master node: `lmaster`
  - **Slurm**:
    - Cluster name: `c2`
    - Master node: `smaster`

📌 *All relevant SSH and scheduling communication is initiated from the login server.*

---

## 🧭 Data Flow Diagram

See below for a visualized overview of the data flow across components.

<details>
<summary>📈 Click to view diagram</summary>
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
