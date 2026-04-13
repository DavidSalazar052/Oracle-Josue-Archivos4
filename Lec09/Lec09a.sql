SET FEEDBACK ON 
SET PAGESIZE 50
SET LINESIZE 150

SPOOL &1..log
PROMPT =======================================
PROMPT VISTAS Y CONSULTAS EN SISTEMA HR

--OJO NO DROPEAR USUARIO PORQUE VAMOS A CREAR VISTAS!!!

--drop user bases1 cascade;
--create user bases1 identified by bases123;
--grant dba to bases1;

PROMPT ====Conectar con bases1===========
conn bases1/bases123@FREEPDB1


--PASO 1 (PROD CARTESIANO) REGIONES 4 X PAISES 25 = (4x25) = 100
-- select region_name, country_name
-- from   regions, countries;

--REGIONES 1 X PAISES 25
column region_name  format A22
column country_name format A25

-- select r.region_name, c.country_name
-- from   regions r, countries c
-- where  r.region_id = c.region_id
-- order by 1 asc;

create or replace view rep_reg_pais as 
select r.region_name, c.country_name
from   regions r, countries c
where  r.region_id = c.region_id
order by 1 asc;

-- PROMPT usamos vista rep_reg_pais
-- select * from rep_reg_pais order by 2 desc;
--nivel mas alto de abstracción...

--VISTA  rep_paises_loc          (locations)
--nombre de pais (countries)  country_name ,  city , state_province
--ordenado por country_name ASC
PROMPT rep_paises_loc 1, 2
-- select c.country_name, l.city, l.state_province
-- from   countries c, locations l
-- where  c.country_id = l.country_id;
create or replace view rep_paises_loc as
select c.country_name, l.city, l.state_province
from   countries c, locations l
where  c.country_id = l.country_id;

column state_province format A25
column city format A20

--select * from rep_paises_loc order by country_name asc;


PROMPT =======================================================
--(EMPLEADOS) ID de empleado nombre||' '||apellido, 
-- puesto (job_title) , department_name (departments=
--VISTA  rep_empleados_info  (SIN ORDENAR)
--  id, nombre_completo, puesto, departamento
--con formateo de columnas y ordenado por id de empleado asc.
--where   FK = PK
--and     FK = PK;
set linesize 200
column id format 99999
column nombre_completo format A30
column puesto format A31
column departamento format A25

--vistas, Cambios en las representaciones de los datos.
--mod , upper, lower funciones pre-establecidas en la BD Oracle.

-- create or replace view rep_empleados_info as
-- select e.employee_id id, upper(e.first_name||' '||e.last_name) nombre_completo,
-- j.job_title puesto, lower(d.department_name) departamento
-- from   employees e, jobs j, departments d
-- where  e.job_id = j.job_id
-- and    e.department_id = d.department_id;
--OPERADORES like 

PROMPT version 2 vista rep_empleados_info
create or replace view rep_empleados_info as
select e.employee_id id, e.first_name||' '||e.last_name nombre_completo,
upper(e.first_name||' '||e.last_name) nombre_completo2,
j.job_title puesto, lower(d.department_name) departamento
from   employees e, jobs j, departments d
where  e.job_id = j.job_id
and    e.department_id = d.department_id;


-- select id, nombre_completo, puesto, departamento
-- from  rep_empleados_info 
-- where upper(nombre_completo) like upper('t%')
-- order by id asc;


--campos tipo fecha (operador between = ENTRE) --mm por mon
alter session set nls_date_format = 'dd-mon-yyyy hh24:mi:ss';
-- select employee_id id, first_name||' '||last_name nombre_completo,
-- hire_date fec_contrato
-- from   employees
-- where  hire_date between to_date('01-01-1996','dd-mm-yyyy')
-- and    to_date('31-12-1996','dd-mm-yyyy')
-- order by 3;


select employee_id id, first_name||' '||last_name nombre_completo,
hire_date fec_contrato
from   employees
where  hire_date between to_date('01-01-1996','dd-mm-yyyy')
and    to_date('01-01-1996','dd-mm-yyyy')+(364*3)
order by 3;

PROMPT ====fin===========

SPOOL OFF
EXIT
