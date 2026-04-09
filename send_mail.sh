#!/bin/bash
send_mail() {
    OUTPUT="/var/www/html/monitor.html"

    TEMPLATE="template.html"
    EMAIL="asmitterand@yahoo.fr"; "siandjipatrick@yahoo.fr"

    HTML=$(cat "$TEMPLATE")

    ROWS=""

    for path in "${PATHS[@]}"; do

        ROWS+="<tr>
<td>$path</td>
<td>${USAGE[$path]}</td>
<td>${SPEED[$path]}</td>
<td>${CAUSE[$path]}</td>
</tr>"

    done

    # 🔥 remplacement sécurisé
    HTML=${HTML//\{\{ROWS\}\}/$ROWS}
    # 🔥 écrire le fichier pour le web
echo "$HTML" > "$OUTPUT"



    echo "$HTML" | mail -a "Content-type: text/html" -s "Monitoring Report" "$EMAIL"
}