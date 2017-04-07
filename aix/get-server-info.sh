#!/bin/sh

#Model
echo "------------------------------------Model Info------------------------------------"
#Power8 
#8286-41A IBM Power System S814
#8286-42A IBM Power System S824
#8408-E8E IBM Power System E850
#Power7
#8202-E4D IBM Power 720 Express
#8233-E8B IBM Power 750 Express
#Power6 
#8203-E4A IBM Power 520 Express
#9407-M15 IBM Power 520 Express
#9408-M25 IBM Power 520 Express
#8204-E8A IBM Power 550 Express
#9409-M50 IBM Power 550 Express
#8234-EMA IBM Power 560 Express
#9117-MMA IBM Power 570

#lsattr -El sys0|grep systemid
#lsattr -El sys0|grep modelname
unamem=$(uname -M|awk -F, '{print $2}')
unameu=$(uname -u|awk -F, '{print $2}')
sn=$(prtconf|grep "Machine Serial Number"|awk -F: '{print $2}'|xargs)
ctype=$(prtconf|grep "Processor Implementation Mode"|awk -F: '{print $2}'|xargs)

case $(uname -M|awk -F, '{print $2}') in
    8286-41A)
        echo "IBM Power System S814|IBM $unamem|$ctype|IBM $unameu|Machine SN-->$sn"
    ;;
    8286-42A)
        echo "IBM Power System S824|IBM $unamem|$ctype|IBM $unameu|Machine SN-->$sn"
    ;;
    8408-E8E)
        echo "IBM Power System E850|IBM $unamem|$ctype|IBM $unameu|Machine SN-->$sn"
    ;;
    8202-E4D)
        echo "IBM Power 720 Express|IBM $unamem|$ctype|IBM $unameu|Machine SN-->$sn"
    ;;
    8233-E8B)
        echo "IBM Power 750 Express|IBM $unamem|$ctype|IBM $unameu|Machine SN-->$sn"
    ;;
    8203-E4A)
        echo "IBM Power 520 Express|IBM $unamem|$ctype|IBM $unameu|Machine SN-->$sn"
    ;;
    9407-M15)
        echo "IBM Power 520 Express|IBM $unamem|$ctype|IBM $unameu|Machine SN-->$sn"
    ;;
    9408-M25)
        echo "IBM Power 520 Express|IBM $unamem|$ctype|IBM $unameu|Machine SN-->$sn"
    ;;
    8204-E8A)
        echo "IBM Power 550 Express|IBM $unamem|$ctype|IBM $unameu|Machine SN-->$sn"
    ;;
    9409-M50)
        echo "IBM Power 550 Express|IBM $unamem|$ctype|IBM $unameu|Machine SN-->$sn"
    ;;
    8234-EMA)
        echo "IBM Power 560 Express|IBM $unamem|$ctype|IBM $unameu|Machine SN-->$sn"
    ;;
    9117-MMA)
        echo "IBM Power 570|IBM $unamem|$ctype|IBM $unameu|Machine SN-->$sn"
    ;;              
esac

#CPU
#a=$(echo "scale=3;13/2"|bc)
#pmcycles -m|wc -l
echo "------------------------------------CPU Info--------------------------------------"
pcpu=$(lsdev -Ccprocessor|wc -l|xargs)
smt=$(lsattr -El proc0|grep smt_threads|awk '{print $2}') 
type=$(lsattr -El proc0|grep type|awk '{print $2}')
freq=$(echo "scale=3;$(lsattr -El proc0|grep frequency|awk '{print $2}')/1000/1000/1000"|bc)
lcpu=$(echo "$smt*$pcpu=$(echo "scale=0;$smt*$pcpu"|bc)")
cpub=$(prtconf -c|awk -F: '{print $2}'|xargs)

echo "PCPU-->$pcpu|SMT-->$smt|LCPU-->$lcpu|CPU Type-->$type|Freq-->${freq}GHz|CPU Bits-->$cpub"
lsdev -Ccprocessor

#Memory
#lsattr -El sys0|grep realmem
#bootinfo -r
echo "----------------------------------Memory Info-------------------------------------"
mem=$(prtconf|grep "Good Memory Size"|awk -F: '{print $2}'|xargs)
pg=$(prtconf|grep "Total Paging Space"|awk -F: '{print $2}'|xargs)
mslot=$(lscfg -vp|grep "Memory DIMM"|wc -l|xargs)

echo "Memory-->$mem|Paging Space-->$pg|Memory Slots-->$mslot"

lscfg -vp|grep -ip dimm|grep "Size"

#hdisk
lspv
lspath
lsdev -Cc disk
bootinfo -s hdisk0
lscfg -vpl hdisk0

#Network Cards
lsdev -Cc adapter|grep ent
lsattr -El ent4
lscfg -vpl ent2
netstat -in
netstat -rn
ifconfig -a
ifconfig -l
netstat -v en4 |grep -i Speed

#HBA Cards
lsdev -Cc adapter|grep fcs
lsattr -El fcs0
lscfg -vpl fcs0

#Tape
lsdev -Cc tape
lsattr -El rmt0
lscfg -vpl rmt0

#LVM

