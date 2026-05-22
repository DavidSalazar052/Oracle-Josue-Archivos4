--base tablas de los repasos 12 y 15 de mayo 
--la base de la leccion 26, son los ejemplos de la lec 25
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
prompt Repaso 12-may-2026 + 15-may-2026
prompt ============================================
prompt ...
prompt ...

-- inicializar el usuario bases1
-- Lec09-hr-y-mascotas2.sql
PROMPT ====Borrado de Objetos
drop table personas cascade constraint;
drop table personas_log cascade constraint;
drop table parametros cascade constraint;
drop sequence sec_personas;

PROMPT ==== Creamos la secuencia
create sequence sec_personas;

PROMPT === Tabla párametros
create table parametros(
id        number,
nombre    varchar2(20),
valor     varchar2(20));

PROMPT ==== Tabla personas
create table personas (
id        number,
nombre    varchar2(20),
genero    varchar2(1),
salario   number default 1000,
id_padre  number,
id_madre  number);

--TABLA BITACORA tabla personas_log
PROMPT ==== Tabla personas_log
create table personas_log (
fecha_log   date,
accion_log  varchar2(1),
usuario_log varchar2(30),
id          number,
nombre      varchar2(20),
genero      varchar2(1),
salario     number default 1000,
id_padre    number,
id_madre    number);


PROMPT ==== Restricciones
alter table personas add constraint personas_pk primary key (id);



alter table parametros add constraint parametros_pk primary key (id);

alter table personas add constraint personas_fk_madre
foreign key (id_madre) references personas;

alter table personas add constraint personas_fk_padre
foreign key (id_padre) references personas;

alter table personas add constraint personas_ck_genero
check (genero in ('M','F','N','T','O') );

PROMPT =====insertar algunos parametros
--'S' 'N' son los valores posibles 
insert into parametros(id, nombre, valor) values (1,'Permite Ins Persona','S');
commit;



--BASE TRIGGERS //  con funciones
PROMPT =====fun_param_valor
create or replace function fun_param_valor(PId in number) 
return varchar2 is
  VValor varchar2(20);
begin
  select valor
  into   VValor
  from   parametros
  where  id = PId;
  return VValor;
exception
when no_data_found then
  return null;
end fun_param_valor;
/
show error
--DEBUG 
--host sleep 3


PROMPT =====Prc_ins_persona
create or replace procedure prc_ins_persona
( Pnombre in varchar2, Pgenero in varchar2,
Pid_padre in number, Pid_madre in number) is
--VARIABLES
--CURSORES
--VPermitir varchar2(20) := 'N';
begin
  --  NO ES HARDCODING!!!
 --NOTA: Queda Definido Param 1 = Permitir insertar Personas S/N
  if fun_param_valor(1) = 'S' then
  --ESTO SI ES HARDCODING
  --if VPermitir = 'S' then
    insert into personas (id, nombre, genero,
    id_padre, id_madre) values (sec_personas.nextval,
    Pnombre, Pgenero, Pid_padre, Pid_madre
    );
    commit;
	--Recomendable, Genere Error
  --else
    --TAREA MORAL REVISAR *** 
    --raise_application_error(-20001,'No se permite insertar personas');
  end if;
exception
  when others then
    dbms_output.put_line('Hay un error '||sqlerrm);
end prc_ins_persona;
/
show error
--sqlerrm  es la variable de entorno
--que contiene el texto completo del mensaje de error
--que se generó al ejecutar un PRC, FUN, TRG

PROMPT ====Insertamos unas personas
execute prc_ins_persona('Juan','M',null,null);
execute prc_ins_persona('Ana','F',null,null);
execute prc_ins_persona('Sonia','F',1,2);
execute prc_ins_persona('Hugo','M',1,2);
execute prc_ins_persona('Pedro','M',null,null);
execute prc_ins_persona('June','F',4,3);
execute prc_ins_persona('Mars','F',4,3);
execute prc_ins_persona('Venus','F',4,3);
execute prc_ins_persona('Aries','F',4,3);
select * from personas;


--- 01.42PM...
--   15.22
PROMPT ===Funcion cuenta la cantidad de hermanos
create or replace function fun_cant_hermanos(Pid in number)
return number is
 VIdPad   number;
 VIdMad   number;
 VCantHer number;
begin
  select id_padre, id_madre into   VIdPad, VIdMad
  from   personas  where  id = Pid;
  select count(*) into   VCantHer
  from  personas  where id_madre = VIdMad 
  and id_padre = VIdPad and id <>Pid;
  return VCantHer;
end fun_cant_hermanos;
/
show error
select fun_cant_hermanos(1) dato from dual;

