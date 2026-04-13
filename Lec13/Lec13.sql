SET FEEDBACK ON 
SET PAGESIZE 50
SET LINESIZE 150

SPOOL &1..log
PROMPT =======================================
PROMPT TABLAS DE SISTEMA HR

--*********ATENCION************
-- CORRER UNA VEZ CON ESTAS 4 lineas activas, luego comentar
drop user bases1 cascade;
create user bases1 identified by bases123;
grant dba to bases1;


PROMPT ====Conectar con bases1===========
conn bases1/bases123@FREEPDB1
--============================================================================


--*********ATENCION************
--ESTA LINEA CORRER UNA VEZ, luego comentar
@Lec09-hr.sql



--hr3.sql
--agregar una tabla mas.. ejericio de la práctica no 2.
--3pm... 5pm..
--1pm  hijos.. fecha de nacimiento.  edad..
--empresa pet frendly..
--mascotas.. cardinalidad

--***SE ELIMINA ESTO
-- host cls
-- conn bases1/bases123

--recursiva, solo esta parte..
prompt ===================================================
prompt Dropear objetos
drop table mascotas cascade constraints;
drop sequence seq_mascotas;

prompt ===================================================
prompt Crear tabla mascotas
-- agregar tabla para que cada empleado registre sus mascotas..
--toda mascota tiene un nombre
--la empresa solo permite mascotas de 5kgr o menos. y gatos; perros; conejos.
prompt Cardinalidad:
prompt Una mascota DEBE tener un propietario que es un empleado
prompt Un empleado PUEDE (no tener, tener una, o tener N mascotas)

create table mascotas
(id      number          not null,
 nombre  varchar2(10)    not null,
 peso    number          not null,
 tipo    varchar2(7)     not null,
 id_emp  number(6)       not null );
 
prompt ===================================================
prompt Crear una secuencia
--crear en 1000 // forro, documentación //
create sequence seq_mascotas start with 1000;

prompt ===================================================
prompt Creamos la PK con el campo id.
alter table mascotas add constraint mascotas_pk primary key(id);

prompt ===================================================
prompt Creamos la FK con empleados (employees)
alter table mascotas add constraint mascotas_fk_emp 
foreign key (id_emp) references employees;

--15.31 procedimiento para insertar mascotas
prompt ===================================================
prompt Creamos procedimiento prc_ins_mascotas v3

create or replace procedure prc_ins_mascotas(Pnombre in varchar2,
Ppeso in number, Ptipo in varchar2, Pid_emp in number) is
  Vprueba number;
begin
  insert into mascotas(id, nombre, peso, tipo, id_emp) values
  (seq_mascotas.nextval,Pnombre,Ppeso,Ptipo,Pid_emp);
  commit;
end prc_ins_mascotas;
/
show error
prompt ===================================================
prompt Consumimos el procedimiento v1
execute prc_ins_mascotas('Puppy',3,'perro',102);
execute prc_ins_mascotas('Misingo',4,'gato',102);
execute prc_ins_mascotas('Rambo',4,'conejo',103);
execute prc_ins_mascotas('Rambo 1',5,'conejo',103);
execute prc_ins_mascotas('Rambo 2',6,'conejo',103);

select * from mascotas;

prompt ===================================================
prompt Funcion  fun_cant_masc_emp 
--recibe por parametro el id de empleado y retorna la cantidad 
--de mascotas   count    que posee dicho empleado..
create or replace function fun_cant_masc_emp(Pid_emp in number) return number is
  VCantidad number;
begin
 -- count  avg  max  min  sum ..funciones de agregación..
  select count(*)
  into   VCantidad
  from   mascotas
  where  id_emp = Pid_emp;
  return VCantidad;
end fun_cant_masc_emp;
/
show error

select fun_cant_masc_emp(102) dato from dual;
prompt ===================================================
prompt vista  rep_empleado_mascotas
--VISTA ID emp, nombre empleado completo, la cantidad de mascotas que tiene? usando FUN
create or replace view rep_empleado_mascotas as
select employee_id id, first_name||' '||last_name nom_completo, 
fun_cant_masc_emp(employee_id) cant_masc
from   employees;
--where  fun_cant_masc_emp(employee_id) > 0;

--formateo de como se reflejan los resultados del select
column nom_completo format A20

prompt ===================================================
prompt select rep_empleado_mascotas v2
select * 
from   rep_empleado_mascotas 
where  id < 105 
--cant_masc > 0
order  by 1;
prompt ===================================================
prompt vista rep_emp_mascota
--inner join.  // nombre_completo del empleado, nombre de su mascota y su peso..
--usar alias
create or replace view rep_emp_mascota as
select e.first_name||' '||e.last_name nom_completo, m.nombre nom_mascota, 
m.peso peso_mascota
from   employees e, mascotas m
where  m.id_emp = e.employee_id;

select * from rep_emp_mascota order by 1;

--funcion que no recibe parametros, cuenta la cantidad de 
--mascotas existentes?

create or replace function fun_cant_mascotas return number is
  VCantidad number;
begin
  select count(*)
  into   VCantidad
  from   mascotas;
  return VCantidad;
end fun_cant_mascotas;
/
show error

select fun_cant_mascotas dato from dual;

--
-- create table mascotas
-- (id      number          not null,
 -- nombre  varchar2(10)    not null,
 -- peso    number          not null,
 -- tipo    varchar2(7)     not null,
 -- id_emp  number(6)       not null );

--============================================================================
 
PROMPT ====fin===========

SPOOL OFF
EXIT
