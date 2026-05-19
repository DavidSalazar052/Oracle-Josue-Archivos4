/*

Entrega Lunes 11 de Mayo 2026, máximo 10PM // individual // No usar IA's !!! ya lo saben!

Tarea 03 + Tarea 04  VALE DOBLE! // haber corrido "Lec09-hr-y-mascotas2.sql"

Martes 12 mayo, Quiz No 2.. // ***

Entregan un solo script con todo!


Entregable:
Tarea_03_04_Nombre_Apellido.sql en zip Tarea_03_04_Nombre_Apellido_.zip) 
Sin tildes ni eñes ambos archivos (-10ptos si incumple este formato)


Tarea 03:
Objetivo:  Probar y reforzar conocimiento sobre el funcionamiento de:

Varias versiones de esta funcion.. fun_suma_salarios  o crear mas funciones..//
"similar a el proyecto".
fun_verifica_salario
fun_maximo_salario
.............................................................................
3. CONTROL DE FLUJO (SOLO ESTE VEREMOS) // IF sencillo o bien IF anidado // Senci
IF
ELSIF
ELSIF
ELSE
END IF


IF
..
ELSE
..
END IF


IF
.. 
END IF

.............................................................................
4. CURSORES  // Ya Visto //  exit; // IF 3  exit //   return // ***
CURSOR
FOR c IN Cur_Algo LOOP
 ...
 ..
 .
END LOOP
..
.............................................................................
5. DML (MANIPULACIÓN DE DATOS)  // CREAR al menos 2 Procedimientos

UPDATE  // CON CONDICION DE WHERE
DELETE  // CON CONDICION DE WHERE
.............................................................................
6. FUNCIONES ESTANDAR / AGREGACION // REPASARLAS // PROBARLAS en "mas funciones"
UPPER
LOWER
COUNT
SUM
AVG
MAX
MIN
.............................................................................
7. USO DE FUNCIONES Y PROCEDIMIENTOS
EXEC procedimiento(param1);
EXECUTE procedimiento(param1);

--dentro de PROCEDIMIENTOS
Vresult := fun_algo(valor);
prc_algo(param1, param2);
.............................................................................
8. OPERADORES
=				
<>				 DIFERENTE!!! ANOTAR EN EL FORRO!! *****
<				
>				
<=				
>=				
AND				
OR				**** PROBAR UNO
NOT				// usar not in(Par1, Par2= // 
IN **** USAR ESTE lo hemos visto  ejemplo where id in (Par1, Par2)
.............................................................................
9. CONCATENACIÓN //  dbms_out.put_line
||

Ejemplo:

'Empleado: ' || rec.first_name
.............................................................................
10. ORDER BY 
ORDER BY /// SUPER IMPORTANTE SOBRE TODO EN LOS CURSORES
ASC
DESC
.............................................................................
11. TEORIA DE CONJUNTOS // PROBARLOS ENTENDERLOS
UNION          ****AL MENOS ESTE
INTERSECT    
MINUS    

NO vamos a usar UNION ALL (une repetidos) no entra en prácticas.. solo tener en cuenta que existe.
.............................................................................


*/
PROMPT ====Conectar con bases1===========
conn bases1/bases123@FREEPDB1

SET FEEDBACK ON 
SET PAGESIZE 50
SET LINESIZE 150
SET TRIMSPOOL ON
SET SERVEROUTPUT ON SIZE UNLIMITED

prompt ============================================
prompt Tarea No 03 + 04 // Entrega Lunes 11 de Mayo 2026, 10PM individual
prompt ============================================
prompt  Josue David Sanchez Salazar 
prompt ============================================
prompt ...
prompt ...

drop table empleados cascade constraints;

create table empleados (id number not null, nombre varchar2(50) not null, salario number(10,2) not null);

alter table empleados add constraint empleados_pk primary key (id);

insert into empleados values (100, 'Ana', 4000); 
insert into empleados values (101, 'Pedro', 3000); 
insert into empleados values (102, 'June', 7000);
insert into empleados values (103, 'Ariel', 9000);
insert into empleados values(104, 'Bob', 7000); 
commit;


