[oracle@test tmp]$ more sql
#!/bin/sh
sqlplus test/test@tnsname.test.com << EOF
@/tmp/sqlcreate.sql
exit;
EOF
 
[oracle@test tmp]$ more /tmp/sqlcreate.sql 
create table test6 (id number);
insert into test6 values (1);




#!/bin/ksh
sqlplus /nolog << EOF
CONNECT scott/tiger
SPOOL /u01/emp.lst
SET LINESIZE 100
SET PAGESIZE 50
SELECT *
FROM emp;
SPOOL OFF
EXIT;
EOF



#!/bin/ksh
rman target=/ << EOF
RUN {
  ALLOCATE CHANNEL ch1 TYPE 
    DISK FORMAT '/u01/backup/DB10G/%d_DB_%u_%s_%p'; 
  BACKUP DATABASE PLUS ARCHIVELOG;
  RELEASE CHANNEL ch1;
}
EXIT;
EOF 

