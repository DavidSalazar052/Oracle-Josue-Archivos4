-- ===============================================
-- Script SQL Básico
-- Curso de Bases de Datos
-- ===============================================

-- Activa mensajes de confirmación después de ejecutar comandos
-- Por ejemplo: "1 row selected"
SET FEEDBACK ON

-- Define cuántas filas se muestran antes de repetir encabezados
-- Mejora la visualización en pantalla
SET PAGESIZE 50

-- Inicia la generación de un archivo de salida (log)
-- &1 es el parámetro recibido desde el .BAT
-- Si el estudiante ejecuta: ejec 1
-- Entonces se generará: 1.log

-- El primer punto indica que terminó el nombre de la variable
-- El segundo punto es el punto real del archivo
-- POR ESO ACA doble ..
SPOOL &1..log
PROMPT ========================================
PROMPT Creamos dos usuarios, CONTA Y PLANILLA

-- Ejecutar los comandos... 
-- SELECT 'Leccion 02' FROM dual;
-- select * from dba_data_files;
-- QUITAMOS EL CASCADE y dio varios errores en ORACLE
drop user conta CASCADE;
drop user planilla CASCADE;

create user conta identified by conta123;
create user planilla identified by planilla123;

grant dba to conta,planilla;

create table conta.pueba1(id number,nombre varchar2(10),salario number);
create table planilla.pueba1(id number,nombre varchar2(10),salario number);

drop table prueba1;
create table prueba1(id number,nombre varchar2(10),salario number);
--si no tiene duerño es el usaurio actual conectado, en este caso system

PROMPT ========================================
PROMPT Creamos la P.K de la tabla system.prueba1

alter table prueba1 add CONSTRAINTS prueba1_pk PRIMARY KEY (id);
insert into prueba1(id,nombre,salario) values (1,'Juan',1000);
insert into prueba1(id,nombre,salario) values (2,'Ana',1200);
-- alter table prueba1 add CONSTRAINTS prueba1_pk PRIMARY KEY (id); ESTE NO SE CREA
select * from prueba1;

show user

-- Finaliza la escritura en el archivo log - 
SPOOL OFF

-- Cierra la sesión de SQL*Plus automáticamente
EXIT
