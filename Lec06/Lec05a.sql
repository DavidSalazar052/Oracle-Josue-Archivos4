SET FEEDBACK ON
SET PAGESIZE 50
SPOOL &1..log
PROMPT =======================================
Prompt Ejemplo de FK reflexivo sobre la misma tabla.

drop user bases1 cascade;
create user bases1 identified by bases123;
grant dba to bases1;

PROMPT ====inicio===========
conn bases1/bases123@FREEPDB1

create table empleados(
id      number,
nombre  varchar2(10) not null,
id_jefe number);
alter table empleados add constraint empleados_pk primary key(id);
alter table empleados add constraint empleados_fk foreign key(id_jefe) references empleados;
insert into empleados(id,nombre, id_jefe) values (1,'Juan',null);
insert into empleados(id,nombre, id_jefe) values (2,'Ana',1);
insert into empleados(id,nombre, id_jefe) values (3,'Sonia',1);
insert into empleados(id,nombre, id_jefe) values (4,'Pedro',3);
commit;
select * from empleados order by 1;


PROMPT ====fin===========
SPOOL OFF
EXIT



