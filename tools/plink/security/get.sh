set password QAZ89jmnzD
#download
spawn scp root@10.10.0.136:/root/*security.log /root/tools/plink/security/info
set timeout 300
expect "root@10.10.0.136's password:"
set timeout 300
send "$password\r"
set timeout 300
send "exit\r"
expect eof
