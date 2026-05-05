-- NOMBRE : JOSUE DAVID SANCHEZ SALAZAR
-- CEDULA : 118840506
-- GRUPO  : MAR - VIE 1:00 PM 

--LINK DEL VIDEO EXPLICATIVO :
--https://drive.google.com/file/d/1VvoKrvlsIecrEeKXYgrjDExuQAd1TOMR/view?usp=sharing

PROMPT ====Conectar con bases1===========
conn bases1/bases123@FREEPDB1


SET FEEDBACK ON 
SET PAGESIZE 50
SET LINESIZE 150
SET TRIMSPOOL ON
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT ===================================================
PROMPT CREACION DE TABLAS ADICIONALES
PROMPT ===================================================

drop table habilidades cascade constraints;
drop sequence seq_habilidad;

drop table hijos cascade constraint;
drop sequence seq_hijo;

--TABLA DE HABILIDADES
create table habilidades 
(
    id number not null,
    nombre_hab varchar2(25) not null,
    nivel_hab number not null,
    id_emp number(6) not null
);
--TABLA DE HIJOS
create table hijos
(
    hijo_id number not null,
    nombre_hijo varchar2(25) not null,
    edad number not null,
    id_emp_padre number not null,
    id_emp_madre number not null
);

--secuencias
create sequence seq_habilidad start with 1;
create sequence seq_hijo start with 1;

--HABILIDADES PK FK
alter table habilidades add constraint habilidades_pk primary key(id);
alter table habilidades add constraint habilidades_fk foreign key(id_emp) references employees;
ALTER TABLE habilidades ADD CONSTRAINT habilidades_nivel_ck CHECK (nivel_hab > 0);

--HIJOS PK FK
alter table hijos add constraint hijos_pk primary key(hijo_id);
alter table hijos add constraint hijo_padre_fk foreign key (id_emp_padre) references employees;
alter table hijos add constraint hijo_madre_fk foreign key (id_emp_madre) references employees;
ALTER TABLE hijos ADD CONSTRAINT hijos_edad_ck CHECK (edad >= 0);
--METODO PARA INGRESAR HABILIDADES
create or replace procedure prc_ins_habilidad(
    Pnombre in varchar2,
    Pnivel in number,
    Pid_emp in number
) is
begin
    insert into habilidades(id,nombre_hab,nivel_hab,id_emp)
    values (seq_habilidad.nextval,Pnombre,Pnivel,Pid_emp);
    commit;
end prc_ins_habilidad;
/
show error

--METODO PARA INGRESAR HIJOS
create or replace procedure prc_ins_hijos(
    Pnombre_hijo in varchar2,
    Pedad_hijo in number,
    Pid_emp_padre in number,
    Pid_emp_madre in number
) is
begin 
    insert into hijos(hijo_id,nombre_hijo,edad,id_emp_padre,id_emp_madre)
    values(seq_hijo.nextval,Pnombre_hijo,Pedad_hijo,Pid_emp_padre,Pid_emp_madre);
    commit;
end prc_ins_hijos;
/
show error



execute prc_ins_habilidad('Python',5,102);
execute prc_ins_habilidad('Excel',5,102);
execute prc_ins_habilidad('Rstudio',5,102);

execute prc_ins_habilidad('SQL',1,103);
execute prc_ins_habilidad('Java',2,103);

execute prc_ins_habilidad('Docker',5,104);
execute prc_ins_habilidad('SQL',5,104);

execute prc_ins_habilidad('ORACLE',5,121);
execute prc_ins_habilidad('LINUX',2,121);
execute prc_ins_habilidad('AZURE',3,123);

-------------------------------------------------

execute prc_ins_hijos('Ana',10,100,101);
execute prc_ins_hijos('Juan',11,100,101);
execute prc_ins_hijos('Valeria',12,100,101);

execute prc_ins_hijos('Pedro',13,102,107);
execute prc_ins_hijos('Santiago',14,102,107);

execute prc_ins_hijos('Emilia',15,108,109);

select * from habilidades;
select * from hijos;

--====================================================================================

PROMPT ===================================================
PROMPT FUNCIONES BASICAS
PROMPT ===================================================

PROMPT FUNCION BASICA 1 - RETORNE LA CANTIDAD DE EMPLEADOS POR DEPARTAMENTO ESPECIFICO 

