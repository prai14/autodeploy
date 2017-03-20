#!/bin/sh

ROUTE=$(route -n|grep "^0.0.0.0"|awk '{print $2}')
BROADCAST=$(/sbin/ifconfig eth0|grep -i bcast|awk '{print $3}'|awk -F":" '{print $2}')
HWADDR=$(/sbin/ifconfig eth0|grep -i HWaddr|awk '{print $5}')
IPADDR=$(/sbin/ifconfig eth0|grep "inet addr"|awk '{print $2}'|awk -F":" '{print $2}')
NETMASK=$(/sbin/ifconfig eth0|grep "inet addr"|awk '{print $4}'|awk -F":" '{print $2}')

echo ${ROUTE}
echo ${BROADCAST}
echo ${HWADDR}
echo ${IPADDR}
echo ${NETMASK}