--FUNCION DE REFERENCIA 
CREATE OR REPLACE FUNCTION fun_suma_salarios( Pid1 NUMBER,Pid2 NUMBER) RETURN NUMBER IS
  CURSOR C_Calcular is
  SELECT salario salario2
    FROM empleados
    WHERE id <> Pid1
    UNION
    SELECT salario salario2
    FROM empleados
    WHERE id <> Pid2;
   VResultado NUMBER := 0;
BEGIN
  FOR x in C_Calcular loop
    VResultado := VResultado+x.salario2;
  END LOOP; 
  return VResultado;
END;
/


CREATE OR REPLACE FUNCTION fun_verifica_salario(Pid NUMBER) 
RETURN VARCHAR2 
IS
  v_nombre empleados.nombre%TYPE;
  v_salario empleados.salario%TYPE;

BEGIN

    SELECT nombre, salario
    INTO v_nombre, v_salario
    FROM empleados
    WHERE id = Pid;

    IF v_salario >= 8000 THEN
      RETURN 'Empleado: ' || UPPER(v_nombre) || ' Salario: ' || v_salario || ' -> ALTO';
    ELSIF v_salario >= 4000 THEN
      RETURN 'Empleado: ' || UPPER(v_nombre) || ' Salario: ' || v_salario || ' -> MEDIO';
    ELSE
      RETURN 'Empleado: ' || UPPER(v_nombre) || ' Salario: ' || v_salario || ' -> BAJO';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'Empleado no existe';

END fun_verifica_salario;
/

CREATE OR REPLACE FUNCTION fun_maximo_salario RETURN NUMBER
IS v_max NUMBER;
BEGIN
    SELECT MAX(salario)
    INTO v_max
    FROM empleados;

    RETURN v_max;

END fun_maximo_salario;
/

CREATE OR REPLACE FUNCTION fun_minimo_salario RETURN NUMBER
IS v_min NUMBER;
BEGIN
    SELECT MIN(salario)
    INTO v_min
    FROM empleados;

    RETURN v_min;

END fun_minimo_salario;
/

CREATE OR REPLACE FUNCTION fun_suma_total_salario RETURN NUMBER
IS v_sum NUMBER;
BEGIN
    SELECT SUM(salario)
    INTO v_sum
    FROM empleados;

    RETURN v_sum;

END fun_suma_total_salario;
/
PROMPT ===================================================
PROMPT 
select fun_suma_salarios(102,101) resultado from dual;
PROMPT ===================================================
PROMPT  
select fun_suma_salarios(100,102) resultado from dual;
PROMPT ===================================================
PROMPT 
select fun_suma_salarios(103,104) resultado from dual;
PROMPT ===================================================
PROMPT 
select fun_suma_salarios(104,103) resultado from dual;
PROMPT ===================================================
PROMPT 
select fun_suma_salarios(-101,-102) resultado from dual;
PROMPT ===================================================
PROMPT 
select fun_suma_salarios(101,101) resultado from dual;
PROMPT ===================================================
PROMPT 
select fun_suma_salarios(-101,101) resultado from dual;
PROMPT ===================================================
PROMPT 
select fun_suma_salarios(102,100) resultado from dual;
PROMPT ===================================================
PROMPT 
select fun_suma_salarios(99,99) resultado from dual;
PROMPT ===================================================
PROMPT 
select fun_suma_salarios(103,102) resultado from dual;
PROMPT ===================================================
PROMPT ===================================================
PROMPT 
SELECT fun_verifica_salario(100) resultado from dual;
PROMPT ===================================================
PROMPT 
SELECT fun_verifica_salario(101) resultado from dual;
PROMPT ===================================================
PROMPT 
SELECT fun_verifica_salario(102) resultado from dual;
PROMPT ===================================================
PROMPT 
SELECT fun_verifica_salario(103) resultado from dual;
PROMPT ===================================================
PROMPT 
SELECT fun_verifica_salario(104) resultado from dual;
PROMPT ===================================================
PROMPT
SELECT fun_maximo_salario resultado from dual;
PROMPT ===================================================
PROMPT
SELECT fun_minimo_salario resultado from dual;
PROMPT ===================================================
PROMPT
SELECT fun_suma_total_salario resultado from dual;