create or replace function fun_cant_emp_depto(Pid_depto in Number)
return number is Vcantidad number;
begin
    select count(*) 
     into Vcantidad
     from employees
     where department_id = Pid_depto;
    return Vcantidad;
end fun_cant_emp_depto;
/
show error
select fun_cant_emp_depto(100) CANTIDAD_DE_EMPLEADOS from dual;
select fun_cant_emp_depto(90) CANTIDAD_DE_EMPLEADOS from dual;
select fun_cant_emp_depto(80) CANTIDAD_DE_EMPLEADOS from dual;

PROMPT FUNCION BASICA 2 - SUMA LOS SALARIOS DE TODOS LOS EMPLEADOS POR TRABAJO ESPECIFICO
create or replace function fun_sum_sal_job(Pid_Job in varchar2)
return number is VSalarioTotal number;
begin
    select sum(salary)
    into VSalarioTotal
    from employees
    where job_id = Pid_Job;
    return VSalarioTotal;
end fun_sum_sal_job;
/
show error
select fun_sum_sal_job('AD_PRES') Salario from dual;
select fun_sum_sal_job('AD_VP') Salario from dual;
select fun_sum_sal_job('AD_ASST') Salario from dual;

PROMPT FUNCION BASICA 3 - RETORNA EL SALARIO MINIMO DE UN DEPARTAMENTO
create or replace function fun_sal_min_depto(Pid_depto in number)
return number is VSalarioMin number;
begin
    select min(salary)
    into VSalarioMin
    from employees
    where department_id = Pid_depto;
    return VSalarioMin;
end fun_sal_min_depto;
/
show error
select fun_sal_min_depto(100) Salario_Minimo from dual;
select fun_sal_min_depto(90) Salario_Minimo from dual;
select fun_sal_min_depto(80) Salario_Minimo from dual;


PROMPT ===================================================
PROMPT FUNCIONES AVANZADAS
PROMPT ===================================================

PROMPT FUNCION AVANZADA 1 - CLASIFICAR NIVEL DE HABILIDADES DEL EMPLEADO

create or replace function fun_espe_hab_emp(Pid_emp in number)
return varchar2 is
    Vcantidad_hab number;
    Vpromedio_nivel number;
    Vclasificacion varchar2(25);
begin
    select count(*)
    into Vcantidad_hab
    from habilidades
    where id_emp = Pid_emp;
    
    select avg(nivel_hab)
    into Vpromedio_nivel
    from habilidades
    where id_emp = Pid_emp;
    
    if Vcantidad_hab >= 3 and Vpromedio_nivel >= 2 then
        Vclasificacion := 'BASTANTE ESPECIALIZADO';
    elsif Vcantidad_hab >= 2 and Vpromedio_nivel >= 1 then
        Vclasificacion := 'ESPECIALIZADO BASICO';
    else
        Vclasificacion := 'POCO ESPECIALIZADO';
    end if;
    
    return ' clasificacion: '||Vclasificacion;
end fun_espe_hab_emp;
/
show error

select fun_espe_hab_emp(102) ESPECIALIZACION from dual;
select fun_espe_hab_emp(103) ESPECIALIZACION from dual;
select fun_espe_hab_emp(104) ESPECIALIZACION from dual;

PROMPT FUNCION AVANZADA 2 - CLASIFICAR SALARIO DEL EMPLEADO POR EL PROMEDIO DE UN DEPARTAMENTO

create or replace function fun_clas_sal_emp(Pid_emp in number, Pid_depto in number)
return varchar2 is
    Vsalario number;
    Vpromedio number;
    Vclasificacion varchar2(25);
begin
    select salary 
    into Vsalario
    from employees
    where employee_id = Pid_emp;

    select avg(salary) 
    into Vpromedio
    from employees
    where department_id = Pid_depto;


    if Vsalario > Vpromedio then
        Vclasificacion := 'ALTO';
    elsif Vsalario = Vpromedio then
        Vclasificacion := 'MEDIO';
    else
        Vclasificacion := 'BAJO';
    end if;

    return Vclasificacion;
end fun_clas_sal_emp;
/
show error

select fun_clas_sal_emp(100, 10) CLASIFICACION_SALARIO from dual;
select fun_clas_sal_emp(101, 20) CLASIFICACION_SALARIO from dual;
select fun_clas_sal_emp(102, 80) CLASIFICACION_SALARIO from dual;


