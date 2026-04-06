#!/bin/bash

manage_lvm() {

    path=$1

    CURRENT=${USAGE[$path]}
    CURRENT_CAUSE=${CAUSE[$path]}

    LOG_FILE="/var/log/monitor.log"

    # 🔹 seuil critique
    if [ "$CURRENT" -lt 95 ]; then
        return
    fi

    # 🔹 sécurité (ne pas masquer bug/attaque)
    if [ "$CURRENT_CAUSE" = "BUG" ] || [ "$CURRENT_CAUSE" = "ATTACK" ]; then
        echo "$(date) - REFUSED LVM ($CURRENT_CAUSE) on $path" >> "$LOG_FILE"
        return
    fi

    # 🔹 récupérer le device (LV)
    LV_PATH=$(df -h "$path" | awk 'NR==2 {print $1}')

    # 🔹 type filesystem
    FS_TYPE=$(df -T "$path" | awk 'NR==2 {print $2}')

    # 🔹 récupérer VG
    VG_NAME=$(lvs --noheadings -o vg_name "$LV_PATH" | tr -d ' ')
    VG_FREE=$(vgs --noheadings -o vg_free --units g "$VG_NAME" | tr -d ' g')

    # 🔹 cas 1 : espace disponible dans VG
    if (( $(echo "$VG_FREE > 1" | bc -l) )); then

        lvextend -L +1G "$LV_PATH"

        if [ "$FS_TYPE" = "xfs" ]; then
            xfs_growfs "$path"
        else
            resize2fs "$LV_PATH"
        fi

        echo "$(date) - LVM extended (VG free) on $path" >> "$LOG_FILE"
        return
    fi

    # 🔥 cas 2 : VG plein → chercher nouveau disque sécurisé

    for disk in $(lsblk -dn -o NAME,TYPE | grep disk | awk '{print $1}'); do

        DEV="/dev/$disk"

        # skip si déjà utilisé par LVM
        if pvs | grep -q "$DEV"; then
            continue
        fi

        # skip si monté
        if mount | grep -q "$DEV"; then
            continue
        fi

        # skip si contient déjà un filesystem
        if blkid "$DEV" >/dev/null 2>&1; then
            continue
        fi

        NEW_DISK="$DEV"
        break
    done

    # 🔹 aucun disque disponible
    if [ -z "$NEW_DISK" ]; then
        echo "$(date) - No safe disk available for $path" >> "$LOG_FILE"
        return
    fi

    # 🔹 ajout disque sécurisé
    pvcreate "$NEW_DISK"
    vgextend "$VG_NAME" "$NEW_DISK"

    lvextend -L +5G "$LV_PATH"

    if [ "$FS_TYPE" = "xfs" ]; then
        xfs_growfs "$path"
    else
        resize2fs "$LV_PATH"
    fi

    echo "$(date) - New disk added and extended on $path ($NEW_DISK)" >> "$LOG_FILE"
}