PROMPT ===Vista con inner join.. x3
create or replace view rep_padres_y_madres as
select ps.nombre nom_persona ,
 upper(pd.nombre) nom_padre,
 upper(md.nombre) nom_madre, fun_cant_hermanos(ps.id) cant_hermanos
from   personas ps, personas pd, personas md
where  ps.id_padre = pd.id
and    ps.id_madre = md.id
union
select nombre , 'Sin Padre', 'Sin Madre', 0
from   personas
where  id_madre is null and id_padre is null;

select * from rep_padres_y_madres;

PROMPT ===================UPDATE
update personas set nombre = lower(nombre);
select * from personas;
rollback;
select * from personas;

PROMPT ===================DELETE
delete from personas;
select * from personas;
rollback;
select * from personas;

PROMPT ===================Funcion de clasificacion de tamaño de nombre
--Convertir  PRACT No 2// No ocupa BD
create or replace function fun_clasifica_nombre(PValor in varchar2)
return varchar2 is
 --nombre    varchar2(20),
 --tamaño de PValor
  VTam number;
begin 
  --validacion de control.
  if PValor is null then
    return 'Nombre no puede ser nulo';
  end if;
  VTam := length(PValor);
  if VTam <= 3 then
    return ('Nombre muy corto');
  elsif VTam <= 5 then
    return ('Nombre corto');
  elsif VTam <= 8 then
    return ('Nombre mediano');
  elsif VTam <= 12 then
    return ('Nombre largo');
  else
    return ('Nombre muy largo');
  end if;
  --return 'cero';
end fun_clasifica_nombre;
/ 
show error
--host sleep 2
--NULL o '' --EL RESULTADO ES NULL o sea no existe el tamaño 0
--format dato column A10
select fun_clasifica_nombre(null) dato from dual;
select fun_clasifica_nombre('Ana') dato from dual;
select fun_clasifica_nombre('Pedro') dato from dual;
select fun_clasifica_nombre('Manrique') dato from dual;
select fun_clasifica_nombre('Jose Pablo') dato from dual;
select fun_clasifica_nombre('Jose Rodrigo de Jesus') dato from dual;

--
--select * from parametros;
PROMPT ====3pm *** 15-05-2026 *************
PROMPT ****************************************
PROMPT ****************************************
select * from personas order by 2;

--Valor num 3, en un campo de texto

-- ???
insert into parametros(id, nombre, valor) values 
(2,'Limite de prueba','5');
commit;

create or replace procedure prc_ciclo is
 VPosicion number;
 VPosAct   number:=1;
 cursor Cur_Personas is
 select id, nombre  from personas order by 2;
begin
  -- CAST  convierte de TEXTO a numero '3' ok  'N' -- ERROR
  VPosicion := nvl(fun_param_valor(2),1);
  -- CAST convierte ve NUMERO a texto
  for y in Cur_Personas loop
    if VPosicion = VPosAct then
       dbms_output.put_line('Nombre de la persona en la posicion '||VPosicion||' es '||y.nombre);
    end if;
    VPosAct := VPosAct+1;
  end loop;
  --dbms_output.put_line('Luego del FOR El valor es '||VPosicion);
end prc_ciclo;
/
show error
--host sleep 3
execute prc_ciclo;


PROMPT ====****************************************************************************
PROMPT ====****************************************************************************


create or replace function fun_invierte_may_min(p_texto in varchar2) return varchar2 is
begin
  if p_texto is null then
    return null;
  end if;
  -- Si todo viene en MAYUSCULA, lo pasa a minuscula
  if p_texto = upper(p_texto) then
    return lower(p_texto);
  -- Si todo viene en minuscula, lo pasa a MAYUSCULA
  elsif p_texto = lower(p_texto) then
    return upper(p_texto);
  -- Si viene mezclado, lo deja igual
  else
    return p_texto;
  end if;
end fun_invierte_may_min;
/
show error

PROMPT ====****************************************************************************
PROMPT ====****************************************************************************

PROMPT ==== Trigger personas_trg_bur
PROMPT ==== B = BEFORE, U = UPDATE, R = ROW
PROMPT ==== Sustitucion: convierte nombre a MAYUSCULA antes de actualizar

--significa que es un trigger before update
create or replace trigger personas_trg_bur
before update of nombre on personas
for each row
begin
  -- :NEW.nombre representa el nuevo valor que se intenta guardar
  -- Si viene en minuscula, lo sustituimos por mayuscula
  :NEW.nombre := upper(:NEW.nombre);
end personas_trg_bur;
/
PROMPT ==== Antes del UPDATE
select * from personas order by id;

PROMPT ==== DESACTIVAR TRIGGER
--alter trigger personas_trg_bur disable;
drop trigger personas_trg_bur;