PROMPT FUNCION AVANZADA 3 - DIFERENCIA DE SALARIO maximo y minimo de depto

create or replace function fun_rango_sal_depto(Pid_depto in number)
return varchar2 is
    Vsalario_max number;
    Vsalario_min number;
    Vrango number;
    Vclasificacion varchar2(15);
begin
    select max(salary), min(salary) 
    into Vsalario_max, Vsalario_min
    from employees
    where department_id = Pid_depto;
    
    Vrango := Vsalario_max - Vsalario_min;
    
    if Vrango > 10000 then
        Vclasificacion := 'RANGO ALTO';
    elsif Vrango > 5000 then
        Vclasificacion := 'RANGO MEDIO';
    else
        Vclasificacion := 'RANGO BAJO';
    end if;
    
    return 'Diferencia: ' || Vrango || ' (' || Vclasificacion || ')';
end fun_rango_sal_depto;
/
show error

select fun_rango_sal_depto(10)  RANGO_DEPARTAMENTO from dual;
select fun_rango_sal_depto(100) RANGO_DEPARTAMENTO from dual;
select fun_rango_sal_depto(50)  RANGO_DEPARTAMENTO from dual;


PROMPT ===================================================
PROMPT PROCEDIMIENTOS BASICOS
PROMPT ===================================================



PROMPT PROCEDIMIENTO BASICO 1 - CONTAR EMPLEADO POR DEPARTAMENTO ESPECIFICO

create or replace procedure prc_cont_emp_depto(Pid_depto in number) 
is
    VCantidad number;
begin
    select count(*)
    into VCantidad
    from employees
    where department_id = Pid_depto;

    DBMS_OUTPUT.PUT_LINE(
        'Departamento: ' || Pid_depto || ' - Cantidad de empleados: ' || VCantidad
        );
end prc_cont_emp_depto;
/
show error

execute prc_cont_emp_depto(10);
execute prc_cont_emp_depto(50);
execute prc_cont_emp_depto(100);

PROMPT PROCEDIMIENTO BASICO 2 - ACTUALIZAR EL NIVEL DE HABILIDAD

create or replace procedure prc_act_niv_hab(
    Pid_hab in number,
    Pnuevo_nivel in number
)is
    V_nombre varchar2(25);
begin 
    select nombre_hab
    into V_nombre
    from habilidades
    where id = Pid_hab;

    update habilidades
    set nivel_hab = Pnuevo_nivel
    where id = Pid_hab;

    DBMS_OUTPUT.PUT_LINE(
        'Habilidad : ' || v_nombre || ' ahora tiene nivel: ' || Pnuevo_nivel
    );
end prc_act_niv_hab;
/
show error

execute prc_act_niv_hab (1,6);
execute prc_act_niv_hab (2,7);
execute prc_act_niv_hab (3,8);


PROMPT PROCEDIMIENTO BASICO 3 - DATOS DE EMPLEADO ESPECIFICO 

create or replace procedure prc_datos_emp(Pid_emp in number)
is 
    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;
    v_job employees.job_id%TYPE;
    v_sal employees.salary%TYPE;
begin
 select first_name, last_name, job_id, salary
    into v_fname, v_lname, v_job, v_sal
  from employees
  where employee_id = Pid_emp;

  DBMS_OUTPUT.PUT_LINE('datos del empleado: ' || Pid_emp);
  DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_fname || ' ' || v_lname);
  DBMS_OUTPUT.PUT_LINE('Trabajo: ' || v_job);
  DBMS_OUTPUT.PUT_LINE('Salario: ' || v_sal);

end prc_datos_emp;
/
show error
execute prc_datos_emp(102);
execute prc_datos_emp(103);
execute prc_datos_emp(104);


PROMPT ===================================================
PROMPT PROCEDIMIENTOS AVANZADOS
PROMPT ===================================================

PROMPT PROCEDIMIENTO AVANZADO 1 - CLASIFICACION DE TODOS LOS SALARIOS DE LOS EMPLEADOS

create or replace procedure prc_total_sal_con_clasif is
  cursor c_emp is
    select employee_id, first_name, last_name, salary, department_id
    from employees
    order by employee_id;

  v_total number := 0;
  v_count number := 0;
  v_clas varchar2(50);
