
SET FEEDBACK ON
SET PAGESIZE 50
SET LINESIZE 150
SPOOL &1..log
PROMPT =======================================
PROMPT TAREA 2 DE BASES DE DATOS 
PROMPT ESTUDIANTE: JOSUE DAVID SANCHEZ SALAZAR
PROMPT CEDULA : 118840506

drop user bases1 cascade;
create user bases1 identified by bases123;
grant dba to bases1;

PROMPT ====inicio===========
conn bases1/bases123@FREEPDB1

PROMPT CREACIÓN DE TABLA 
--Creación de tabla de tipos
create table tipo(
    id number,
    nombre VARCHAR2(30),
    fec_crea date
);

-- Creación de tabla de Códigos
create table codigo(
    id number,
    id_tipo number not null,
    despliegue VARCHAR2(30),
    tip_valor VARCHAR2(30),
    valor VARCHAR2(20),
    fec_crea date
);

PROMPT DESIGNACIÓN DE PK-FK-CK
-- Creación de PK
alter table tipo add constraint tipo_PK primary key (id);
alter table codigo add constraint codigo_PK primary key(id);

-- Creación de FK
alter table codigo add constraint codigo_FK foreign key (id_tipo) references tipo;

-- Creación de CK en 
alter table codigo add constraint codigo_tip_valor_CK check (tip_valor in ('Num','Txt'));


PROMPT DESIGNACIÓN DE SECUENCIAS
-- Creamos la secuencia 
create sequence sec_tipo start with 1;
create sequence sec_codigo start with 1001;
create sequence sec_codigo_valor start with 1;

PROMPT INSECCIONES
--Insercciones en tabla Tipo
insert into tipo (id,nombre) values (sec_tipo.nextval,'Provincia');
insert into tipo (id,nombre) values (sec_tipo.nextval,'Estados para Activos');
insert into tipo (id,nombre) values (sec_tipo.nextval,'Estado Civil');
insert into tipo (id,nombre) values (sec_tipo.nextval,'Equipo de Futbol');
insert into tipo (id,nombre) values (sec_tipo.nextval,'Universidad');

commit;

--Insercciones en la tabla Código
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,1,'San Jose','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,1,'Alajuela','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,1,'Cartago','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,1,'Heredia','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,1,'Guanacaste','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,1,'Puntarenas','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,1,'Limon','Num',sec_codigo_valor.nextval);

insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,2,'En uso','Txt',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,2,'Desechado','Txt',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,2,'Disponible','Txt',sec_codigo_valor.nextval);

insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,3,'Soltero','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,3,'Casado','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,3,'Viudo','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,3,'Divorciado','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,3,'Union de Hecho','Num',sec_codigo_valor.nextval);

insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,4,'CS Herediano','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,4,'Deportivo Saprissa ','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,4,'Liga Deportiva Alajuelense','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,4,'Club Sport Cartagines','Num',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,4,'Sporting Football Club','Num',sec_codigo_valor.nextval);

insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,5,'UCR','Txt',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,5,'UNA','Txt',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,5,'TEC','Txt',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,5,'UNED','Txt',sec_codigo_valor.nextval);
insert into codigo(id,id_tipo,despliegue,tip_valor,valor) values (sec_codigo.nextval,5,'UTN','Txt',sec_codigo_valor.nextval);



commit;

PROMPT UPDATES DE TABLA CODIGO
update en la parte de Txt tipo 2
update codigo set valor ='En uso' where despliegue ='En uso';
update codigo set valor ='Desechado' where despliegue ='Desechado';
update codigo set valor ='Disponible' where despliegue ='Disponible';

update en la parte de Txt tipo 5
update codigo set valor ='UCR' where despliegue ='UCR';
update codigo set valor ='UNA' where despliegue ='UNA';
update codigo set valor ='TEC' where despliegue ='TEC';
update codigo set valor ='UNED' where despliegue ='UNED';
update codigo set valor ='UTN' where despliegue ='UTN';



--Update de sysdate
update tipo set fec_crea = sysdate;
update codigo set fec_crea = sysdate;
commit;

--Consultar tabla de tipo
select * from tipo;
--Consultar tabla de codigo
select * from codigo;


--Consulta especifica de solo los tipos
--PROVINCIAS
PROMPT VISTAS
create or replace view rep_tipo_Provincia as 
select id,id_tipo,despliegue,tip_valor,valor,fec_crea
from codigo where id_tipo =1;

--ESTADO DE ACTIVOS 
create or replace view rep_tipo_Estado_Activo as 
select id,id_tipo,despliegue,tip_valor,valor,fec_crea
from codigo where id_tipo =2;

--ESTADO CIVIl
create or replace view rep_tipo_Estado_Civil as 
select id,id_tipo,despliegue,tip_valor,valor,fec_crea
from codigo where id_tipo =3;

--EQUIPO DE FUTBOL 
create or replace view rep_tipo_Equipo_de_Futbol as 
select id,id_tipo,despliegue,tip_valor,valor,fec_crea
from codigo where id_tipo =4;

--EQUIPO DE FUTBOL 
create or replace view rep_tipo_Universidad as 
select id,id_tipo,despliegue,tip_valor,valor,fec_crea
from codigo where id_tipo =5;

--Consulta de Vistas 

select * from rep_tipo_Provincia;
select * from rep_tipo_Estado_Activo;
select * from rep_tipo_Estado_Civil;
select * from rep_tipo_Equipo_de_Futbol;
select * from rep_tipo_Universidad;


PROMPT =======================================
PROMPT TAREA 2 DE BASES DE DATOS 
PROMPT ESTUDIANTE: JOSUE DAVID SANCHEZ SALAZAR
PROMPT CEDULA : 118840506


PROMPT ====fin===========
SPOOL OFF
EXIT