PROMPT ==== Intentamos poner todos los nombres en minuscula
update personas
set nombre = lower(nombre);
rollback;

PROMPT ==== ACTIVAR TRIGGER
--alter trigger personas_trg_bur enable;


PROMPT ==== El trigger sustituye el valor y lo guarda en MAYUSCULA
select * from personas order by id;



PROMPT ==== Luego del rollback
select * from personas order by id;

PROMPT =====Prc_upd_persona
create or replace procedure prc_upd_persona
(Pid in number, Pnombre in varchar2) is
begin
  update personas
  set    nombre = Pnombre
  where id = Pid;
  commit;
end prc_upd_persona;
/
show error

-- "before update of nombre on personas"  
  -- update de ese campo "NOMBRE"
-- "before update on personas" 
-- QUITAR "of nombre"
-- para cualquier campo que
-- actualice
PROMPT reemplazamos trigger personas_trg_bur
create or replace trigger personas_trg_bur
before update on personas
for each row
declare
  VPorcentaje number;
begin
  if nvl(fun_param_valor(3),'N') <> 'S' then
    raise_application_error(-20001,'No es permitido actualizar la tabla personas');
  end if;
  begin
    VPorcentaje := nvl(fun_param_valor(4),1.2);
  exception
  when others then
    VPorcentaje:= 1.2;
  end;
  if :new.salario > :old.salario*VPorcentaje then
    raise_application_error(-20001,'No es permitido aumentar el salario en mas de un '||VPorcentaje);
  end if;
end personas_trg_bur;
/

-- :NEW -> REFERENCIA A NUEVOS VALORES (INSERT O UPDATE)
-- :OLD -> REFERENCIA A LOS VALORES ANTERIORES (UPDATE O DELETE)




insert into parametros (id, nombre, valor)
values (3,'Permite Upd Persona','S');
--- 1.1 COMO TEXTO o  ABC
insert into parametros (id, nombre, valor)
values (4,'Porc. Aum. Máximo','ABC');

commit;
--update personas set nombre = 'PRUEBA' where id = 1;
update personas set salario = salario+100 where id = 1;
-- update personas set salario = salario+90 where id = 1;
-- update personas set salario = salario+90 where id = 1;
-- update personas set salario = salario+90 where id = 1;
-- update personas set salario = salario+90 where id = 1;
-- update personas set salario = salario+90 where id = 1;
commit;
select * from personas;


PROMPT ================================================ BITACORA ================================================


PROMPT == TRIGGER_LOG personas_trg_aur

insert into parametros (id, nombre, valor)
values (5,'Acti Bit Ins Per','S');

insert into parametros (id, nombre, valor)
values (6,'Acti Bit Ins Upd','S');

insert into parametros (id, nombre, valor)
values (7,'Acti Bit Ins del','S');


--USER ES PARA SABER QUIEN FUE EL USUARIO LO HIZO
--ACTUALIZAR
create or replace trigger personas_trg_aur
after update on personas
for each row
begin
  if nvl(fun_param_valor(6),'S') = 'S' then
      insert into personas_log values
      (sysdate,'U',user,
      :old.id,
      :old.nombre,
      :old.genero,
      :old.salario,
      :old.id_padre,
      :old.id_madre
      );
  end if;
end; 
/
show error

--USER ES PARA SABER QUIEN FUE EL USUARIO LO HIZO
--ELIMINAR
create or replace trigger personas_trg_adr
after delete on personas
for each row
begin
  if nvl(fun_param_valor(7),'S') = 'S' then
    insert into personas_log values
    (sysdate,'D',user,
    :old.id,
    :old.nombre,
    :old.genero,
    :old.salario,
    :old.id_padre,
    :old.id_madre
    );
  end if;
end; 
/
show error


--USER ES PARA SABER QUIEN FUE EL USUARIO LO HIZO
--NVL(buscar uso)
--INSERT
create or replace trigger personas_trg_air
after insert on personas
for each row
begin
  if nvl(fun_param_valor(5),'S') = 'S' then
    insert into personas_log values
    (sysdate,'I',user,
    :new.id,
    :new.nombre,
    :new.genero,
    :new.salario,
    :new.id_padre,
    :new.id_madre
    );
  end if;
end; 
/
show error

update personas set nombre = nombre || '-' where id in (1,2,3);
commit;
select * from personas_log;
select * from personas order by 1;

--MISMA BITACORA PARA INSERT
insert into personas (id,nombre,genero,salario,id_padre,id_madre) 
values (10,'NOSE','M',1000,1,2);

select * from personas;
delete from personas where id = 10;


select * from personas_log;
select * from personas order by 1;
select * from parametros;




PROMPT ====fin===========

EXIT







