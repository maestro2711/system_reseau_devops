#!/usr/bin/bash
take_action() {

    for path in "${PATHS[@]}"; do

        # sécuriser nom
        if [ "$path" = "/" ]; then
            SAFE_PATH="root"
        else
            SAFE_PATH=$(echo "$path" | tr -d '/')
        fi

        LOG_FILE="/var/tmp/monitor_$SAFE_PATH.log"

        case "${CAUSE[$path]}" in

            "USER")
                echo "$(date) - USER issue on $path" >> "$LOG_FILE"
                ;;

            "BUG")
                echo "$(date) - BUG detected on $path" >> "$LOG_FILE"
                # ex: kill process (à améliorer)
                ;;

            "ATTACK")
                echo "$(date) - ATTACK detected on $path" >> "$LOG_FILE"
                # ex: iptables (à améliorer)
                ;;

            "LOG_CONFIG")
                echo "$(date) - LOG issue on $path" >> "$LOG_FILE"
                logrotate -f /etc/logrotate.conf
                ;;

            "OK")
                echo "$(date) - OK on $path" >> "$LOG_FILE"
                ;;

            *)
                echo "$(date) - UNKNOWN issue on $path" >> "$LOG_FILE"
                ;;

        esac

    done
}