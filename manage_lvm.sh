manage_lvm() {

    # critical threshold
    if [ "$CURRENT_USAGE" -lt 95 ]; then
        return
    fi

    # securitary check
    if [ "$CAUSE" = "BUG" ] || [ "$CAUSE" = "ATTACK" ]; then
        echo "refused extension (BUG/ATTACK)" >> /var/log/monitor.log
        return
    fi

    VG_NAME="vg_data"
    LV_PATH="/dev/vg_data/lv_root"

    # check free space in VG
    VG_FREE=$(vgs --noheadings -o vg_free --units g $VG_NAME | tr -d ' g')

    if (( $(echo "$VG_FREE > 1" | bc -l) )); then
        lvextend -L +1G $LV_PATH
        resize2fs $LV_PATH
        echo "LVM étendu (VG free)" >> /var/log/monitor.log
        return
    fi

    #  multi-disk : search new disk
    for disk in $(lsblk -dn -o NAME,TYPE | grep disk | awk '{print $1}'); do

        # skip if  disk is in PV
        if pvs | grep -q "$disk"; then
            continue
        fi

        # skip if disk is mounted
        if mount | grep -q "$disk"; then
            continue
        fi

        NEW_DISK="/dev/$disk"
        break
    done

    if [ -z "$NEW_DISK" ]; then
        echo "no available disk" >> /var/log/monitor.log
        return
    fi

    # disk found, add to VG and extend LV
    pvcreate $NEW_DISK
    vgextend $VG_NAME $NEW_DISK

    lvextend -L +5G $LV_PATH
    resize2fs $LV_PATH

    echo "new disk added and extended" >> /var/log/monitor.log
}