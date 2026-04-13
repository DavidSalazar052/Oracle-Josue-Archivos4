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

PROMPT ======Union
select department_id from employees
union
select department_id from departments;

PROMPT ======Interseccion
select department_id from employees
intersect
select department_id from departments;

PROMPT ======Resta (EXCEPT en postgres)
select department_id from departments
minus 
select department_id from employees;

select count(department_id) from departments;

PROMPT ====fin===========

SPOOL OFF
EXIT
