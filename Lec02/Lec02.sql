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

drop user conta cascade;
drop user planilla cascade;

create user conta identified by conta123;
create user planilla identified by planilla123;

grant dba to conta,planilla;

create table conta.pueba1(id number);
create table planilla.pueba1(id number);


show user

-- Finaliza la escritura en el archivo log - 
SPOOL OFF

-- Cierra la sesión de SQL*Plus automáticamente
EXIT
