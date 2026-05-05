SET FEEDBACK ON 
SET PAGESIZE 50
SET LINESIZE 150
SET TRIMPSPOOL ON

SPOOL &1..log
PROMPT =======================================
PROMPT TABLAS DE SISTEMA HR

--*********ATENCION************
-- CORRER UNA VEZ CON ESTAS 4 lineas activas, luego comentar
-- drop user bases1 cascade;
-- create user bases1 identified by bases123;
-- grant dba to bases1;

PROMPT ====Conectar con bases1===========
conn bases1/bases123@FREEPDB1
--============================================================================

--*********ATENCION************
--ESTA LINEA CORRER UNA VEZ, luego comentar
-- @Lec09-hr.sql

prompt ===================================================
prompt Dropear objetos
drop table mascotas cascade constraints;
drop sequence seq_mascotas;

prompt ===================================================
prompt Crear tabla mascotas
create table mascotas
(
  id      number          not null,
  nombre  varchar2(10)    not null,
  peso    number          not null,
  tipo    varchar2(7)     not null,
  id_emp  number(6)       not null
);

prompt ===================================================
prompt Crear una secuencia
create sequence seq_mascotas start with 1000;

prompt ===================================================
prompt Creamos la PK con el campo id.
alter table mascotas add constraint mascotas_pk primary key(id);

prompt ===================================================
prompt Creamos la FK con empleados (employees)
alter table mascotas add constraint mascotas_fk_emp 
  foreign key (id_emp) references employees;

prompt ===================================================
prompt Creamos procedimiento prc_ins_mascotas v3
create or replace procedure prc_ins_mascotas(
  Pnombre in varchar2,
  Ppeso in number,
  Ptipo in varchar2,
  Pid_emp in number
) is
begin
  insert into mascotas(id, nombre, peso, tipo, id_emp)
  values (seq_mascotas.nextval, Pnombre, Ppeso, Ptipo, Pid_emp);
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
prompt Funcion fun_cant_masc_emp
create or replace function fun_cant_masc_emp(Pid_emp in number) return number is
  VCantidad number;
begin
  select count(*)
    into VCantidad
    from mascotas
   where id_emp = Pid_emp;
  return VCantidad;
end fun_cant_masc_emp;
/
show error

prompt ===================================================
prompt Crear o corregir función fun_peso_masc_emp antes de la vista
create or replace function fun_peso_masc_emp(Pid_emp in number) return number is
  VCantidad number;
begin
  select sum(peso)
    into VCantidad
    from mascotas
   where id_emp = Pid_emp;
  return VCantidad;
end fun_peso_masc_emp;
/
show error

prompt ===================================================
prompt Crear función fun_peso_masc_tipo para sumar peso por tipo de mascota


create or replace function fun_peso_masc_tipo(Ptipo in varchar2) return number is
  VPesoTotal number;
begin
  select sum(peso)
    into VPesoTotal
    from mascotas
   where lower(tipo) = lower(Ptipo);
  return VPesoTotal;
end fun_peso_masc_tipo;
/
show error

prompt ===================================================
prompt Vista rep_empleado_mascotas
create or replace view rep_empleado_mascotas as
select employee_id id,
       first_name || ' ' || last_name nom_completo,
       fun_cant_masc_emp(employee_id) cant_masc
from employees;

prompt ===================================================
prompt Vista rep_emp_mas_peso
create or replace view rep_emp_mas_peso as
select employee_id id,
       first_name || ' ' || last_name nom_completo,
       fun_peso_masc_emp(employee_id) peso_masc
from employees;

select * from rep_emp_mas_peso where peso_masc > 0;

prompt ===================================================
prompt Ver suma de pesos de perros
select fun_peso_masc_tipo('perro') peso_total_perros from dual;

prompt ===================================================
prompt Vista rep_tipo_peso_mascota
create or replace view rep_tipo_peso_mascota as
select tipo,
       sum(peso) peso_total
from mascotas
group by tipo;

select * from rep_tipo_peso_mascota where lower(tipo) = 'perro';

prompt ===================================================
prompt Actualizar peso de mascota con procedimiento
create or replace procedure prc_act_mascotas(
  Pid_masc in number,
  Ppeso in number
) is
begin
  update mascotas set peso = Ppeso where id = Pid_masc;
  commit;
end prc_act_mascotas;
/
show error

execute prc_act_mascotas(1000,10);
execute prc_act_mascotas(1000,10);
execute prc_act_mascotas(1000,10);
execute prc_act_mascotas(1000,10);
execute prc_act_mascotas(1000,10);
execute prc_act_mascotas(1000,10);
commit;

prompt ===================================================
prompt Ver mascotas después de actualizar
select * from mascotas order by id;

select * from rep_emp_mas_peso where peso_masc > 0;

column nom_completo format A20

prompt ===================================================
prompt select rep_empleado_mascotas v2
select *
from rep_empleado_mascotas
where id < 105
order by 1;

prompt ===================================================
prompt vista rep_emp_mascota
create or replace view rep_emp_mascota as
select e.first_name || ' ' || e.last_name nom_completo,
       m.nombre nom_mascota,
       m.peso peso_mascota
from employees e
join mascotas m on m.id_emp = e.employee_id;

select * from rep_emp_mascota order by 1;

prompt ===================================================
prompt funcion fun_cant_mascotas
create or replace function fun_cant_mascotas return number is
  VCantidad number;
begin
  select count(*)
    into VCantidad
    from mascotas;
  return VCantidad;
end fun_cant_mascotas;
/
show error

select fun_cant_mascotas dato from dual;

prompt ===================================================
prompt fin
SPOOL OFF
EXIT