#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="/etc/monitoring/monitoring.conf"

# 1. Collecte
/data/monitoring/bin/collect_data.sh "$CONFIG_FILE"

# 2. Analyse
/data/monitoring/bin/analyze_data.sh

# 3. Actions (LVM, nettoyage, etc.)
/data/monitoring/bin/take_action.sh

# 4. Envoi d’alertes
/data/monitoring/bin/send_mail.sh
# elargir disk si nécessaire
/data/monitoring/bin/manage_lvm.sh