begin
  for r in c_emp loop
    v_total := v_total + nvl(r.salary,0);
    v_count := v_count + 1;

    --funcion avanzada 2
    v_clas := fun_clas_sal_emp(r.employee_id, r.department_id);

    DBMS_OUTPUT.PUT_LINE(
      'Empleado:'||r.employee_id||' - '||r.first_name||' '||r.last_name||' - Salario:  '||r.salary||' - Clasificacion:  '||v_clas
    );
  end loop;

  DBMS_OUTPUT.PUT_LINE('Total empleados procesados: '||v_count);
  DBMS_OUTPUT.PUT_LINE('Total acumulado de salarios (empresa): '||v_total);
end prc_total_sal_con_clasif;
/
show error

execute prc_total_sal_con_clasif;


PROMPT PROCEDIMIENTO AVANZADO 2 - MOSTRAR A LOS EMPLEADOS Y SU NIVEL DE HABILIDAD QUE SUPERAN UN VALOR DE SALARIO 

create or replace procedure prc_emp_sal_hab_depto(
    Pval in number, 
    Pcant in number,
    Pid_depto in number
) is
  cursor c_emp is
    select employee_id, first_name, last_name, salary, department_id
    from employees
    where department_id = Pid_depto
    order by salary desc;


  Vcant NUMBER := 0;
  v_hab varchar2(100);
begin
  DBMS_OUTPUT.PUT_LINE('Empleados con salario > '||Pval||' en el departamento: ' ||Pid_depto||' :' );

  for r in c_emp loop
    if (r.salary > Pval) and (Vcant < Pcant) then
      -- funcion avanzada 3
      Vcant := Vcant +1 ;
      v_hab := fun_espe_hab_emp(r.employee_id);

      DBMS_OUTPUT.PUT_LINE('Emp: '||r.employee_id ||' dep: '|| r.department_id||' - '||r.first_name||' '||r.last_name||' - Sal:'||r.salary||' - Esp_Hab:'||v_hab);
    end if;
  end loop;
end prc_emp_sal_hab_depto;
/
show error

execute prc_emp_sal_hab_depto(1000,3,10);
execute prc_emp_sal_hab_depto(5000,5,50);
execute prc_emp_sal_hab_depto(2000,10,30);


PROMPT PROCEDIMIENTO AVANZADO 3 - DESCRIPCION DE DEPARTAMENTOS

CREATE OR REPLACE PROCEDURE prc_resumen_departamentos IS

  CURSOR c_dept IS
    SELECT department_id, department_name
    FROM departments
    ORDER BY department_id;

  v_count NUMBER;
  v_avg   NUMBER;

BEGIN
  FOR d IN c_dept LOOP
    --funcion basica 1
    v_count := fun_cant_emp_depto(d.department_id);

    IF v_count >= 3 THEN

      SELECT AVG(salary)
      INTO v_avg
      FROM employees
      WHERE department_id = d.department_id;

      DBMS_OUTPUT.PUT_LINE(
        'Departamento:' || d.department_id || ' - ' || d.department_name ||' - Cant.Empleados:' || v_count ||' - Prom.Salario:' || v_avg
      );

    END IF;

  END LOOP;

END prc_resumen_departamentos;
/
show error
execute prc_resumen_departamentos;


PROMPT ===================================================
PROMPT TEORIA DE CONJUNTOS
PROMPT ===================================================


PROMPT CONJUNTO 1 - Hijos menores de 10 UNION mayores de 15

SELECT nombre_hijo, edad
FROM hijos
WHERE edad > 10
UNION
SELECT nombre_hijo, edad
FROM hijos
WHERE edad < 15;



PROMPT CONJUNTO 2 - Empleados con SQL Y JAVA

SELECT id_emp
FROM habilidades
WHERE nombre_hab = 'SQL'
INTERSECT
SELECT id_emp
FROM habilidades
WHERE nombre_hab = 'Java';



PROMPT CONJUNTO 3 - Empleados con SQL pero NO JAVA

SELECT id_emp
FROM habilidades
WHERE nombre_hab = 'SQL'
MINUS
SELECT id_emp
FROM habilidades
WHERE nombre_hab = 'Java';

--SPOOL OFF
EXIT


-- NOMBRE : JOSUE DAVID SANCHEZ SALAZAR
-- CEDULA : 118840506
-- GRUPO  : MAR - VIE 1:00 PM 