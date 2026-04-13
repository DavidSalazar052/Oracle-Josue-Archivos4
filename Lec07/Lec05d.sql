-- Este es un ejemplo de relacion ciclica 1:N 
-- Tenemos la clase herramienta la cual posee un id_cat_pad el cual hace referencia a otra herramienta
-- pero ademas de eso tenemos la clase producto que puede contener una herramienta 

SET FEEDBACK ON
SET PAGESIZE 50
SET LINESIZE 150
SPOOL &1..log
PROMPT =======================================
Prompt Ejemplo de FK reflexivo sobre la misma tabla.

--VERSION C



drop user bases1 cascade;

--select count(*) cant from dba_users where username='BASES1';

create user bases1 identified by bases123;
--select count(*) cant from dba_users where username='BASES1';
grant dba to bases1;

PROMPT ====inicio===========
conn bases1/bases123@FREEPDB1

--Creamos la Tabla de Herramientas 
create table herramientas(
id      number,
nombre  varchar2(30) not null,
id_cat_pad number);

--Cremoa la tabla Producto 
create table productos (
id      number,
nombre  varchar2(50),
precio  number not null,
id_cat number,
estado  varchar2(10),
fec_ult_compra  date,
inventario number
);

--PK y FK
alter table herramientas add constraint herramientas_pk primary key(id);
alter table herramientas add constraint herramientas_fk foreign key(id_cat_pad) references herramientas;

alter table productos add constraint productos_pk primary key(id);
alter table productos add constraint pro_fk_herramienta FOREIGN KEY (id_cat) REFERENCES herramientas;

--Registros
insert into herramientas(id,nombre,id_cat_pad) values (1,'Herramientas Electricas',null);
insert into herramientas(id,nombre,id_cat_pad) values (2,'Herramientas Manuales',null);
insert into herramientas(id,nombre,id_cat_pad) values (3,'Taladros',1);
insert into herramientas(id,nombre,id_cat_pad) values (4,'De baterias',3);
insert into herramientas(id,nombre,id_cat_pad) values (5,'Destornilladores',2);
insert into herramientas(id,nombre,id_cat_pad) values (6,'Planos',5);
insert into herramientas(id,nombre,id_cat_pad) values (7,'Phillips',5);
insert into herramientas(id,nombre,id_cat_pad) values (8,'Llantas',null);
insert into herramientas(id,nombre,id_cat_pad) values (9,'Llantas para moto',8);
insert into herramientas(id,nombre,id_cat_pad) values (10,'Llantas para automovil',8);
insert into herramientas(id,nombre,id_cat_pad) values (102,'Rep. Autos Electricos',null);
commit;


insert into productos(id,nombre,precio,id_cat,estado,fec_ult_compra,inventario) 
values (100,'Destorn. Phillips LOS PATITOS',1000,7,'Activ',null,0);
insert into productos(id,nombre,precio,id_cat,estado,fec_ult_compra,inventario) 
values (101,'Destorn. Phillips SUPERIOR',1500,7,'Activ',null,0);
insert into productos(id,nombre,precio,id_cat,estado,fec_ult_compra,inventario) 
values (102,'Taladro de Baterias SUPERIOR',34500,4,'Desco',null,0);
insert into productos(id,nombre,precio,id_cat,estado,fec_ult_compra,inventario) 
values (103,'Taladro Industrial LOS PATITOS',78000,3,'Desco',null,0);
insert into productos(id,nombre,precio,id_cat,estado,fec_ult_compra,inventario) 
values (104,'Cobro de Flete GAM',5000,null,'Activ',null,0);



PROMPT actualizar fecha 
update productos set fec_ult_compra = sysdate;


create or replace view rep_herramienta as 
select h.id, h.nombre nom_her ,p.nombre nom_pro
from herramientas h, productos p
where p.id = h.id;

select * from rep_herramienta;


PROMPT ====inicio===========
conn bases1/bases123@FREEPDB1


PROMPT ====fin===========
SPOOL OFF
EXIT



