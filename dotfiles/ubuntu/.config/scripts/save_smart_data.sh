#!/bin/sh

FILE=smart-data-$(date +%Y%m%d-%H%M%S).txt

filter_block_devices() {
    while read DISK; do
        if [ -b "$DISK" ]; then
            # Is a block device
            echo "$DISK"
        fi
    done
}

list_of_disks() {
    # HDs and SSDs
    ls -1 /dev/[hsv]d* 2>/dev/null | grep -v '[0-9]$' | filter_block_devices

    # NVMe
    ls -1 /dev/nvme*n* 2>/dev/null | grep -v 'p[0-9]\+$' | filter_block_devices
}

echo "Writing to file '$FILE'" >&2

for DISK in $(list_of_disks); do
    echo "Reading SMART data of disk '$DISK'" >&2

    echo '#' smartctl -a "'$DISK'"
    sudo smartctl -a "$DISK" 2>&1
    echo
done > $FILE
