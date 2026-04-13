#!/usr/bin/bash
set -euo pipefail
IFS=$'\n\t
declare -A USAGE
declare -A SPEED
declare -A CAUSE
collect_data() {

    PATHS=("/" "/home" "/var")

    

    for path in "${PATHS[@]}"; do

        #  sécuriser nom du path
        if [ "$path" = "/" ]; then
            SAFE_PATH="root"
        else
            SAFE_PATH=$(echo "$path" | tr -d '/')
        fi

        STATE_FILE="/var/tmp/monitor_$SAFE_PATH"

        #  usage actuel
        CURRENT_USAGE=$(df -h "$path" | awk 'NR==2 {print $5}' | tr -d '%')

        #  usage précédent
        PREVIOUS_USAGE=$(cat "$STATE_FILE" 2>/dev/null)

        if [ -z "$PREVIOUS_USAGE" ]; then
            PREVIOUS_USAGE=$CURRENT_USAGE
        fi

        # 🔹 vitesse
        SPEED_VALUE=$((CURRENT_USAGE - PREVIOUS_USAGE))

        # 🔹 stockage dans tableaux
        USAGE["$path"]=$CURRENT_USAGE
        SPEED["$path"]=$SPEED_VALUE

        # 🔹 sauvegarde état
        echo "$CURRENT_USAGE" > "$STATE_FILE"

        # 🔹 affichage debug
        echo "$path → usage: ${USAGE[$path]}% | speed: ${SPEED[$path]}"

    done
}
