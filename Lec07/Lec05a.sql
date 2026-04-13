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

--Creación de la tabla empleados 
create table empleados(
id      number,
nombre  varchar2(10) not null,
id_jefe number);

--Definimos la PK y la Fk
alter table empleados add constraint empleados_pk primary key(id);
alter table empleados add constraint empleados_fk foreign key(id_jefe) references empleados;

--Insertamos los datos
insert into empleados(id,nombre, id_jefe) values (1,'Juan',null);
insert into empleados(id,nombre, id_jefe) values (2,'Ana',1);
insert into empleados(id,nombre, id_jefe) values (3,'Sonia',1);
insert into empleados(id,nombre, id_jefe) values (4,'Pedro',3);
commit;

--mostramos los datos
create or replace view rep_Empleados as 
select e.id,e.nombre nom_emp, j.nombre nom_jefe
from empleados e, empleados j
where e.id_jefe = j.id; 

select * from rep_Empleados;


PROMPT ====fin===========
SPOOL OFF
EXIT