/*
ADEMAS CREAR AL MENOS DOS PROCEDIMIENTOS ****
*/
CREATE OR REPLACE PROCEDURE prc_ing_empleado(
  Pid IN VARCHAR2,
  Pnombre IN VARCHAR2,
  Psalario IN NUMBER
)is
begin
  INSERT INTO empleados (id,nombre,salario)
  VALUES (Pid,Pnombre,Psalario);
  commit;
END prc_ing_empleado;
/

CREATE OR REPLACE PROCEDURE prc_act_salario(p_id NUMBER)
IS
    CURSOR c_emp IS
        SELECT *
        FROM empleados
        WHERE id = p_id;
    v_nuevo_salario NUMBER;
BEGIN
    FOR x IN c_emp LOOP
        v_nuevo_salario := x.salario * 1.05;
        UPDATE empleados
        SET salario = v_nuevo_salario
        WHERE id = x.id;
        DBMS_OUTPUT.PUT_LINE('Aumento aplicado a: ' || x.nombre ||
            ' Salario anterior: ' || x.salario ||' Nuevo salario: ' || v_nuevo_salario
        );
    END LOOP;
    COMMIT;
END prc_act_salario;
/

-- PROCEDIMIENTO ELIMINAR
CREATE OR REPLACE PROCEDURE prc_eli_empleado(Pid NUMBER)
IS
BEGIN

    DELETE FROM empleados
    WHERE id = Pid;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Empleado eliminado ID: ' ||Pid);

END prc_eli_empleado;
/

PROMPT ===================================================
execute prc_ing_empleado(105,'Josue',1);
execute prc_ing_empleado(106,'Daniel',1);
execute prc_ing_empleado(107,'Mathias',1);

SELECT * FROM empleados ORDER BY id DESC;
PROMPT ===================================================
SELECT * FROM empleados ORDER BY salario ASC;
PROMPT ===================================================
SELECT * FROM empleados ORDER BY nombre ASC;


PROMPT ===================================================
PROMPT
execute prc_act_salario(100);
PROMPT ===================================================
PROMPT
execute prc_act_salario(101);
PROMPT ===================================================
PROMPT
execute prc_act_salario(102);
PROMPT ===================================================
PROMPT
execute prc_act_salario(103);
PROMPT ===================================================
PROMPT
execute prc_act_salario(104);
PROMPT ===================================================
PROMPT
execute prc_act_salario(105);
PROMPT ===================================================
PROMPT
execute prc_act_salario(106);
PROMPT ===================================================
PROMPT
execute prc_act_salario(107);
PROMPT ===================================================
PROMPT

execute prc_eli_empleado(105);
execute prc_eli_empleado(106);
execute prc_eli_empleado(107);

SELECT UPPER(nombre) INTERSECCION_EJEMPLO FROM empleados WHERE id <> 100
INTERSECT
SELECT UPPER(nombre) FROM empleados WHERE salario < 1000;

SELECT LOWER(nombre) UNION_EJEMPLO FROM empleados WHERE id NOT IN (101,102,103) 
UNION
SELECT LOWER(nombre) FROM empleados WHERE salario > 1 ORDER BY 1;

execute prc_eli_empleado(105);
execute prc_eli_empleado(106);
execute prc_eli_empleado(107);
SELECT * FROM empleados ORDER BY nombre ASC;

PROMPT ================================================S===
PROMPT ===================================================
PROMPT ***************TAREA 04 INICIA ACA ****************
PROMPT ===================================================
PROMPT ===================================================


/*
Luego de Tarea 03.. al final del script...crear solución de Tarea 04


Tarea 04 // Resolver La práctica No 2 (es la misma tabla con los mismos valores)
y hacer varias pruebas de ejecución y comprobación

Incluye la de puntos Extra

*/


PROMPT ===================================================
PROMPT 1-PROCEDIMIENTO INSERTAR EMPLEADO
-- ya lo habia realizado anteriormente para practicar arriba, pero aqui esta
-- comentado para que se vuelva a ver y el execute funciando tambien
/*
CREATE OR REPLACE PROCEDURE prc_ing_empleado(
  Pid IN VARCHAR2,
  Pnombre IN VARCHAR2,
  Psalario IN NUMBER
)is
begin
  INSERT INTO empleados (id,nombre,salario)
  VALUES (Pid,Pnombre,Psalario);
  commit;
END prc_ing_empleado;
/
*/

