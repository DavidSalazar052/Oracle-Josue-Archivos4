SET FEEDBACK ON
SET PAGESIZE 50
SPOOL &1..log
PROMPT =======================================
Prompt Ejemplo de FK reflexivo sobre la misma tabla.

--VERSION C

--Todos los OBJETOS de la base de datos se almacenanan en MAYUSCULAS 
--dba_users = vista de diccionario de datos que muestra todos los usuarios 
--de la base de datos. Cuando hacemos un count 
-- cant = es un alias de columna 
--select count(*) cant from dba_users where username='BASES1';
-- por esto BASES1 se coloca en mayusculas.

drop user bases1 cascade;

--select count(*) cant from dba_users where username='BASES1';

create user bases1 identified by bases123;
--select count(*) cant from dba_users where username='BASES1';
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
select * from empleados order by 1;

--Reglas 9 Codd Independencia logica de los datos
alter table empleados add (salario number); ALTER

select * from empleados order by 1;
PROMPT ====fin===========
SPOOL OFF
EXIT



