#!/usr/bin/expect -f    
  
set password 123456    
#download    
spawn scp root@192.168.1.218:/root/a.wmv /home/yangyz/    
set timeout 300     
expect "root@192.168.1.218's password:"   
set timeout 300     
send "$password\r"   
set timeout 300     
send "exit\r"   
expect eof    

#upload    
spawn scp /home/yangyz/abc.sql root@192.168.1.218:/root/test.sql   
set timeout 300     
expect "root@192.168.1.218's password:"   
set timeout 300     
send "$password\r"   
set timeout 300     
send "exit\r"   
expect eof  

