SET FEEDBACK ON
SET PAGESIZE 50
--configuración del tamaño de linea
SET LINESIZE 150
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
--vamos a ingresar mas VERSION C
insert into empleados(id,nombre, id_jefe) values (5,'Mateo',3);
insert into empleados(id,nombre, id_jefe) values (6,'Marcos',1);
insert into empleados(id,nombre, id_jefe) values (7,'Lucas',1);
insert into empleados(id,nombre, id_jefe) values (8,'Maria',1);
commit;
select * from empleados order by 1;

PROMPT ==== REM_EMP_DE_SONIA
create or replace view rep_emp_de_Sonia as
select id,nombre
from empleados 
where id_jefe=3;

PROMPT ==== REM_EMP_DE_SONIA
create or replace view rep_emp_de_Juan as
select id,upper(nombre) as nombre
from empleados
where id_jefe=1;

PROMPT ==== LISTAS
select *from rep_emp_de_Sonia;
select *from rep_emp_de_Juan;

--PODEMOS CAMBIAR LOS DATOS Y LA VISTA QUEDA IGUAL 
update empleados set id_jefe =3
where id in(7,8);

select *from rep_emp_de_Sonia;
select *from rep_emp_de_Juan;



PROMPT ====fin===========
SPOOL OFF
EXIT



