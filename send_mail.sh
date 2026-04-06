#!/bin/bash
send_mail() {

    TEMPLATE="template.html"
    EMAIL="asmitterand@yahoo.fr"

    HTML=$(cat $TEMPLATE)

    HTML=$(echo "$HTML" | sed "s/{{CURRENT_USAGE}}/$CURRENT_USAGE/g")
    HTML=$(echo "$HTML" | sed "s/{{SPEED}}/$SPEED/g")
    HTML=$(echo "$HTML" | sed "s/{{CAUSE}}/$CAUSE/g")
    HTML=$(echo "$HTML" | sed "s/{{TOP_DIRS}}/$TOP_DIRS/g")

    echo "$HTML" | mail -a "Content-type: text/html" -s "Alerte Monitoring" $EMAIL
}