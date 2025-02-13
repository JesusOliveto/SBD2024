-- Dadas las siguientes tablas:

create table categorias
(
 cod_categoria		varchar(3) 		not null primary key,
 nom_categoria		varchar(30)		not null unique,
 precio				decimal(6,2)	not null check (precio > 0),
 cant_dias_alq		tinyint			not null check (cant_dias_alq > 0) default 1
)
go

insert into categorias
values ('A', 'CATEGORIA A', 5.00, 1)
insert into categorias
values ('B', 'CATEGORIA B', 4.00, 2)
insert into categorias
values ('C', 'CATEGORIA C', 3.00, 3)
insert into categorias
values ('D', 'CATEGORIA D', 2.00, 4)
go

create table nacionalidades
(
 nacionalidad		varchar(30)	not null primary key
)
go

insert into nacionalidades
values ('ARGENTINA')
insert into nacionalidades
values ('ESPAÑOLA')
insert into nacionalidades
values ('ITALIANA')
go

create table peliculas
(
 nro_pelicula		integer			not null primary key,
 titulo				varchar(100)	not null,
 nacionalidad		varchar(30)		not null references nacionalidades,
 cod_categoria		varchar(3)		not null references categorias,
 resumen			varchar(4000)	null
)
go

insert into peliculas
values (1, 'PELICULA 1', 'ARGENTINA', 'A', NULL)
insert into peliculas
values (2, 'PELICULA 2', 'ARGENTINA', 'A', NULL)
insert into peliculas
values (3, 'PELICULA 3', 'ESPAÑOLA', 'B', NULL)
insert into peliculas
values (4, 'PELICULA 4', 'ITALIANA', 'B', NULL)
insert into peliculas
values (5, 'PELICULA 5', 'ITALIANA', 'C', NULL)
go

create table medios
(
 cod_medio		varchar(3)	not null primary key,
 nom_medio		varchar(30)	not null unique
)
go

insert into medios
values ('DVD', 'DVD')
insert into medios
values ('VHS', 'VHS')
go

create table copias
(
 nro_pelicula	integer		not null references peliculas,
 nro_copia		smallint	not null,
 estado			char(1)		not null check (estado in ('B','M','R')) default 'B',
 cod_medio		varchar(3)	not null references medios,
 primary key (nro_pelicula, nro_copia)
)
go

insert into copias
values (1, 1, 'B', 'DVD')
insert into copias
values (1, 2, 'B', 'DVD')
insert into copias
values (2, 1, 'B', 'VHS')
insert into copias
values (2, 2, 'B', 'DVD')
insert into copias
values (2, 3, 'B', 'DVD')
insert into copias
values (3, 1, 'R', 'VHS')
insert into copias
values (4, 1, 'R', 'VHS')
insert into copias
values (5, 1, 'R', 'VHS')
go

create table socios
(
 nro_socio		integer			not null primary key,
 apellido		varchar(40)		not null,
 nombre			varchar(40)		not null,
 tipo_documento	varchar(3)		not null,
 nro_documento	integer			not null,
 direccion		varchar(100)	not null,
 telefonos		varchar(100)	not null,
 unique (tipo_documento, nro_documento)
)
go

insert into socios
values (1, 'APELLIDO SOCIO 1', 'NOMBRE SOCIO 1', 'DNI', 12345678, 'A','1')
insert into socios
values (2, 'APELLIDO SOCIO 2', 'NOMBRE SOCIO 2', 'DNI', 23456789, 'A','1')
insert into socios
values (3, 'APELLIDO SOCIO 3', 'NOMBRE SOCIO 3', 'DNI', 34567890, 'A','1')
insert into socios
values (4, 'APELLIDO SOCIO 4', 'NOMBRE SOCIO 4', 'DNI', 45678901, 'A','1')
insert into socios
values (5, 'APELLIDO SOCIO 5', 'NOMBRE SOCIO 5', 'DNI', 56789012, 'A','1')
go


create table abonos
(
 nro_abono		integer			not null primary key,
 nro_socio		integer			not null references socios,
 fecha_compra	smalldatetime	not null,
 importe		decimal(6,2)	not null,
 fecha_vto		smalldatetime	not null
)
go

