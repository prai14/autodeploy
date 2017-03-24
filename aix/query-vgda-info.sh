#!/bin/sh

echo "----------------VGDA/VGSA lqueryvg-------------------"
for i in `lspv|grep -v rootvg|awk '{print $1}'`
do
    echo "----------------------"
    echo "$i====>"
    echo "----------------------"
    echo "lqueryvg -Atp $i"
    echo "----------------------"
    lqueryvg -Atp $i
    echo "----------------------"
    echo "lqueryvg -Ptp $i"
    echo "----------------------"
    lqueryvg -Ptp $i
    echo "----------------------"
    echo "lqueryvg -Ltp $i"
    echo "----------------------"
    lqueryvg -Ltp $i
done
