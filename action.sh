action_take(){
    case "$CAUSE" in

    "USER")
       # setquota -u <user> <soft> <hard> 0 0 /home
        echo "User issue" >> /var/log/monitor.log
        ;;

    "BUG")
       # kill -9 <PID>
        echo "BUG detected and terminated" >> /var/log/monitor.log
        ;;

    "ATTACK")
        #iptables -A INPUT -s <IP> -j DROP
        echo "Attack blocked from <IP>" >> /var/log/monitor.log
        ;;

    "LOG_CONFIG")
        logrotate -f /etc/logrotate.conf
        echo "Log configuration updated" >> /var/log/monitor.log
        ;;

esac
}