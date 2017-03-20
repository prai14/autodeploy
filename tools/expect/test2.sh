#!/usr/bin/expect
#env
set timeout 10
set USERNAME etnet
set PASSWORD 123456
#host table
foreach host {
192.168.151.89
192.168.151.90
} {
spawn ssh 
-l root ${host}
#ssh first login  exp_continue auto next recycle
expect {
        "no)?" {send "yes \r(www.111cn.net)";exp_continue}
        "password:" {send "123456\r"}
}
#expect \r
expect "]*"
send "passwd ${USERNAME} \r"
expect "password:"
send "${PASSWORD} \r"
expect "password:"
send "${PASSWORD} \r"
expect "]*"
send "exit \r"
}
