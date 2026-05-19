-- Lec21.sql  24-abr-2026
-- Tema: Excepciones en Oracle + 
-- Usar:  ejec3.bat Lec18 // ESta version muestra mejor las EÑES y TILDES en PROMPT
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
  select salary
  into VSalario
  from employees
  where employee_id = Pid;
  return VSalario;
exception
  when no_data_found then
    dbms_output.put_line('Error: No Existe El Empleado ' || Pid);
    return -2;
  when others then
    dbms_output.put_line('Error General: ' || sqlerrm);
    return -1;
end FUN_salario_por_id;
/
PROMPT ................................
PROMPT === SIN EXCEPCIÓN (empleado existe)
select FUN_salario_por_id(101) as resultado from dual;

PROMPT ................................
PROMPT === GENERA no_data_found VER: NOTA IMPORTANTE!
select FUN_salario_por_id(9999) as resultado from dual;
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

  VNombre varchar2(50);

begin

  select nombre
  into VNombre
  from mascotas
  where id_emp = Pid;

  return VNombre;
--esto es como un IF pero con condicion de exception unica
--si se dispara un un NDF puede retorna null
exception
  when no_data_found then
    dbms_output.put_line('Aviso: No Tiene Mascotas El Empleado ' || Pid);
    return 'sin mascota';

  when too_many_rows then
    dbms_output.put_line('Aviso: Tiene Multiples Mascotas El Empleado ' || Pid);
    return 'multiples';

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

PROMPT Nombres Unicos
-- el group by no entra pero es bueno conocerlo
-- el like tampoco lo vemos
select first_name, count(*) cant
from  employees
where  first_name like 'D%'
group by first_name
having count(*) = 1
order by 1;


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
PROMPT === SIN EXCEPCIÓN Diana
execute PRC_buscar_empleado('Diana');

PROMPT ................................
PROMPT === GENERA too_many_rows John
execute PRC_buscar_empleado('John');

PROMPT ................................
PROMPT === GENERA no_data_found June
execute PRC_buscar_empleado('June');
PROMPT ................................



prompt *******************************************************
prompt *NUEVO* DUP_VAL_ON_INDEX 05-may-2025
prompt *******************************************************
prompt 
prompt 

prompt ============================================
prompt Ejemplo #5 PRC_insertar_mascota (INSERT)
prompt ============================================

create or replace function fun_ver_mas(Pid in number) return number is 
  Vcantidad number;
begin 
  select count(*)
  into Vcantidad
  from mascotas
  where id = Pid;
  return Vcantidad;
end fun_ver_mas;
/

show error

select * from mascotas order by 1;

create or replace procedure PRC_insertar_mascotas2(P_id     number,
  P_nom    varchar2, P_id_emp number, P_peso   number, P_tipo varchar2) is
begin
  if fun_ver_mas(P_id) = 0 then

    insert into mascotas(id, nombre, peso, tipo, id_emp) values
    (P_id, P_nom, P_peso, P_tipo, P_id_emp );
    commit;
    
    dbms_output.put_line('OK: Mascota ' || P_nom || ' insertada correctamente.');
    commit;
  end if;

exception
  when DUP_VAL_ON_INDEX then
    dbms_output.put_line('Error: El ID ' || P_id || ' ya está registrado para otra mascota.');
    
  when others then
    dbms_output.put_line('Error General: ' || sqlerrm);
    rollback;
end PRC_insertar_mascotas2;
/
show error

PROMPT ................................
PROMPT === PRUEBA INSERT DUPLICADO
-- Intentamos insertar un ID que ya existe
execute PRC_insertar_mascotas2(1000, 'Doggy2', 103, 15,'perro');
execute PRC_insertar_mascotas2(1000, 'Doggy3', 103, 15,'perro');


prompt ============================================Lista Parcial emails
select employee_id, email
from   employees
where  employee_id < 110;

prompt ============================================
prompt Ejemplo #6 (Modificado) PRC_actualizar_email
prompt ============================================
-- solucion mas elegante hacer una validación (funcion)
-- una funcion que cuente cuantos empleados tienen ese gmail (llave unica)

create or replace function fun_ver_email(Pemail in varchar2) return number is 
  Vcantidad number;
begin 
  select count(*)
  into Vcantidad
  from employees
  where email = Pemail;
  return Vcantidad;
end fun_ver_email;
/

show error


create or replace procedure PRC_actualizar_email(
  P_id_emp    number,
  P_nuevo_mail varchar2
) is
begin
  if fun_ver_email(P_nuevo_mail) = 0 then 
      -- Intentamos actualizar el email del empleado
      update employees
      set email = P_nuevo_mail
      where employee_id = P_id_emp;
    
      commit;
  end if;

exception
  -- Esta excepción captura la violación de la restricción UNIQUE del campo EMAIL
  when DUP_VAL_ON_INDEX then
    dbms_output.put_line('Error: El email ''' || P_nuevo_mail || ''' ya está en uso por otro empleado.');
    rollback;

  when others then
    dbms_output.put_line('Error General: ' || sqlerrm);
    rollback;
end PRC_actualizar_email;
/

PROMPT ................................
PROMPT === PRUEBA UPDATE EMAIL DUPLICADO
execute PRC_actualizar_email(101, 'SKING');

PROMPT ................................
PROMPT === PRUEBA UPDATE EXITOSO
execute PRC_actualizar_email(103, 'BERNST2');

PROMPT ====fin===========

EXIT
