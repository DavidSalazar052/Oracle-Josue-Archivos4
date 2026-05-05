Notas Lec 18
============

Virtual!

--------------------------------------------------------------
Tema entrega proyecto:
+ Hasta Hoy atiendo consultas.  8pm. 


+ Logica de negocios inventada
  empleados Mascotas + empleados TI. (union)
  
  varias tablas adicionales.
  conceptos
  ...
+ Todos tienen un 100%, si cumplen, compile, no errorer.
  No usar IAs!!!
  
+ Forro Listo, Martes 28 o se corre..//
  Practica 100% presencial..
  
+ Tema de hoy: Exceptions.. No entra en la practica No 2.!!!
--------------------------------------------------------------
Lec 18 (Excepciones de Oracle) 1pm
Lec 18 (Excepciones de Oracle) 3pm
-------------------------------

1) Aula Virtual avisos: Lec18.zip

2) Grupos de WA: Lec18.zip

3) Web Lec18.zip: https://www.crnube.com/Lec18.zip 

--------------------------------------------------------------
Normas de Lecciones Virtuales.
=============================
+ Microfono apagado
+ Hablar si tienen preguntas. (Pueden interrumpirme) **
+ Tema teoríco-práctico!
--------------------------------------------------------------


Lec 18 (Excepciones de Oracle) 1pm
Lec 18 (Excepciones de Oracle) 3pm

+ Todos pueden omitir sala de espera.

--------------------------------------------------------------
--------------------------------------------------------------

Listo, vamos a los scripts!

PDF primero! Conceptos!

#0 
    cambiar ejec3.bat el CID **** ACLARO!!

#1
    .\ejec3.bat Lec09-hr-y-mascotas2

#2   OJO #Guardar como Lec18a.sql // Carpeta Docker!
     .\ejec3.bat Lec18a
--------------------------------------------------------------

Explicaciones
--205 + 206
PROMPT === SIN EXCEPCIÓN Neena
execute PRC_buscar_empleado('Neena');

comentar 
34 35 36
  -- when no_data_found then
    -- dbms_output.put_line('Error: No Existe El Empleado ' || Pid);
    -- return -2;
	
 RESULTADO
----------
        -2

1 row selected.

Error: No Existe El Empleado 9999


---OJO
RESULTADO
----------
        -1

1 row selected.

Error General: ORA-01403: no data found


  VSalario := 1/0;
  
  --ENTONCES AMBOS: ERROR!!
................................
=== SIN EXCEPCIÓN (empleado existe 101)

 RESULTADO
----------
        -1

1 row selected.

Error General: ORA-01476: divisor is equal to zero
................................
=== GENERA no_data_found VER: NOTA IMPORTANTE!

 RESULTADO
----------
        -1

1 row selected.

Error General: ORA-01476: divisor is equal to zero
................................

VARIABLE DEFAULT ORACLE: sqlerrm
 ASI:   
      ORA-01403: no data found
      ORA-01476: divisor is equal to zero
	  
34...40 comentamos
--exception
  -- when no_data_found then
    -- dbms_output.put_line('Error: No Existe El Empleado ' || Pid);
    -- return -2;
  -- when others then
    -- dbms_output.put_line('Error General: ' || sqlerrm);
    -- return -1
	
-- NO MANEJAMOS EXCEPCION "se nos cae el sistema"
................................
=== SIN EXCEPCIÓN (empleado existe 101)
select FUN_salario_por_id(101) as resultado from dual
       *
ERROR at line 1:
ORA-01476: divisor is equal to zero
ORA-06512: at "BASES1.FUN_SALARIO_POR_ID", line 6
Help: https://docs.oracle.com/error-help/db/ora-01476/


................................
=== GENERA no_data_found VER: NOTA IMPORTANTE!
select FUN_salario_por_id(9999) as resultado from dual
       *
ERROR at line 1:
ORA-01476: divisor is equal to zero
ORA-06512: at "BASES1.FUN_SALARIO_POR_ID", line 6
Help: https://docs.oracle.com/error-help/db/ora-01476/


................................

--Dummy
VSalario := 1/Pid;


si no hay manejo de no_data_found "no se cae"
retorna null.


---OTRO EJEMPLO
PROMPT ................................
PROMPT === GENERA no_data_found VER: NOTA IMPORTANTE!
select FUN_salario_por_id(9999) as resultado from dual;

PROMPT ................................
PROMPT === ID empleado 0 ???
select FUN_salario_por_id(0) as resultado from dual;


--RESULTADO!!

=== ID empleado 0 ???
select FUN_salario_por_id(0) as resultado from dual
       *
ERROR at line 1:
ORA-01476: divisor is equal to zero
ORA-06512: at "BASES1.FUN_SALARIO_POR_ID", line 6
Help: https://docs.oracle.com/error-help/db/ora-01476/


--------------------------------------------------------------
--FUN_salario_por_id
Trabajo en clase #1
===================
--activamos todas, others + no_data_found // quitamos comentarios.
programe la excepcion 
retorne  -3   zero_divide  ??? **

--mensaje de "Div por cero.."  dbms_output.put_line 

