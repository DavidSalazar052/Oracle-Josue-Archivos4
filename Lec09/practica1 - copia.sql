SET FEEDBACK ON
SET PAGESIZE 50
SET LINESIZE 250

SPOOL &1..log

drop user bases1 cascade;
create user bases1 identified by bases123;
grant dba to bases1;

conn bases1/bases123@FREEPDB1

create table personas(
    id number,
    nombre varchar2(50),
    id_supervisor number
);

create table categoria(
    id number,
    nombre varchar2(50)
);

create table pedidos(
    id number,
    producto varchar2(50),
    id_persona number,
    id_categoria number
);

--PK
alter table personas add constraint pk_personas primary key(id);
alter table categoria add constraint pk_categoria primary key(id);
alter table pedidos add constraint pk_pedidos primary key(id);

--FK para la ciclica
alter table personas add constraint personas_fk_supervisor foreign key(id_supervisor) references personas(id);
--FK 
alter table pedidos add constraint pedidos_fk_personas foreign key (id_persona) references personas(id);
alter table pedidos add constraint pedidos_fk_categoria foreign key (id_categoria) references categoria(id); 
alter table pedidos add registro date;

create sequence sec_personas start with 1;
create sequence sec_categoria start with 1;
create sequence sec_pedidos start with 1;

insert into personas(id,nombre,id_supervisor) values (sec_personas.nextval,'Maria',null);
insert into personas(id,nombre,id_supervisor) values (sec_personas.nextval,'Juan',1);
insert into personas(id,nombre,id_supervisor) values (sec_personas.nextval,'Ana',1);

insert into categoria(id,nombre) values (sec_categoria.nextval,'Tecnologia');
insert into categoria(id,nombre) values (sec_categoria.nextval,'Hogar');
insert into categoria(id,nombre) values (sec_categoria.nextval,'Cocina');

insert into pedidos(id,producto,id_persona,id_categoria) values (sec_pedidos.nextval,'Laptop',1,1);
insert into pedidos(id,producto,id_persona,id_categoria) values (sec_pedidos.nextval,'Silla',2,2);
insert into pedidos(id,producto,id_persona,id_categoria) values (sec_pedidos.nextval,'Cuchillo',3,2);

update pedidos set registro = sysdate;

select *from personas;
select *from categoria;
select *from pedidos;

create or replace view rep_supervisor_persona as
select s.nombre SUPERVISOR, p.nombre EMPLEADO
from personas s inner join personas p on p.id_supervisor = s.id;

--PEDIDOS
create or replace view rep_pedidos_categoria as
select pr.producto NOMBRE_PRODUCTO ,c.nombre NOMBRE_CATEGORIA
from pedidos pr inner join categoria c on pr.id_categoria = c.id; 


create or replace view rep_pedidos_persona as 
select pr.producto NOMBRE_PRODUCTO, p.nombre NOMBRE_EMPLEADO
from pedidos pr, personas p where pr.id_persona = p.id;


select * from rep_pedidos_categoria;
select * from rep_supervisor_persona;
select * from rep_pedidos_persona;

create or replace view rep_ped_cat_per as
select pe.producto Producto, ca.nombre Categoria, pr.nombre Empleado, s.nombre SUpervisor 
from pedidos pe
inner join categoria ca on pe.id_categoria = ca.id
inner join personas pr on pe.id_persona = pr.id
inner join personas s on pr.id_supervisor = s.id;
select * from rep_ped_cat_per;

SPOOL OFF
EXIT