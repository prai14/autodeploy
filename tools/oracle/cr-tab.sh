
-----------------------创建表空间

CREATE SMALLFILE TABLESPACE "DEMO" 
DATAFILE 'D:\APP\ADMINISTRATOR\ORADATA\ORCL\mytablespace'
SIZE 100M 
AUTOEXTEND ON NEXT 10M 
MAXSIZE UNLIMITED LOGGING
EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO DEFAULT NOCOMPRESS


---------------------创建一个用户

create user demo2
     identified by 123456
     default tablespace DEMO   ----------------这个DEMO与上面的表空间对应
     quota 10m on DEMO
     temporary tablespace temp ;

 

------------------------给新创建用户权限，要不进不去或者不能操作
grant create session,create table to demo2 ; 
grant resource,connect to demo2 ; 

------------------------其他权限


grant connect to demo2 ;
grant dba to demo2 ;
-- Grant/Revoke system privileges 
grant alter session to demo2 ;
grant create any directory to demo2 ;
grant create any procedure to demo2 ;
grant create any sequence to demo2 ;
grant create session to demo2 ;
grant create synonym to demo2 ;
grant create table to demo2 ;
grant create type to demo2 ;
grant create view to demo2 ;
grant select any dictionary to demo2 ;
grant select any table to demo2 ;
grant unlimited tablespace to demo2 ;


 

----------------------------创建序列，从1000开始，开始值随便

create sequence  sq_1 start with 1000;

 

---------------------------创建表

create table bill(
       bl_id                         number ,        ---id
       bl_number                     varchar2(50),        ---编号
       bl_sp_name                    varchar2(50),       ---商品名
       bl_count                      number,         ---商品数量
       bl_money                      number,           --交易金额
       bl_if_money                   varchar2(10),     --是否付款
       bl_gy_name                    varchar2(50),     --供应商名称
       bl_detail                     varchar2(50),     --商品描述
       bl_create                     date,             --创建时间
       bl_delete                     date,             --删除时间
       bl_if_delete                  varchar2(10),      --是否删除
       bl_delete_name                varchar2(50),      --删除人名
       bl_edit_time                  date           --上次编辑时间
);


