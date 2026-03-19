#!/bin/bash
# This script is used to monitor the status of the server and send notifications if there are any issues.
SEUIL= 10 # Set the threshold for CPU usage
SEUIL_MEM=10
CPU_UTIL=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
MEM_UTIL=$(free | grep Mem | awk '{printf "%.0f", $3/$2*100}')
echo "Monitoring server status..."
if (( $(echo "$CPU_UTIL > $SEUIL" | bc -l) )); then

    echo "CPU usage is above the threshold.($CPU_UTIL%) Sending notification..."

    # Here you can add the code to send a notification, such as an email or a message to a monitoring system.
    mail -s "CPU Usage Alert" asmitterand@yahoo.fr
else
    echo "CPU usage is within the normal range."
fi

# You can also add similar checks for memory usage, disk space, and other system metrics as needed.
echo "Checking memory usage..."
if [ "$MEM_UTIL" -gt "$SEUIL_MEM" ]; then
    echo "Memory usage is above the threshold($MEM_UTIL%). Sending notification..."
    mail -s "Memory Usage Alert" asmitterand@yahoo.fr
else
    echo "Memory usage is within the normal range()."
fi