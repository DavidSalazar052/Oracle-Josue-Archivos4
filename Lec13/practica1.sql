SET FEEDBACK ON 
SET PAGESIZE 50
SET LINESIZE 150
SET TRIMSPOOL ON

SPOOL &1..log

PROMPT =======================================
PROMPT TABLAS DE SISTEMA HR

conn bases1/bases123@FREEPDB1

-- =========================================
-- LIMPIEZA SEGURA
-- =========================================
BEGIN
  EXECUTE IMMEDIATE 'drop view rep_emp_mascota';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop view rep_tipo_peso_mascota';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop view rep_emp_mas_peso';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop view rep_empleado_mascotas';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop function fun_peso_masc_tipo';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop function fun_peso_masc_emp';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop function fun_cant_masc_emp';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop function fun_salario_anual';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop function fun_cant_emp_dept';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop table mascotas cascade constraints';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'drop sequence seq_mascotas';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'drop function fun_prom_peso_masc_emp';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/




-- =========================================
-- TABLA
-- =========================================
create table mascotas (
  id      number primary key,
  nombre  varchar2(20),
  peso    number,
  tipo    varchar2(10),
  id_emp  number
);

alter table mascotas 
add constraint mascotas_fk_emp 
foreign key (id_emp) references employees(employee_id);

-- =========================================
-- SECUENCIA
-- =========================================
create sequence seq_mascotas start with 1 increment by 1;

-- =========================================
-- DATOS
-- =========================================
insert into mascotas values (seq_mascotas.nextval,'Firulais',10,'perro',100);
insert into mascotas values (seq_mascotas.nextval,'Michi',5,'gato',100);
insert into mascotas values (seq_mascotas.nextval,'Rex',8,'perro',101);
insert into mascotas values (seq_mascotas.nextval,'Cone',3,'conejo',102);
insert into mascotas values (seq_mascotas.nextval,'Bigotes',6,'gato',102);

commit;

-- =========================================
-- FUNCIONES
-- =========================================

--Cantidad de mascota por empleado
create or replace function fun_cant_masc_emp(Pid_emp in number) 
return number is
  VCantidad number;
begin
  select count(*) into VCantidad
  from mascotas
  where id_emp = Pid_emp;

  return VCantidad;
end;
/

--Peso de mascotas por empleado
create or replace function fun_peso_masc_emp(Pid_emp in number) 
return number is
  VPeso number;
begin
  select sum(peso) into VPeso
  from mascotas
  where id_emp = Pid_emp;

  return nvl(VPeso,0);
end;
/

--Peso de mascotas por tipo
create or replace function fun_peso_masc_tipo(Ptipo in varchar2) 
return number is
  VPesoTotal number;
begin
  select sum(peso) into VPesoTotal
  from mascotas
  where lower(tipo) = lower(Ptipo);

  return nvl(VPesoTotal,0);
end;
/

--salario anual 
create or replace function fun_salario_anual(Psalario in number)
return number
is
begin
  return Psalario * 12;
end;
/

create or replace function fun_cant_emp_dept(Pdept_id in number)
return number
is
  VCantidad number;
begin
  select count(*) into VCantidad
  from employees
  where department_id = Pdept_id;

  return VCantidad;
end;
/

--promedio de peso de mascotas por empleado
create or replace function fun_prom_peso_masc_emp(Pid_emp in number)
return number is VProm number;
begin 
  select avg(peso)
  into VProm
  from mascotas
  where id_emp = Pid_emp;

  return nvl(VProm,0);
end;
/




-- =========================================
-- VISTAS
-- =========================================

create or replace view rep_empleado_mascotas as
select employee_id id,
       first_name || ' ' || last_name nom_completo,
       fun_cant_masc_emp(employee_id) cant_masc
from employees;

create or replace view rep_emp_mas_peso as
select employee_id id,
       first_name || ' ' || last_name nom_completo,
       fun_peso_masc_emp(employee_id) peso_masc
from employees;

create or replace view rep_tipo_peso_mascota as
select tipo,
       sum(peso) peso_total
from mascotas
group by tipo;

create or replace view rep_emp_mascota as
select e.first_name || ' ' || e.last_name nom_completo,
       m.nombre nom_mascota,
       m.peso peso_mascota
from employees e
join mascotas m on m.id_emp = e.employee_id;


--vista de promedio de peso de mascota por empleado
create or replace view rep_prom_peso_masc as
select employee_id id,
  first_name || ' ' || last_name nom_completo_ejemplo1,
  fun_prom_peso_masc_emp(employee_id) promp_peso
from employees;
-- =========================================
-- PRUEBAS
-- =========================================

select fun_cant_masc_emp(100) from dual;
select fun_peso_masc_emp(100) from dual;
select fun_peso_masc_tipo('perro') from dual;
select fun_salario_anual(5000) from dual;
select fun_prom_peso_masc_emp(100) from dual;

select * from rep_empleado_mascotas where id <= 102;
select * from rep_emp_mas_peso where peso_masc > 0;
select * from rep_tipo_peso_mascota;
select * from rep_emp_mascota;

select * from rep_prom_peso_masc;

SPOOL OFF
EXIT