-- zero?  no_date? orden de estos dos.. no importa
-- ANTES del when others--- de ultimo!!

--------------------------------------------------------------
R/

exception
  when zero_divide then
    dbms_output.put_line('Error: Div por Cero para Emp ' || Pid);
    return -3;
  when no_data_found then
    dbms_output.put_line('Error: No Existe El Empleado ' || Pid);
    return -2;
  when others then
    dbms_output.put_line('Error General: ' || sqlerrm);
    return -1;
end FUN_salario_por_id;

--------------------------------------------------------------
Trabajo en clase #2 
===================
primero el return.. y el mensaje de segundo....??









































R/
  when zero_divide then
    return -3;
    dbms_output.put_line('Error: Div por Cero para Emp ' || Pid);
  when no_data_found then
    return -2;
    dbms_output.put_line('Error: No Existe El Empleado ' || Pid);
  when others then
    return -1;
    dbms_output.put_line('Error General: ' || sqlerrm);
	
--SALIDA QUE ASI

................................
=== SIN EXCEPCIÓN (empleado existe)

 RESULTADO
----------
     17000

1 row selected.

................................
=== GENERA no_data_found VER: NOTA IMPORTANTE!

 RESULTADO
----------
        -2

1 row selected.

................................
=== GENERA Pid = 0

 RESULTADO
----------
        -3

1 row selected.

................................


--------------------------------------------------------------

Trabajo en clase #3
===================
debajo del begin retorne -8 ***???





















R/
Todos va a retornar
-8
no hace ningun cálculo!!
--------------------------------------------------------------

Trabajo en clase #4
===================
quitar el return -8


poner el when others de primero.. !!!
zero   
no_data

compilan?=??




























R/
show error

Warning: Function created with compilation errors.

Errors for FUNCTION FUN_SALARIO_POR_ID:

LINE/COL ERROR
-------- -----------------------------------------------------------------
0/0      PL/SQL: Compilation unit analysis terminated
13/3     PLS-00370: OTHERS handler must be last among the exception
         handlers of a block




=== SIN EXCEPCIÓN (empleado existe 101)
select FUN_salario_por_id(101) as resultado from dual
       *
ERROR at line 1:
ORA-06575: Package or function FUN_SALARIO_POR_ID is in an invalid state
Help: https://docs.oracle.com/error-help/db/ora-06575/


................................
=== GENERA no_data_found VER: NOTA IMPORTANTE!
select FUN_salario_por_id(9999) as resultado from dual
       *
ERROR at line 1:
ORA-06575: Package or function FUN_SALARIO_POR_ID is in an invalid state
Help: https://docs.oracle.com/error-help/db/ora-06575/


................................
=== ID empleado 0 ???
select FUN_salario_por_id(0) as resultado from dual
       *
ERROR at line 1:
ORA-06575: Package or function FUN_SALARIO_POR_ID is in an invalid state
Help: https://docs.oracle.com/error-help/db/ora-06575/


................................



--------------------------------------------------------------

Trabajo en clase #5
===================
--dejar solo When others y comentar las otras 2 excepciones.

--------------------------------------------------------------
Trabajo en clase #6
===================
FUN_una_mascota

variable... 
Vtemporal  number;
--inicio
Vtemporal := 1/0;
--------------------------------------------------------------
Trabajo en clase #7
===================
Programen la excepcion zero_divide ??
   'div x cero'  
   Mensaje: 'AViso: División por cero'
--------------------------------------------------------------

Trabajo en clase #8
===================

--
Vtemporal := 1/Pid;

agregar una ejecución con ID de empleado CERO?

--------------------------------------------------------------
Tarea Moral.
============

--probar, agregar excepciones, dejar solo when others
--dejar sin ninguna excepción..

PRC_promedio_peso

--hacer pruebas dejar solo when others
--dejar sin ninguna excepción..
--cambiar el orden de excepcion.. others al final!!
PRC_buscar_empleado

--------------------------------------------------------------

Si la vamos a ver:

DUP_VAL_ON_INDEX

--Total 22+1 excepciones predefinidas.
ACCESS_INTO_NULL -6530
CASE_NOT_FOUND -6592
COLLECTION_IS_NULL -6531
CURSOR_ALREADY_OPEN -6511
 DUP_VAL_ON_INDEX -1
INVALID_CURSOR -1001
INVALID_NUMBER -1722
LOGIN_DENIED -1017
 NO_DATA_FOUND +100
NO_DATA_NEEDED -6548
NOT_LOGGED_ON -1012
PROGRAM_ERROR -6501
ROWTYPE_MISMATCH -6504
SELF_IS_NULL -30625
STORAGE_ERROR -6500
SUBSCRIPT_BEYOND_COUNT -6533
SUBSCRIPT_OUTSIDE_LIMIT -6532
SYS_INVALID_ROWID -1410
TIMEOUT_ON_RESOURCE -51
 TOO_MANY_ROWS -1422
VALUE_ERROR -6502
 ZERO_DIVIDE -1476
OTHERS
--------------------------------------------------------------
--------------------------------------------------------------
--------------------------------------------------------------
















