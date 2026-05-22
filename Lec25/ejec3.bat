@echo off
REM Limpiar pantalla en cada ejecucion
REM eject3.bat para respetar tildes y eñes
cls

REM ===============================================
REM Script para ejecutar archivos SQL en Docker // DEBEN ESTAR EN LA CARPETA INTERMEDIA 
REM Curso de Bases de Datos
REM ===============================================

REM ID del contenedor Docker donde está Oracle
REM Se obtiene con: docker ps
set CID=74471610f8700a262bdb54b53ffa93f84f20a5e52802e89525e7ca532beef712
REM %1 representa el primer parámetro ingresado
REM Si el estudiante escribe: ejec 1
REM Entonces %1 = 1
REM Esta línea construye el nombre del archivo SQL
set SCRIPT=%1.sql

REM Construye el nombre del archivo LOG de salida
REM Ejemplo: 1.log
set LOG=%1.log

REM Verifica que el estudiante haya escrito un número
REM Si no escribe nada, muestra mensaje de ayuda
if "%1"=="" (
    echo Debe indicar numero de script. Ejemplo:
    echo ejec.bat 1
    exit /b
)

REM Muestra qué script se va a ejecutar
echo Ejecutando %SCRIPT% ...

REM Ejecuta el script dentro del contenedor Docker
REM - docker exec -> ejecuta comando dentro del contenedor
REM - -i -> modo interactivo
REM - bash -lc -> ejecuta comando en shell Linux
REM - sqlplus -S -> modo silencioso
REM - @%SCRIPT% -> ejecuta archivo SQL
REM - %1 -> pasa parámetro para SPOOL dinamico (&1)
docker exec -i %CID% bash -lc "export NLS_LANG=.AL32UTF8;  sqlplus -S system/root@localhost:1521/FREEPDB1 @%SCRIPT% %1"

echo Fin ...