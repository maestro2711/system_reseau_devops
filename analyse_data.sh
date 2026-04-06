#!/bin/bash
    analyze_data() {

    for path in "${PATHS[@]}"; do

        CURRENT=${USAGE[$path]}
        CURRENT_SPEED=${SPEED[$path]}

        if [ "$CURRENT" -gt 90 ]; then

            # priorité vitesse (bug ou attaque)
            if [ "$CURRENT_SPEED" -gt 5 ]; then
                CAUSE["$path"]="BUG"
                continue
            fi

            # utilisateur
            if [ "$path" = "/home" ]; then
                CAUSE["$path"]="USER"
                continue
            fi

            # logs
            if [ "$path" = "/var" ]; then
                CAUSE["$path"]="LOG_CONFIG"
                continue
            fi

            # défaut
            CAUSE["$path"]="UNKNOWN"

        else
            CAUSE["$path"]="OK"
        fi

    done
}
    

    
