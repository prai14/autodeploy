#!/usr/bin/expect  
set timeout 30  
spawn ssh -l root 10.10.0.137 
expect "password:"  
send "QWE90frvzE\r"  
interact  
cat /etc/hosts
