-- Lec15.sql  BASE
--Usar:  ejec2.bat (Sin Spool)

PROMPT ====Conectar con bases1===========
conn bases1/bases123@FREEPDB1

--Condiciones de configuracion ya vistas antes (Para usar DBMS_OUTPUT.PUT_LINE)
SET FEEDBACK ON 
SET PAGESIZE 50
SET LINESIZE 150
SET TRIMSPOOL ON
SET SERVEROUTPUT ON SIZE UNLIMITED

prompt ============================================
prompt Ejemplo #1 fun_calc_aumento + prc_aumentar_salarios_it
prompt ============================================
prompt ...
prompt ...

CREATE OR REPLACE FUNCTION fun_calc_aumento(Psalario NUMBER)
RETURN NUMBER IS
BEGIN
    RETURN Psalario * 1.05;
END;
/
show error


CREATE OR REPLACE PROCEDURE prc_aumentar_salarios_it IS
    CURSOR Cur_emp IS
        SELECT employee_id, salary
        FROM employees
        WHERE department_id = 60;
    Vtotal NUMBER := 0;
BEGIN
    FOR x IN Cur_emp LOOP
        UPDATE employees e
        SET    e.salary = fun_calc_aumento(x.salary)
        WHERE  e.employee_id  = x.employee_id;
        Vtotal := Vtotal + 1;
        DBMS_OUTPUT.PUT_LINE(
            'Empleado ' || x.employee_id || 
            ' actualizado. Salario anterior: ' || x.salary
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('TOTAL ACTUALIZADOS: ' || Vtotal);
END;
/
show error
EXECUTE prc_aumentar_salarios_it;


prompt ============================================
prompt Ejemplo #2 prc_control_mascotas
prompt ============================================
prompt ...
prompt ...
CREATE OR REPLACE PROCEDURE prc_control_mascotas IS
    CURSOR Cur_Emp IS
        SELECT employee_id, first_name
        FROM employees
        WHERE employee_id < 105
        ORDER BY 1;
    Vcant NUMBER;
BEGIN
    FOR x IN Cur_Emp LOOP
        Vcant := fun_cant_masc_emp(x.employee_id);
        IF Vcant = 0 THEN
            prc_ins_mascotas(
                'ABC',
                3,
                'Perro',
                x.employee_id
            );
            DBMS_OUTPUT.PUT_LINE(
                x.first_name || ' no tenía mascota → insertada'
            );
        ELSE
            DBMS_OUTPUT.PUT_LINE(
                x.first_name || ' tiene ' || Vcant || ' mascotas'
            );
        END IF;
    END LOOP;

END;
/
show error
EXECUTE prc_control_mascotas;


prompt ============================================
prompt Ejemplo #3 fun_nuevo_peso + prc_ajustar_peso_mascotas
prompt ============================================
prompt ...
prompt ...
CREATE OR REPLACE FUNCTION fun_nuevo_peso(Ppeso NUMBER)
RETURN NUMBER IS
BEGIN
    RETURN Ppeso * 0.90;
END;
/
show error

CREATE OR REPLACE PROCEDURE prc_ajustar_peso_mascotas IS

    CURSOR c_masc IS
        SELECT id, nombre, peso, id_emp
        FROM mascotas
        ORDER BY 1;
    Vcant NUMBER;
BEGIN
    FOR y IN c_masc LOOP
        Vcant := fun_cant_masc_emp(y.id_emp);
        IF Vcant >= 2 THEN
            UPDATE mascotas
            SET    peso = fun_nuevo_peso(y.peso)
            WHERE  id =  y.id;
            DBMS_OUTPUT.PUT_LINE(
                'Mascota ' || y.nombre || 
                ' actualizada. Peso anterior: ' || y.peso
            );
        END IF;
    END LOOP;
    COMMIT;
END;
/
show error
EXECUTE prc_ajustar_peso_mascotas;

prompt ============================================
prompt Ejemplo #4 prc_subir_salario + prc_aumento_bajos_salarios
prompt ============================================
prompt ...
prompt ...

CREATE OR REPLACE PROCEDURE prc_subir_salario(
    Pemp_id NUMBER,
    Pporcentaje NUMBER
) IS
BEGIN
    UPDATE employees
    SET salary = salary * (1 + Pporcentaje)
    WHERE employee_id = Pemp_id;
END;
/
show error


CREATE OR REPLACE PROCEDURE prc_aumento_bajos_salarios IS
    CURSOR Cur_Emp IS
        SELECT employee_id, first_name
        FROM employees
        WHERE salary < 5000;
    Vtotal NUMBER := 0;
BEGIN
    FOR z IN Cur_Emp LOOP
        prc_subir_salario(z.employee_id, 0.10);
        Vtotal := Vtotal + 1;
        DBMS_OUTPUT.PUT_LINE('Aumento aplicado a: ' || z.first_name);
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('TOTAL PROCESADOS: ' || Vtotal);
END;
/
show error
EXECUTE prc_aumento_bajos_salarios;

prompt ============================================
prompt Ejemplo #5 fun_clasificar_peso IF ELSIF
prompt ============================================
prompt ...
prompt ...

CREATE OR REPLACE FUNCTION fun_clasificar_peso(
    Ppeso NUMBER
) RETURN VARCHAR2 IS
    Vclasificacion VARCHAR2(30);
BEGIN
    IF Ppeso <= 2 THEN
        Vclasificacion := 'Pequena';
    ELSIF Ppeso <= 5 THEN
        Vclasificacion := 'Mediana';
    ELSIF Ppeso <= 10 THEN
        Vclasificacion := 'Med-Grande';
    ELSIF Ppeso <= 20 THEN
        Vclasificacion := 'Grande';
    ELSE
        Vclasificacion := 'Muy Grande';
    END IF;
    RETURN Vclasificacion;
END;
/
show error

column peso_mascota format 999.99
column nom_completo format A25
column nom_mascota format A12
column tam_mascota format A12

--Para que el reporte funcione con varios valores! 
update mascotas set peso = 24 where id = 1000;
update mascotas set peso = 15 where id = 1004;
update mascotas set peso = 1.31 where id = 1003;
update mascotas set peso = 8.56 where id = 1002;
commit;

select e.first_name||' '||e.last_name nom_completo, m.nombre nom_mascota, 
       m.peso peso_mascota, fun_clasificar_peso(m.peso) tam_mascota
from   employees e, mascotas m
where  m.id_emp = e.employee_id;

PROMPT ====fin===========

--SPOOL OFF
EXIT
