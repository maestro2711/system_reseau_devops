#!/bin/bash
# This script is used to monitor the status of the server and send notifications if there are any issues.
SEUIL= 80 # Set the threshold for CPU usage
SEUIL_MEM=70
echo "Monitoring server status..."
if [ $(top -bn1 | grep "Cpu(s)" | awk '{print (100 -$5} ') -gt $SEUIL ]; then
    echo "CPU usage is above the threshold. Sending notification..."

    # Here you can add the code to send a notification, such as an email or a message to a monitoring system.
    mail -s "CPU Usage Alert" asmitterandyahoo.fr
else
    echo "CPU usage is within the normal range."
fi

# You can also add similar checks for memory usage, disk space, and other system metrics as needed.
echo "Checking memory usage..."
if [ $(free  | grep "Mem" | awk '{print $3/$2 * 100.0}') -gt $SEUIL_MEM ]; then 
    echo "Memory usage is above the threshold. Sending notification..."
    mail -s "Memory Usage Alert" asmitterandyahoo.fr
else
    echo "Memory usage is within the normal range."
fi