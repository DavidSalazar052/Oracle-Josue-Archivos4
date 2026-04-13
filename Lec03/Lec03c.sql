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

--VERSION C // todo campo por Defaul permite null, para que no permite null
-- debemos indicarlos explicitamente con el parametro not null
PROMPT creamos la tabla indicando tablespace ****NUEVO
create table empleados(
    id number, 
    nombre varchar2(10),
    id_depto number not null,
    salario number not null
 ) tablespace users;
--host pause

create table departamentos(id number, nombre varchar2(10)) tablespace users;
-- PK departamentos 
PROMP Creamos la PK departamentos
alter table departamentos add constraint departamentos_pk primary key (id);
-- describe departamentos


-- describe empleados
PROMPT Creamos la PK (Primary Key) Lo correcto (cuando creamos script inicial)
alter table empleados add constraint empleados_pk primary key (id);
-- describe empleados

PROMP =================================================
PROMP Creamos el FK
alter table empleados add CONSTRAINTS emp_fk_depto FOREIGN key (id_depto) REFERENCES departamentos;
-- no hay que decirle la llave primaria porque ya sabe la relacion 


PROMPT Creamos una secuencia
create sequence sec_empleados start with 1;
create sequence sec_departamento start with 1;
--Este sequence lo que permite es colocar en la tabla una secuencia 
--Donde va a ir incrementado sin la necesidad de colocar 


PROMP insertamos departamentos
insert into departamentos(id,nombre) values (sec_departamento.nextval,'Ventas');
insert into departamentos(id,nombre) values (sec_departamento.nextval,'Compras');
insert into departamentos(id,nombre) values (sec_departamento.nextval,'Mercado');


PROMPT insertamos registros (con secuencia)
insert into empleados(id, nombre,id_depto, salario) values (sec_empleados.nextval,'Ana',1,1500);
insert into empleados(id, nombre,id_depto, salario) values (sec_empleados.nextval,'Juan',2,1400);
insert into empleados(id, nombre,id_depto, salario) values (sec_empleados.nextval,'Lucia',1,1800);


--null aplica para cualquier tipo de dato o conjunto vacio
-- en el campo de lucia sera nulo 
commit;

--las reglas tambien aplican para el UPDATE 
update empleados set id_depto = 1 WHERE id = 1;


PROMPT Consultar Tabla
select * from empleados;
select * from departamentos;


PROMPT ====fin===========
SPOOL OFF
EXIT
