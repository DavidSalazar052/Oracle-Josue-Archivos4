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

-- ==============================================================================================
-- Link de Video:
SPOOL &1..log

PROMPT ==============================================
PROMPT Tarea 01 - Josue David Sanchez - 118840506

-- Ejecutar los comandos... 
SELECT SYSDATE FROM dual;
--select * from dba_data_files;

-- drop user test cascade;
-- create user test identified by test123;
-- grant dba to test;

DROP TABLE Josue;

CREATE TABLE Josue (
	ID NUMBER,
	NOMBRE VARCHAR(15),
	SALARIO NUMBER 	
);

INSERT INTO Josue (ID,NOMBRE,SALARIO) VALUES (1,'Manuel',3000);
INSERT INTO Josue (ID,NOMBRE,SALARIO) VALUES (2,'Ana',3000);


SELECT * FROM Josue;

UPDATE Josue SET NOMBRE = 'Josue S.S' WHERE ID = 1;
UPDATE Josue SET SALARIO = 4000 WHERE ID = 1;
COMMIT;

SELECT * FROM Josue;

DELETE FROM Josue WHERE ID =2;
COMMIT;

SELECT * FROM Josue;

-- Finaliza la escritura en el archivo log
SPOOL OFF

-- Cierra la sesión de SQL*Plus automáticamente
EXIT