execute prc_ing_empleado(108,'EMPLEADO NUEVO-1',1000);
execute prc_ing_empleado(109,'EMPLEADO NUEVO-2',2000);
execute prc_ing_empleado(110,'EMPLEADO NUEVO-3',3000);

select * from empleados ORDER BY id DESC;

PROMPT ===================================================
PROMPT 2-FUNCION PROMEDIO SALARIOS

CREATE OR REPLACE FUNCTION fun_pro_sal RETURN NUMBER
IS Vpromedio NUMBER;
BEGIN
    SELECT AVG(salario)
    INTO Vpromedio
    FROM empleados;
    RETURN Vpromedio;
END;
/
select fun_pro_sal from dual;

PROMPT ===================================================
PROMPT 3-PROCEDIMIENTO MOSTRAR EMPLEADO

CREATE OR REPLACE PROCEDURE prc_mostrar_empleado(
    p_id empleados.id%TYPE
)
IS

    Vnombre empleados.nombre%TYPE;
    Vsalario empleados.salario%TYPE;

BEGIN

    SELECT nombre, salario
    INTO Vnombre, Vsalario
    FROM empleados
    WHERE id = p_id;

    DBMS_OUTPUT.PUT_LINE(
        Vnombre || ' gana ' || Vsalario
    );

END;
/

EXEC prc_mostrar_empleado(100);


PROMPT ===================================================
PROMPT 4-FUNCION TEORIA DE CONJUNTOS
CREATE OR REPLACE FUNCTION fun_suma_empleados(Pid1 NUMBER,Pid2 NUMBER)
RETURN NUMBER IS
    CURSOR c_emp IS
        SELECT id, salario FROM empleados WHERE id = Pid1
        UNION
        SELECT id, salario FROM empleados WHERE id = Pid2;
    Vtotal NUMBER := 0;
BEGIN
    FOR x IN c_emp LOOP
        Vtotal := Vtotal + x.salario;
    END LOOP;
    RETURN Vtotal;
END fun_suma_empleados;
/

SELECT fun_suma_empleados(102,104) resultado FROM dual;
SELECT fun_suma_empleados(103,104) resultado FROM dual;
SELECT fun_suma_empleados(101,102) resultado FROM dual;


PROMPT ===================================================
PROMPT 5-POSICION SALARIO

CREATE OR REPLACE FUNCTION fun_salario_posicion(p_posicion NUMBER)
RETURN NUMBER IS
    CURSOR c_emp IS
        SELECT * FROM empleados ORDER BY id DESC;
    Vcontador NUMBER := 0;
BEGIN
    FOR x IN c_emp LOOP
        Vcontador := Vcontador + 1;
        IF Vcontador = p_posicion THEN
            RETURN x.salario;
        END IF;
    END LOOP;
    RETURN 0;
END;
/

SELECT fun_salario_posicion(1) resultado FROM dual;

SELECT fun_salario_posicion(3) resultado FROM dual;

PROMPT ===================================================
PROMPT 6 - OPCIONAL

CREATE OR REPLACE FUNCTION fun_invertir(Ptexto VARCHAR2)
RETURN VARCHAR2 IS
BEGIN
    IF Ptexto = UPPER(Ptexto) THEN
        RETURN 'original: '|| Ptexto || '-> Conversion: '|| LOWER(Ptexto);
    ELSIF Ptexto = LOWER(Ptexto) THEN
        RETURN 'original: '|| Ptexto || '-> Conversion: '||UPPER(Ptexto);
    ELSE
        RETURN 'original: '|| Ptexto || '-> Conversion: '|| Ptexto;
    END IF;
END;
/
SELECT fun_invertir('JUAN') resultado FROM dual;
SELECT fun_invertir('ana') resultado FROM dual;
SELECT fun_invertir('Juan') resultado FROM dual;

prompt ============================================
prompt  Josue David Sanchez Salazar 
prompt ============================================

PROMPT ====fin===========
EXIT