insert into abonos
values (1, 1, '01 mar 2007 0:00', 10.00, '25 may 2007 0:00')
insert into abonos
values (2, 1, '01 jun 2007 0:00', 10.00, '30 sep 2007 0:00')
insert into abonos
values (3, 2, '01 may 2007 0:00', 12.00, '31 jul 2007 0:00')
insert into abonos
values (4, 2, '01 jul 2007 0:00', 12.00, '31 oct 2007 0:00')
insert into abonos
values (5, 3, '01 mar 2007 0:00', 13.00, '25 dec 2007 0:00')
insert into abonos
values (6, 4, '01 mar 2007 0:00', 14.00, '31 dec 2007 0:00')
go

create table detalle_abonos
(
 nro_abono		integer		not null references abonos,
 cod_categoria	varchar(3)	not null references categorias,
 cant_copias	tinyint		not null check (cant_copias > 0),
 primary key (nro_abono, cod_categoria)
)
go

insert into detalle_abonos
values (1, 'A', 10)
insert into detalle_abonos
values (1, 'B', 5)
insert into detalle_abonos
values (2, 'A', 20)
insert into detalle_abonos
values (2, 'C', 10)
insert into detalle_abonos
values (3, 'A', 30)
insert into detalle_abonos
values (3, 'B', 15)
insert into detalle_abonos
values (4, 'B', 40)
insert into detalle_abonos
values (4, 'C', 20)
insert into detalle_abonos
values (5, 'B', 50)
insert into detalle_abonos
values (5, 'C', 25)
insert into detalle_abonos
values (6, 'C', 60)
go

create table alquileres
(
 nro_alquiler	integer			not null primary key,
 nro_socio		integer			not null references socios,
 fecha_alquiler	smalldatetime	not null,
 nro_pelicula	integer			not null,
 nro_copia		smallint		not null,
 nro_abono		integer			not null,
 cod_categoria	varchar(3)		not null,
 fecha_a_dev	smalldatetime	not null,
 fecha_dev		smalldatetime	null,
 foreign key (nro_pelicula, nro_copia)  references copias,
 foreign key (nro_abono, cod_categoria) references detalle_abonos
)
go

insert into alquileres
values (1, 1, '01 may 2007 0:00', 1, 1, 1, 'A', '02 may 2007 0:00', null)
insert into alquileres
values (2, 1, '01 jun 2007 0:00', 1, 1, 1, 'A', '02 jun 2007 0:00', null)
insert into alquileres
values (3, 1, '01 jul 2007 0:00', 1, 1, 2, 'A', '02 jul 2007 0:00', null)
insert into alquileres
values (4, 1, '01 jul 2007 0:00', 1, 1, 2, 'C', '02 jul 2007 0:00', null)
insert into alquileres
values (5, 2, '01 may 2007 0:00', 1, 1, 3, 'A', '02 may 2007 0:00', null)
insert into alquileres
values (6, 2, '01 may 2007 0:00', 1, 1, 3, 'A', '02 may 2007 0:00', null)
insert into alquileres
values (7, 3, '01 may 2007 0:00', 1, 1, 5, 'B', '02 may 2007 0:00', null)
insert into alquileres
values (8, 3, '01 may 2007 0:00', 1, 1, 5, 'C', '02 may 2007 0:00', null)
insert into alquileres
values (9, 3, '01 may 2007 0:00', 1, 1, 5, 'C', '02 may 2007 0:00', null)
insert into alquileres
values (10, 3, '01 may 2007 0:00', 1, 1, 5, 'C', '02 may 2007 0:00', null)
go

/* CONSIGNA:

Programar un procedimiento almacenado que reciba como argumento el año y devuelva una estadística de 
   alquileres por categoría:

   Cód.	Categoría						Cant. Alq.	Porcentaje
   -----------------------------------------------------------
   xxx	xxxxxxxxxxxxxxxxxxxxxxxxxxxxx      xxxx		  xx.xx %		
   xxx	xxxxxxxxxxxxxxxxxxxxxxxxxxxxx      xxxx		  xx.xx %		
   xxx	xxxxxxxxxxxxxxxxxxxxxxxxxxxxx      xxxx		  xx.xx %		
   xxx	xxxxxxxxxxxxxxxxxxxxxxxxxxxxx      xxxx		  xx.xx %		
   xxx	xxxxxxxxxxxxxxxxxxxxxxxxxxxxx      xxxx		  xx.xx %		
   xxx	xxxxxxxxxxxxxxxxxxxxxxxxxxxxx      xxxx		  xx.xx %		

   donde la cantidad es la cantidad de copias alquiladas de películas de la categoría.
   La lista debe aparecer ordenada por porcentaje descendente y debe incluir a todas las categorías 
   inclusive las que no tienen copias alquiladas. 

   NOTA: La suma de los porcentajes es 100%

*/