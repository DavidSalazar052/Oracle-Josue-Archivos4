SET FEEDBACK ON 
SET PAGESIZE 100
SET LINESIZE 150
SET TRIMSPOOL ON

SPOOL &1..log
PROMPT =======================================
PROMPT SOLUCION PRACT 01 / 1pm

--OJO NO DROPEAR USUARIO PORQUE VAMOS A CREAR VISTAS!!!

drop user bases1 cascade;
create user bases1 identified by bases123;
grant dba to bases1;

PROMPT ====Conectar con bases1===========
conn bases1/bases123@FREEPDB1

PROMPT INICIO ESTO ES LO QUE DEBEN DESARROLLAR EN PAPEL
create table comentarios(
id         number,
fecha      date,
id_padre   number,
usuario    varchar2(10),
comentario varchar2(100));

alter table comentarios add constraint comentarios_pk primary key (id);

alter table comentarios add constraint comentarios_fk_padre foreign key (id_padre) references comentarios;

insert into comentarios(id, fecha, id_padre, usuario, comentario) values (1,sysdate+2,null,'juan','Que opinan de la IA');
insert into comentarios(id, fecha, id_padre, usuario, comentario) values (2,sysdate+2,1,'pedro','es buena');
insert into comentarios(id, fecha, id_padre, usuario, comentario) values (3,sysdate+2,2,'ana','no creo que sea tan buena');
insert into comentarios(id, fecha, id_padre, usuario, comentario) values (4,sysdate+2,1,'sonia','no opino');
insert into comentarios(id, fecha, id_padre, usuario, comentario) values (5,sysdate+2,3,'rosa','no buena ni mala');
insert into comentarios(id, fecha, id_padre, usuario, comentario) values (6,sysdate+2,null,'juan','comente sobre El Quijote');
commit;
column id         format 99999999
column id_padre   format 99999999
column id_hijo    format 99999999
column usuario    format A10
column comentario format A30
column com_padre  format A30
column com_hijo   format A30

select * from comentarios;

create or replace view rep_comentarios as
select p.comentario com_padre, h.comentario com_hijo, h.id id_hijo
from   comentarios p, comentarios h
where  h.id_padre = p.id
order by 3 desc;

select * from rep_comentarios;
PROMPT FIN ESTO ES LO QUE DEBEN DESARROLLAR EN PAPEL

PROMPT ====fin===========

SPOOL OFF
EXIT
