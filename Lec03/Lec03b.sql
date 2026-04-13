SET FEEDBACK ON
SET PAGESIZE 50
SPOOL &1..log

drop user bases1 cascade;
create user bases1 identified by bases123;
grant dba to bases1;

PROMPT ====inicio===========
--Siempre nos vamos a conectar primero! AL PDB!!
conn bases1/bases123@FREEPDB1

--PROMPT la primera vez da error el drop, la tabla no existe
--drop table empleados;

--prompt Dropeamos y creamos una secuencia
--drop sequence sec_empleados;

--VERSION B // todo campo por Defaul permite null, para que no permite null
-- debemos indicarlos explicitamente con el parametro not null
PROMPT creamos la tabla indicando tablespace ****NUEVO
create table empleados(id number, 
nombre varchar2(10), salario number not null) tablespace users;
--host pause
describe empleados
PROMPT Creamos la PK (Primary Key) Lo correcto (cuando creamos script inicial)
alter table empleados add constraint empleados_pk primary key (id);
describe empleados


PROMPT Creamos una secuencia
create sequence sec_empleados start with 1;
--Este sequence lo que permite es colocar en la tabla una secuencia 
--Donde va a ir incrementado sin la necesidad de colocar 

PROMPT insertamos registros (con secuencia)
insert into empleados(id, nombre, salario) values (sec_empleados.nextval,'Ana',1500);
insert into empleados(id, nombre, salario) values (sec_empleados.nextval,'Juan',1400);
insert into empleados(id, nombre, salario) values (sec_empleados.nextval,'Lucia',null);
--null aplica para cualquier tipo de dato o conjunto vacio
-- en el campo de lucia sera nulo 
commit;


PROMPT Consultar Tabla
select * from empleados;


PROMPT ====fin===========
SPOOL OFF
EXIT
