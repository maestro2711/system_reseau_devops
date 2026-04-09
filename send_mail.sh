#!/bin/bash
send_mail() {
    OUTPUT="/var/www/html/monitor.html"

    BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
    TEMPLATE="$BASE_DIR/template.html"
    EMAIL="asmitterand@yahoo.fr"; 

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
echo "TEMPLATE=$TEMPLATE" >> /tmp/debug.log



    echo "$HTML" | mail -a "Content-type: text/html" -s "Monitoring Report" "$EMAIL"
}