#!/bin/bash
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
# 🔹 charger modules
source "$BASE_DIR/collecte_data.sh"
source "$BASE_DIR/analyse_data.sh"
source "$BASE_DIR/action.sh"
source "$BASE_DIR/manage_lvm.sh"
source "$BASE_DIR/send_mail.sh"
# 🔹 variables globalesssssssss
declare -A USAGE
declare -A SPEED
declare -A CAUSE

PATHS=("/" "/home" "/var")

LOG_FILE="/tmp/monitor.log"

# 🔹 execution

collect_data

analyze_data

take_action

#  LVM uniquement si nécessaire
for path in "${PATHS[@]}"; do
    if [ "${CAUSE[$path]}" = "USER" ] || [ "${CAUSE[$path]}" = "LOG_CONFIG" ]; then
        manage_lvm "$path"
    fi
done

# 🔹 envoyer mail si problème
for path in "${PATHS[@]}"; do
    if [ "${CAUSE[$path]}" != "OK" ]; then
        send_mail
        break
    fi
done

echo "$(date) - Run completed" >> "$LOG_FILE"