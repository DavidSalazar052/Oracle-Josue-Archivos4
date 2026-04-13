SET FEEDBACK ON
SET PAGESIZE 50
SET LINESIZE 150

SPOOL &1..log

drop user bases1 cascade;
create user bases1 identified by bases123;
grant dba to bases1;

conn bases1/bases123@FREEPDB1

PROMPT ==Tablas==
create table personas(
id number,
nombre varchar2(30) not null,
genero varchar(1) not null,
id_padre number,
id_madre number,
email varchar2(30) not null,
telefono1 number not null,
telefono2 number);

PROMPT == PK ==
alter table personas add constraint personas_pk primary key (id);

PROMPT == FK ==
alter table personas add constraint personas_fk_padre foreign key (id_padre) references personas;
alter table personas add constraint personas_fk_madre foreign key (id_madre) references personas;

PROMPT == CK ==
alter table personas add constraint per_ck_genero check (genero in ('M','F','O'));

PROMPT == UK ==
alter table personas add constraint personas_uk_email unique (email);

PROMPT == SECUENCIAS ==
create sequence sec_personas start with 1000;

PROMPT == INSERT ==
insert into personas(id,nombre,genero,id_padre,id_madre,email,telefono1,telefono2) values (sec_personas.nextval, 'Juan Perez','M',null,null,'juan@gmail.com',11223344,null);
insert into personas(id,nombre,genero,id_padre,id_madre,email,telefono1,telefono2) values (sec_personas.nextval, 'Ana Gonzales','F',null,null,'ana@gmail.com',88774422,88220011);
insert into personas(id,nombre,genero,id_padre,id_madre,email,telefono1,telefono2) values (sec_personas.nextval, 'Sofia Rosales','F',null,null,'sofia@gmail.com',00663922,null);
insert into personas(id,nombre,genero,id_padre,id_madre,email,telefono1,telefono2) values (sec_personas.nextval, 'Ariel Perez Gonzales','O',1000,1001,'ariel@gmail.com',6535353,null);
insert into personas(id,nombre,genero,id_padre,id_madre,email,telefono1,telefono2) values (sec_personas.nextval, 'Hugo Perez Gonzales','M',1000,1001,'hugo@gmail.com',66753222,null);
insert into personas(id,nombre,genero,id_padre,id_madre,email,telefono1,telefono2) values (sec_personas.nextval, 'Sonia Perez Gonzales','F',1000,1002,'sonia@gmail.com',4789654,null);
insert into personas(id,nombre,genero,id_padre,id_madre,email,telefono1,telefono2) values (sec_personas.nextval, 'Jimena Ovares','F',null,null,'jimena@gmail.com',45265425,138471791);
insert into personas(id,nombre,genero,id_padre,id_madre,email,telefono1,telefono2) values (sec_personas.nextval, 'Pedro Perez Ovares','O',1004,1006,'pedro@gmail.com',3871951,null);

select * from personas;

update personas 
set telefono1 = 1111111
where nombre='Jimena Ovares';


update personas 
set telefono2 = 123456
where id in (1005,1003);

select * from personas;

delete from personas
where id=1007;

select * from personas;

PROMPT==Mostrar Tabla==
select * from personas;

PROMPT ==VISTAS==
PROMPT ==PADRES==
create or replace view rep_pers_padre as
select lower(h.nombre) nombreHijo, upper(p.nombre) nombrePadre
from personas h
inner join personas p
on h.id_padre = p.id;

select * from rep_pers_padre;

PROMPT ==MADRES==
create or replace view rep_pers_madre as
select lower(h.nombre) nombreHijo, upper(m.nombre) nombreMadre
from personas h
inner join personas m
on h.id_madre = m.id;

select * from rep_pers_madre;


SPOOL OFF
EXIT