SET FEEDBACK ON 
SET PAGESIZE 50
SET LINESIZE 150
--Nuevo Parametro elimina espacios al final en .lOG
SET TRIMSPOOL ON

SPOOL &1..log
PROMPT =======================================
PROMPT Conjuntos

PROMPT ====Conectar con bases1===========
conn bases1/bases123@FREEPDB1

-- MISMO TIPO, NO NECESARIAMENTE EL TAMAÑO Podemos tener un varchar2(10) o (100) que no afecta
PROMPT ======Union #1
select department_id,first_name from employees
union
select department_id,department_name from departments;



PROMPT ======Interseccion
select department_id from employees
intersect
select department_id from departments;




PROMPT ======Resta (EXCEPT en postgres)
select department_id from departments
minus 
select department_id from employees;


--Este count funcion de agregación en ORACLE
select count(department_id) from departments;

create or replace view rep_emp_deptos as
select e.first_name, d.department_name 
from departments d, employees e
where e.department_id = d.department_id
order by 2,1;


--Version 2
create or replace view rep_emp_deptos2 as
select e.first_name, d.department_name, e.salary
from departments d, employees e
where e.department_id = d.department_id
order by 2,1;

--Una funcion de agregación es que me cuente cuantos empleados hay por ese nombre de departamento
select * from rep_emp_deptos order by 2,1;


--Reporte de cantidad de empleados por departamento
select department_name, count(*) Cantidad
from rep_emp_deptos
group by department_name
order by 1;

--avg es un average es un promedio 
select department_name, count(*) Cantidad, avg(salary) sal_prom
from rep_emp_deptos2
group by department_name
order by 1;

--reporte ejecutivo, funciones standar, trunc elimina decimales
--trunc(salario) -- a cero decimales
--trunc(salario,2) -- a dos decimales

--USAR LAS FUNCIONES DE max() sal_max y min() sal_min


select department_name, count(*) Cantidad, trunc(avg(salary),2) sal_prom_Trunc
from rep_emp_deptos2
group by department_name
order by 1;

--No podemos utilizar palabras recervadas
--podemos hacer una vista, que use otra vista para hacerla más abstracta

create or replace view rep_ejec_emp_depto as
select department_name nombre_departamento, count(*) Cantidad, trunc(avg(salary),2) sal_max,
max(salary) sal_maximo, min(salary) sal_min
from rep_emp_deptos2
group by department_name
order by 1;

select * from rep_ejec_emp_depto;

--------------------------------------
create or replace view rep_emp_puestos as
select e.first_name, p.job_title 
from jobs p, employees e
where e.job_id = p.job_id
order by 2,1;

select * from rep_emp_puestos;


create or replace view rep_ejec_emp_job as
select job_title,count(*) Cantidad
from rep_emp_puestos
group by job_title
order by 1;

select * from rep_ejec_emp_job;

----------------------------------------

create or replace view rep_emp_jefe as
select e.first_name empleado, j.first_name jefe
from employees e, employees j 
where e.manager_id = j.employee_id
order by 2,1;

select * from rep_emp_jefe;


PROMPT ====fin===========

SPOOL OFF
EXIT
