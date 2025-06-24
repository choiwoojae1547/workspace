# workspace
For business records

work flow

############################################################
# Data Flow Overview
#
#  [Login Server]
#       │
#       │ ssh
#       ▼
#  [smaster] ──────────────┐
#     └─ slurminfo_all.sh  │
#     └─ slurminfo.sh      │
#                          │
#     ┌────────────────────┴────────────────────┐
#     │ ssh by smaster                          │ ssh by smaster
#     ▼                                         ▼
# [snode01] ─ slurminfo.sh            [snode02] ─ slurminfo.sh
#
#   ┌────────────────────────────────────────────────────────┐
#   │  smaster collects the results from all slurminfo.sh    │
#   │  results and sends them to stdout                      │
#   └────────────────────────────────────────────────────────┘
#                          │
#                          ▼
#  [Login Server] ←←←←← Output collected and formatted
#
############################################################
