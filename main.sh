#!/bin/bash

# 🔹 charger modules
source ./collect_data.sh
source ./analyze_data.sh
source ./take_action.sh
source ./manage_lvm.sh
source ./send_mail.sh

# 🔹 variables globales
declare -A USAGE
declare -A SPEED
declare -A CAUSE

PATHS=("/" "/home" "/var")

LOG_FILE="/var/log/monitor.log"

# 🔹 execution

collect_data

analyze_data

take_action

# 🔥 LVM uniquement si nécessaire
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