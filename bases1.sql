SET FEEDBACK ON 
SET PAGESIZE 50
SET LINESIZE 150
SET TRIMSPOOL ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT =======================================
PROMPT Solo borra y crea usuario bases1 

drop user bases1 cascade;
create user bases1 identified by bases123;
grant dba to bases1;

PROMPT ====Conectar con bases1===========
conn bases1/bases123@FREEPDB1


PROMPT ====fin===========
EXIT
