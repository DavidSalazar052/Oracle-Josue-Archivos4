--Usamos como Base Lec03c.sql
--Repaso de leccion 03
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

--VERSION b // todo campo por DEFAULT permite nulos... 
-- no permitir nulos debo indicarlo EXPLICITAMENTE!!  not null
PROMPT creamos la tabla indicando tablespace ****NUEVO
create table empleados(id number, 
nombre varchar2(10), id_depto number not null, salario number not null ) tablespace users;
--host pause
--VERSION C
create table departamentos(id number, nombre varchar2(10)) tablespace users;

--VERSION C comentar los describe
--describe empleados;
PROMPT ====================================================================
PROMPT Creamos las PKs (Primary Key) Lo correcto (cuando creamos script inicial)
alter table empleados add constraint empleados_pk primary key (id);
--describe empleados;
--ustedes PK departamentos?
alter table departamentos add constraint departamentos_pk primary key (id);

PROMPT ====================================================================
PROMPT Creamos el FK  (id); opcional 
alter table empleados add constraint emp_fk_depto foreign key (id_depto) 
references departamentos;
PROMPT ====================================================================
PROMPT Creamos una secuencia
--create sequence sec_empleados start with 1;
create sequence sec_empleados;
create sequence sec_departamentos;

PROMPT Insertamos Departamentos VERSION C
insert into departamentos(id, nombre) values (sec_departamentos.nextval,'Ventas');
insert into departamentos(id, nombre) values (sec_departamentos.nextval,'Compras');
insert into departamentos(id, nombre) values (sec_departamentos.nextval,'Mercadeo');

--null  (cualquier tipo de datos)  number, varchar2, date... // 
--null  = ausencia de infomación, conjunto vacío de datos.
PROMPT insertamos registros (con secuencia)
insert into empleados(id, nombre, id_depto, salario) values (sec_empleados.nextval,'Ana',2,1500);
insert into empleados(id, nombre, id_depto, salario) values (sec_empleados.nextval,'Juan',1,1400);
insert into empleados(id, nombre, id_depto, salario) values (sec_empleados.nextval,'Lucia',2,1800);
commit;
PROMPT =========reglas aplican para UPDATE!!
update empleados
set    id_depto = 3 
where  id = 1;
commit;

PROMPT Consultar Tablas
select * from empleados;
select * from departamentos;


PROMPT ====fin===========
SPOOL OFF
EXIT
