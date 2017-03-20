cat /etc/passwd|awk -F":" '{print $1}'|xargs|tr ' ' ,
