collect_data() {
    CURRENT_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

    PREVIOUS_USAGE=$(cat /tmp/disk_usage 2>/dev/null)

    if [ -z "$PREVIOUS_USAGE" ]; then
        PREVIOUS_USAGE=$CURRENT_USAGE
    fi

    SPEED=$((CURRENT_USAGE - PREVIOUS_USAGE))

    TOP_DIRS=$(du -h / | sort -hr | head)

    echo "$CURRENT_USAGE" > /tmp/disk_usage
}