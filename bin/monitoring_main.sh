#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="/etc/monitoring/monitoring.conf"

# 1. Collecte
/claude/repo/bin/collect_data.sh "$CONFIG_FILE"

# 2. Analyse
claude/repo/bin/analyze_data.sh

# 3. Actions (LVM, nettoyage, etc.)
/claude/repo/bin/take_action.sh

# 4. Envoi d’alertes
/claude/repo/bin/send_mail.sh
# elargir disk si nécessaire
claude/repo/bin/manage_lvm.sh