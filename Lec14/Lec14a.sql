--Bloques "anonimos" PL/SQL
--Primero Correr G:\Mi unidad\UNA2\2026 Ciclo 1\BD1\Lec14-10-abr-26\Lec09-hr-y-mascotas.sql
--Luego este "n veces".



--NO PODEMOS USAR SPOOL PARA QUE FUNCIONE
--SPOOL &1..log

PROMPT ====Conectar con bases1 PARA USO DE CURSORES===========
conn bases1/bases123@FREEPDB1

--condiciones de configuracion ya vistas antes
SET FEEDBACK ON 
SET PAGESIZE 50
SET LINESIZE 150
SET TRIMSPOOL ON

--SPOOL &1..log

--NUEVA
--Para los Mensajes en pantalla usando : DBMS_OUTPUT. usamos ejec2.bat

--NUEVO!!!!!: es el que usamos para que este OUTPUT nos funcione
SET SERVEROUTPUT ON SIZE UNLIMITED

prompt ============================================
prompt 1. Cursor básico + OPEN / FETCH / CLOSE (un registro)
prompt Ejemplo: traer UN empleado específico
prompt ============================================
prompt Cursor 1: OPEN / FETCH / CLOSE (1 registro)
prompt ...
prompt ...

DECLARE
    CURSOR Cur_Empleados IS
        SELECT employee_id, first_name, salary
        FROM employees
        WHERE employee_id = 100;

    v_id employees.employee_id%type;
    v_name employees.first_name%type;
    v_salary employees.salary%type;

BEGIN
    OPEN Cur_Empleados;

    FETCH Cur_Empleados INTO v_id, v_name, v_salary;

    IF Cur_Empleados%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Empleado: ' || v_id || ' - ' || v_name || ' - Salario: ' || v_salary);
    END IF;

    CLOSE Cur_Empleados;
END;
/
prompt ============================================
prompt 2. Cursor con LOOP manual (varios registros)
prompt Ejemplo: recorrer empleados de un departamento
prompt ============================================
prompt Cursor 2: LOOP manual
prompt ...
prompt ...

DECLARE
    CURSOR Cur_Empleados IS
        SELECT employee_id, first_name, salary
        FROM employees
        WHERE department_id = 60
        ORDER BY salary DESC;

    v_id employees.employee_id%type;
    v_name employees.first_name%type;
    v_salary employees.salary%type;

BEGIN
    OPEN Cur_Empleados;

    LOOP
        FETCH Cur_Empleados INTO v_id, v_name, v_salary;
        EXIT WHEN Cur_Empleados%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(v_id || ' - ' || v_name || ' - ' || v_salary);
    END LOOP;

    CLOSE Cur_Empleados;
END;
/
prompt ============================================
---*********************************************ESTE ES EL QUE VAMOS A VER Y USAR!!! PAra PRact No 2
prompt 3. Cursor FOR LOOP (el más usado ** )
prompt Oracle maneja OPEN/FETCH/CLOSE automáticamente
prompt ============================================
prompt Cursor 3: FOR LOOP (recomendado)
prompt ...
prompt ...
--SI NO COLOCAMOS EL ALIAS DESPUES DE LA FUNCION NO NOS VA A FUNCIONAR
--MODIFICAMOS CURSOS 3 CON UN CONTADOR, CUENTA LA CANTIDAD DE EMPLEADOS QUE MUESTRA

DECLARE
    V_Cant number := 0;
    CURSOR Cur_Empleados IS
        SELECT employee_id,first_name, last_name, salary, fun_cant_masc_emp(employee_id) can_mascota
        FROM employees
        WHERE salary > 10000 
        union 
        SELECT employee_id, first_name, last_name,salary, fun_cant_masc_emp(employee_id) can_mascota
        FROM employees
        WHERE employee_id in (101,102,103)
        ORDER BY 1 DESC;
BEGIN
    FOR rec IN Cur_Empleados LOOP
        V_Cant := V_Cant+1;
        DBMS_OUTPUT.PUT_LINE(rec.employee_id || ' - ' || upper(rec.first_name) ||' - '||lower(rec.last_name) || ' - ' || rec.salary ||' - MASCOTAS: '|| rec.can_mascota);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' Listo se actualizaron esta cantidad de registros = ' || V_Cant);

END;
/
prompt ============================================
prompt 4. Cursor con parámetros
prompt Ojo que p_algo pero en minuscula para diferenciar
prompt ============================================
prompt Cursor 4: con parámetros
prompt ...
prompt ...

DECLARE
    V_Depto number := 80;
    V_Cant number;
    CURSOR Cur_Empleados(p_dept NUMBER) IS
        SELECT employee_id, first_name, salary
        FROM employees
        WHERE department_id = p_dept;

BEGIN
    FOR rec IN Cur_Empleados(V_Depto) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.employee_id || ' - ' || rec.first_name);
    END LOOP;
    select count(*)
    into V_Cant
    from employees 
    where department_id = V_Depto;
    DBMS_OUTPUT.PUT_LINE(V_Cant ||'Cantidad de empleoados del depto'|| V_Depto);
END;
/
prompt ============================================
prompt 5. Cursor + UPDATE (atentos con los detalles)
prompt Subir salario 10% a depto IT
prompt ============================================
prompt Cursor 5: UPDATE con cursor
prompt ...
prompt ...

DECLARE
    V_Cant number := 0;
    CURSOR Cur_Empleados IS
        SELECT employee_id, salary
        FROM employees
        WHERE department_id = 60
        FOR UPDATE;

BEGIN
   --x mas simple
    FOR x IN Cur_Empleados LOOP
	    V_Cant := V_Cant+1;
        UPDATE employees
        SET salary = x.salary * 1
        WHERE CURRENT OF Cur_Empleados;
    END LOOP;

    COMMIT;
	DBMS_OUTPUT.PUT_LINE(' Listo se actualizaron esta cantidad de registros = ' || V_Cant);
END;
/

prompt ============================================
prompt 6. Cursor usando tabla mascotas
prompt Visto en La Lec13
prompt ============================================
prompt Cursor 6: JOIN empleados + mascotas
prompt ...
prompt ...


DECLARE
    CURSOR Cur_Empleados IS
        SELECT e.first_name, m.nombre, m.peso
        FROM employees e, mascotas m
        WHERE e.employee_id = m.id_emp;

BEGIN
    FOR rec IN Cur_Empleados LOOP
        DBMS_OUTPUT.PUT_LINE(rec.first_name || ' - Mascota: ' || rec.nombre || ' (' || rec.peso || 'kg)');
    END LOOP;
END;
/

prompt ============================================
prompt 7. Cursor con COUNT y lógica
prompt ============================================
prompt Cursor 7: lógica con conteo
prompt ...
prompt ...

DECLARE
    CURSOR Cur_Empleados IS
        SELECT employee_id, first_name
        FROM employees;

    v_cant NUMBER;
BEGIN
    FOR rec IN Cur_Empleados LOOP

        SELECT COUNT(*)
        INTO v_cant
        FROM mascotas
        WHERE id_emp = rec.employee_id;

        IF v_cant > 0 THEN
            DBMS_OUTPUT.PUT_LINE(rec.first_name || ' tiene ' || v_cant || ' mascotas');
        END IF;

    END LOOP;
END;
/


prompt ============================================
prompt “Un cursor es como un puntero que recorre un SELECT fila por fila en memoria”
prompt ============================================



PROMPT ====fin===========

--SPOOL OFF
EXIT
