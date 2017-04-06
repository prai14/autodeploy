#!/bin/bash

#mount cdrom
#mount -rv cdrfs /dev/cd0 /mnt
 
VERSION="6100-04"
VERSION2=$(oslevel -r)
 
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -r | head -n 1)" == "$VERSION"; } 

if version_ge $VERSION $VERSION2; then
    echo "-----$VERSION is greater than or equal to $VERSION2-----"
    #mklv -y iso_lv datavg 10
    #dd if=test_unix_mount_iso.iso of=/dev/iso_lv bs=10M
    #mount -rv cdrfs /dev/iso_lv /mnt
else
    echo "-----$VERSION is less than $VERSION2-----"
    loopbackp=$(lslpp -l|grep loopback)
    loopmount=$(which loopmount)
    if [ "$loopbackp" != "" ] || [ "$loopmount" != "" ] ;then
        echo "-----AIX $(oslevel -r) ISO file mount-----"
        #loopmount -i PowerHA6.1.iso -o "-V cdrfs -o ro" -m /mnt
    fi
fi
