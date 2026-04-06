
    analyze_data() {

    CAUSE="UNKNOWN"

    if [ "$CURRENT_USAGE" -gt 90 ]; then
        
        # vitesse
        if [ "$SPEED" -gt 5 ]; then
            CAUSE="BUG"
        fi

        # dossiers
        if echo "$TOP_DIRS" | grep -q "/home"; then
            CAUSE="USER"
        fi

        if echo "$TOP_DIRS" | grep -q "/var/log"; then
            CAUSE="LOG_CONFIG"
        fi
    fi
}
    

    
