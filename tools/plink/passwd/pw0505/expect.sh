#!/usr/bin/expect -f

set IP [lindex $argv 0]    
set PASSWORD [lindex $argv 1]  
set NEWPASSWORD [lindex $argv 2]  

#spawn echo ${IP}
#spawn echo ${PASSWORD} 
#spawn echo ${NEWPASSWORD}

spawn ssh ${IP} " echo '${NEWPASSWORD}'| passwd --stdin root "  

expect { 
   "(yes/no)" { send "yes\r"; exp_continue }   
   "password:" { send "${PASSWORD}\r"; exp_continue }
   "*?" { send "\r" }
}

interact

exit
