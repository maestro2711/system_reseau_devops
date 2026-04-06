#! /bin/bash
send_mail() {

    TEMPLATE="template.html"
    EMAIL="admin@example.com"

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

    HTML=$(echo "$HTML" | sed "s/{{ROWS}}/$ROWS/g")

    echo "$HTML" | mail -a "Content-type: text/html" -s "Monitoring Report" "$EMAIL"
}