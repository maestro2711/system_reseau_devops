#!/bin/bash

source config.sh
source collect.sh
source analyze.sh
source action.sh
source manage_lvm.sh
source send_mail.sh

LOG_FILE="/var/log/monitor.log"

while true; do

    collect_data

    analyze_data

    take_action

    manage_lvm

    # send alert if critical
    if [ "$CURRENT_USAGE" -gt 90 ]; then
        send_mail
    fi

    echo "$(date) - CHECK OK - USAGE=$CURRENT_USAGE%" >> $LOG_FILE

    sleep 60

done