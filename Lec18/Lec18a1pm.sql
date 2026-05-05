-- Lec18.sql  24-abr-2026
-- Tema: Excepciones en Oracle
-- Usar:  ejec3.bat Lec18a // Esta version muestra mejor las EÑES y TILDES en PROMPT
-- Usar:  Lec09-hr-y-mascotas2.sql (emp 101 +1 mascota, no genera SPOOL)


PROMPT ====Conectar con bases1===========
conn bases1/bases123@FREEPDB1
--Condiciones de configuracion ya vistas antes (Para usar DBMS_OUTPUT.PUT_LINE)
SET FEEDBACK ON 
SET PAGESIZE 50
SET LINESIZE 150
SET TRIMSPOOL ON
SET SERVEROUTPUT ON SIZE UNLIMITED
prompt 
prompt 
prompt ============================================
prompt Ejemplo #1 FUN_salario_por_id
prompt ============================================
prompt ...
prompt ...

create or replace function FUN_salario_por_id(
  Pid number
) return number is
  VSalario number(10,2);
begin
  VSalario := 1/Pid;
  select salary
  into VSalario
  from employees
  where employee_id = Pid;
  return VSalario;
exception
  when others then
    return -1;
    dbms_output.put_line('Error General: ' || sqlerrm);
  -- when zero_divide then
    -- return -3;
    -- dbms_output.put_line('Error: Div por Cero para Emp ' || Pid);
  -- when no_data_found then
    -- return -2;
    -- dbms_output.put_line('Error: No Existe El Empleado ' || Pid);
end FUN_salario_por_id;
/
show error

PROMPT ................................
PROMPT === SIN EXCEPCIÓN (empleado existe 101)
select FUN_salario_por_id(101) as resultado from dual;

PROMPT ................................
PROMPT === GENERA no_data_found VER: NOTA IMPORTANTE!
select FUN_salario_por_id(9999) as resultado from dual;

PROMPT ................................
PROMPT === ID empleado 0 ???
select FUN_salario_por_id(0) as resultado from dual;


PROMPT ................................
/*
==== NOTA IMPORTAMTE ====
DBMS_OUTPUT NO imprime inmediatamente
se guarda en un buffer y se muestra al final

En procedimientos, como no hay resultado, si se muestra solo el mensaje!
*/ 

prompt 
prompt 
prompt ============================================
prompt Ejemplo #2 FUN_una_mascota
prompt ============================================
prompt ...
prompt ...
create or replace function FUN_una_mascota(
  Pid number
) return varchar2 is

  
  VNombre    varchar2(50);
  Vtemporal  number;
begin
  Vtemporal := 1/Pid;
  select nombre
  into VNombre
  from mascotas
  where id_emp = Pid;

  return VNombre;

exception
  when no_data_found then
    dbms_output.put_line('Aviso: No Tiene Mascotas El Empleado ' || Pid);
    return 'sin mascota';
  when too_many_rows then
    dbms_output.put_line('Aviso: Tiene Multiples Mascotas El Empleado ' || Pid);
    return 'multiples';
  when zero_divide then
    dbms_output.put_line('Aviso: División por Cero para Emp ' || Pid);
    return 'Div x Cero';
  when others then
    dbms_output.put_line('Error General: ' || sqlerrm);
    return 'error';

end FUN_una_mascota;
/

column nom_mascota format A12

PROMPT ................................
PROMPT === SIN EXCEPCIÓN (empleado con 1 mascota) 
select FUN_una_mascota(101) as nom_mascota from dual;

PROMPT ................................
PROMPT === GENERA too_many_rows
select FUN_una_mascota(103) as nom_mascota from dual;

PROMPT ................................
PROMPT === GENERA no_data_found
select FUN_una_mascota(9999) as nom_mascota from dual;

PROMPT ................................
PROMPT === con Pid = 0
select FUN_una_mascota(0) as nom_mascota from dual;
PROMPT ................................

prompt 
prompt 
prompt ============================================
prompt Ejemplo #3 PRC_promedio_peso
prompt ============================================
prompt ...
prompt ...
create or replace procedure PRC_promedio_peso(
  Pid number
) is

  VSuma number(10,2);
  VCant number(10);
  VProm number(10,2);

begin

  select nvl(sum(peso),0), count(*)
  into VSuma, VCant
  from mascotas
  where id_emp = Pid;

  VProm := VSuma / VCant;

  dbms_output.put_line(
    'Resultado: Promedio De Peso = ' || VProm
  );

exception
  when zero_divide then
    dbms_output.put_line(
      'Error: Division Entre Cero - No Tiene Mascotas'
    );

  when others then
    dbms_output.put_line('Error General: ' || sqlerrm);

end PRC_promedio_peso;
/
PROMPT ................................
PROMPT === SIN EXCEPCIÓN
execute PRC_promedio_peso(102);

PROMPT ................................
PROMPT === GENERA zero_divide
execute PRC_promedio_peso(9999);
PROMPT ................................

prompt 
prompt 
prompt ============================================
prompt Ejemplo #4 PRC_buscar_empleado
prompt ============================================
prompt ...
prompt ...

create or replace procedure PRC_buscar_empleado(
  Pid varchar2
) is

  VId number(10);
  VSalario number(10,2);

begin

  select employee_id, salary
  into VId, VSalario
  from employees
  where first_name = Pid;

  dbms_output.put_line(
    'Resultado: Empleado ' || VId || ' Salario ' || VSalario
  );

exception
  when no_data_found then
    dbms_output.put_line(
      'Error: No Existe Empleado Con Nombre ' || Pid
    );

  when too_many_rows then
    dbms_output.put_line(
      'Error: Multiples Empleados Con Nombre ' || Pid
    );

  when others then
    dbms_output.put_line(
      'Error General: ' || sqlerrm
    );

end PRC_buscar_empleado;
/

PROMPT ................................
PROMPT === SIN EXCEPCIÓN Neena
execute PRC_buscar_empleado('Neena');

PROMPT ................................
PROMPT === GENERA too_many_rows
execute PRC_buscar_empleado('John');

PROMPT ................................
PROMPT === GENERA no_data_found
execute PRC_buscar_empleado('June');
PROMPT ................................


PROMPT ====fin===========

--SPOOL OFF
EXIT
