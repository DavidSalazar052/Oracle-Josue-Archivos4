SET FEEDBACK ON
SET PAGESIZE 50
SET LINESIZE 150

SPOOL &1..log
PROMPT =======================================
PROMPT Tarea 02

drop user bases1 cascade;
create user bases1 identified by bases123;
grant dba to bases1;

PROMPT ====Conectar con bases| ===========
conn bases1/bases123@FREEPDB1

PROMPT ======== Crear Tablas ====
create table tipos(
id number,
nombre varchar2(20),
fec_crea date);

create table codigos(
id number,
id_tipo number,
despliegue varchar2(20),
tip_valor varchar2(3),
valor varchar(20),
fec_crea date);

PROMPT ======== PKs ====
alter table tipos add constraint tipos_pk primary key (id);
alter table codigos add constraint codigos_pk primary key (id);

PROMPT ======== FKs ====
alter table codigos add constraint codigos_fk_tipos foreign key (id_tipo) references tipos;

PROMPT ======== CKs ====
alter table codigos add constraint codigo_ck_tipo_valor check (tip_valor in ('Num','TxT'));

PROMPT ======== Secs ====
create sequence sec_tipos;
create sequence sec_codigo start with 1001;


PROMPT ======== Inserts tipos ====
insert into tipos(id,nombre,fec_crea) values (sec_tipos.nextval,'Provincias',sysdate);
insert into tipos(id,nombre,fec_crea) values (sec_tipos.nextval,'Estados para Activos',sysdate);
insert into tipos(id,nombre,fec_crea) values (sec_tipos.nextval,'Estado Civil',sysdate);
insert into tipos(id,nombre,fec_crea) values (sec_tipos.nextval,'Cond. Clima',sysdate);

PROMPT ======== Inserts codigos ====
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 1, 'San Jose','Num','1',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 1, 'Alajuela','Num','2',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 1, 'Cartago','Num','3',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 1, 'Heredia','Num','4',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 1, 'Guanacaste','Num','5',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 1, 'Puntarenas','Num','6',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 1, 'Limon','Num','7',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 2, 'En Uso','TxT','En Uso',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 2, 'Desechado','TxT','Desechado',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 2, 'Disponible','TxT','Disponible',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 3, 'Soltero','Num','10',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 3, 'Casado','Num','11',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 3, 'Viudo','Num','12',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 3, 'Divorciado','Num','13',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 4, 'Caliente','TxT','Caliente',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 4, 'Tormenta','TxT','Tormenta',sysdate);
insert into codigos(id,id_tipo,despliegue,tip_valor,valor,fec_crea) values (sec_codigo.nextval, 4, 'Llovizna','TxT','Llovizna',sysdate);


PROMPT ======== Tablas Normales ====
select * from tipos;
select * from codigos;

--CUANDO USAMOS INNER JOIN USAMOS ALIAS DE TABLAS Y COLUMNAS
--Simplemente son : codigos c, tipos t

PROMPT ======== Provincias ====
create or replace view rep_provincias as
select t.nombre, c.despliegue,c.valor
from   codigos c, tipos t
where  c.id_tipo = 1
And c.id_tipo =  t.id;

select * from rep_provincias;

PROMPT ======== Estados para Activos ====
create or replace view rep_estados_activos as
select id,id_tipo,despliegue,tip_valor,valor,fec_crea
from   codigos
where  id_tipo = 2;
select * from rep_estados_activos;

PROMPT ======== Estado Civil ====
create or replace view rep_estado_civil as
select t.nombre,upper(c.despliegue ) as nom_Estado_Civil ,c.valor as valor_Estado_Civil
from   codigos c
inner join tipos t
on c.id_tipo = t.id
where  id_tipo = 3
--AND c.id_tipo = t.id;
select * from rep_estado_civil order by nom_Estado_Civil desc;

PROMPT ======== Clima ====
create or replace view rep_cod_de_clima as
select t.nombre,c.despliegue as nom_clima ,c.valor as valor_clima
from   codigos c, tipos t
where  c.id_tipo = 4
AND c.id_tipo = t.id;

select * from rep_cod_de_clima;


PROMPT Tarea 02
PROMPT ====fin===========

SPOOL OFF
EXIT
