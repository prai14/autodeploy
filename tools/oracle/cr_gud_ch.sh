groupadd -g 501 oinstall 
groupadd -g 502 dba
groupadd -g 503 oper 
groupadd -g 504 asmadmin
groupadd -g 505 asmdba
groupadd -g 506 asmoper
useradd -g oinstall -G dba,asmdba,oper -d /home/oracle -u 501 oracle 
useradd -g oinstall -G asmadmin,asmdba,asmoper,oper,dba -d /home/grid -u 502 grid

mkdir -p /app/oracle/product/11.2.0/dbhome_1
mkdir -p /app/grid/product/11.2.0/grid
chown -R oracle:oinstall /app/
chown -R grid:oinstall /app/grid
chmod -R 775 /app/
