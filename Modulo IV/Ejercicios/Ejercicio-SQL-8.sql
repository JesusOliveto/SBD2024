drop table mov_cajas_ahorros
drop table tipos_movimientos
drop table cajas_ahorros
drop table tipos_cuentas
drop table clientes
go

create table clientes
(
 nro_cliente		integer			not null,
 apellido			varchar(40)		not null,
 nombre				varchar(40)		not null,
 nro_documento		integer			not null
 primary key (nro_cliente),
 unique (nro_documento)
)
go

insert into clientes (nro_cliente, apellido, nombre, nro_documento)
values (1, 'APELLIDO 1', 'NOMBRE 1', 11111111),
       (2, 'APELLIDO 2', 'NOMBRE 2', 22222222),
       (3, 'APELLIDO 3', 'NOMBRE 3', 33333333)
go

create table tipos_cuentas
(
 cod_tipo_cuenta	varchar(3)		not null,
 desc_tipo_cuenta	varchar(30)		not null,
 cant_max_ext_mes	tinyint			not null,
 primary key (cod_tipo_cuenta)
)
go

insert into tipos_cuentas (cod_tipo_cuenta, desc_tipo_cuenta, cant_max_ext_mes)
values ('COM', 'Común',    3),
       ('ESP', 'Especial', 1)
go

create table cajas_ahorros
(
 nro_cliente		integer			not null, 
 nro_cuenta			integer			not null, 
 cod_tipo_cuenta	varchar(3)		not null,
 primary key (nro_cuenta),
 foreign key (nro_cliente) references clientes,
 foreign key (cod_tipo_cuenta) references tipos_cuentas
)
go

insert into cajas_ahorros (nro_cliente, nro_cuenta, cod_tipo_cuenta)
values (1, 1,'COM'),
       (2, 2,'ESP'),
       (3, 3,'COM'),
       (1, 4,'ESP'),
       (2, 5,'COM')
go

create table tipos_movimientos
(
 cod_tipo_movimiento	varchar(3)		not null,
 desc_tipo_movimiento	varchar(30)		not null,
 debito_credito			char(1)			not null,
 primary key (cod_tipo_movimiento),
 check (debito_credito in ('D','C'))
)
go

insert into tipos_movimientos (cod_tipo_movimiento, desc_tipo_movimiento, debito_credito)
values ('DEP', 'Depósito',                  'C'),
       ('EXT', 'Extracción',                'D'),
	   ('GTO', 'Gastos administrativos',    'D'),
	   ('ACI', 'Acreditación de intereses', 'C')
go

create table mov_cajas_ahorros
(
 nro_cuenta				integer			not null,
 fecha_movimiento		date			not null,
 cod_tipo_movimiento	varchar(3)		not null,
 nro_movimiento			integer			not null,
 importe_movimiento		decimal(9,2)	not null,
 primary key (cod_tipo_movimiento, nro_movimiento),
 foreign key (nro_cuenta) references cajas_ahorros,
 foreign key (cod_tipo_movimiento) references tipos_movimientos
)
go

insert into mov_cajas_ahorros (nro_cuenta, cod_tipo_movimiento, nro_movimiento, fecha_movimiento, importe_movimiento)
values (1, 'DEP', 1, '2018-03-01', 100.00),
       (1, 'EXT', 1, '2019-04-01', 100.00),
       (1, 'GTO', 1, '2019-05-10', 100.00),

       (2, 'DEP', 2, '2019-03-12', 100.00),

       (3, 'DEP', 3, '2020-04-11', 100.00),
       (3, 'ACI', 1, '2020-06-22', 100.00),

       (4, 'DEP', 4, '2017-07-15', 100.00),
       (4, 'EXT', 2, '2017-07-17', 100.00),
       (4, 'DEP', 6, '2017-09-15', 600.00),
       (4, 'ACI', 3, '2018-10-01', 250.00),
       (4, 'EXT', 3, '2019-10-12', 700.00),
       (4, 'GTO', 2, '2020-10-15', 100.00),
       (4, 'ACI', 4, '2020-10-22', 500.00),
       (4, 'DEP', 7, '2021-11-10', 500.00),
       (4, 'DEP', 8, '2021-11-20', 200.00),
       (4, 'EXT', 4, '2021-11-20', 1000.00),
       (4, 'GTO', 3, '2021-11-25', 200.00),
       (4, 'ACI', 5, '2021-11-30', 500.00),
       (4, 'DEP', 9, '2021-12-10', 200.00),
       (4, 'EXT', 5, '2021-12-12', 300.00),

       (5, 'DEP', 5, '2016-07-19', 100.00),
       (5, 'ACI', 2, '2016-08-01', 100.00)
go

insert into mov_cajas_ahorros (nro_cuenta, cod_tipo_movimiento, nro_movimiento, fecha_movimiento, importe_movimiento)
values (3, 'DEP', 10, '2020-03-01', 100.00)
go

/*
RESOLVER LOS SIGUIENTES EJERCICIOS:

   a. Ha surgido un nuevo requerimiento en el sistema de gestión de cajas de ahorros: Se requiere un cambio de modelo. 
      Las cajas de ahorros ahora pueden tener como titulares a más de un cliente y no solo uno como hasta el momento.
      Debe elaborar un script para cambiar la base de datos con las operaciones necesarias para dar soporte al nuevo 
	  requerimiento. Esto puede implicar: eliminar, modificar o crear tablas o columnas y además, insertar, 
	  eliminar y/o modificar filas.

	  NOTA: NO MODIFIQUE EL SCRIPT ORIGINAL!. Debe programar un nuevo script para cambiar la base de datos. 
	  Tenga en cuenta que el orden de las operaciones puede ser crítico. Por ejemplo, no se puede eliminar una columna si tiene una regla de integridad. Primero deberá
	  eliminar la regla de integridad.
   
   b. Programar una consulta que muestre, para aquellas cuentas que han tenido algún movimiento, durante el
      año 2020, el saldo final al 31-12 de ese año. Tener en cuenta que los importes de movimiento cuyo tipo 
	  tiene debito_credito = 'C' se suman y los que tienen debito_credito = 'D' se restan.
	  El formato es el siguiente:

      ------------------------------------------------
      nro_cuenta	desc_tipo_cuenta		     saldo
      ------------------------------------------------
      xxxxxxxxxx	xxxxxxxxxxxxxxxxxxxxx	xxxxxxx.xx
      xxxxxxxxxx	xxxxxxxxxxxxxxxxxxxxx	xxxxxxx.xx
      xxxxxxxxxx	xxxxxxxxxxxxxxxxxxxxx	xxxxxxx.xx
      xxxxxxxxxx	xxxxxxxxxxxxxxxxxxxxx	xxxxxxx.xx
*/


--a)

-- Paso 1: Crear una nueva tabla para la relación entre cajas de ahorros y sus titulares
create table cajas_ahorros_clientes
(
    nro_cuenta    integer     not null,
    nro_cliente   integer     not null,
    primary key (nro_cuenta, nro_cliente),
    foreign key (nro_cuenta) references cajas_ahorros(nro_cuenta),
    foreign key (nro_cliente) references clientes(nro_cliente)
);
go

-- Paso 2: Insertar los datos existentes en la nueva tabla de relación
insert into cajas_ahorros_clientes (nro_cuenta, nro_cliente)
select nro_cuenta, nro_cliente from cajas_ahorros;
go

-- Paso 3: eliminacion de la restriccion de dependencia de clave foranea
alter table cajas_ahorros drop constraint FK__cajas_aho__nro_c__29572725;
go

-- Paso 4: Modificar la tabla cajas_ahorros para eliminar la columna nro_cliente
alter table cajas_ahorros
drop column nro_cliente;
go

--b)
--respuesta correcta
select 
    ca.nro_cuenta,
    tc.desc_tipo_cuenta as desc_cuenta,
    sum(case when tm.debito_credito = 'C' then mca.importe_movimiento else -mca.importe_movimiento end) as saldo
from 
    mov_cajas_ahorros mca
inner join 
    cajas_ahorros ca on mca.nro_cuenta = ca.nro_cuenta
inner join 
    tipos_cuentas tc on ca.cod_tipo_cuenta = tc.cod_tipo_cuenta
inner join 
    tipos_movimientos tm on mca.cod_tipo_movimiento = tm.cod_tipo_movimiento
where 
    year(mca.fecha_movimiento) = 2020
group by 
    ca.nro_cuenta,
    tc.desc_tipo_cuenta
go

-- Consulta para mostrar los movimientos y saldos acumulados en 2020
select
    mca.nro_cuenta,
    tc.desc_tipo_cuenta as desc_cuenta,
    sum(case when tm.debito_credito = 'C' then mca.importe_movimiento else -mca.importe_movimiento end) 
        over (partition by mca.nro_cuenta order by mca.fecha_movimiento, mca.nro_movimiento) as saldo
from
    mov_cajas_ahorros mca
inner join 
    cajas_ahorros ca on mca.nro_cuenta = ca.nro_cuenta
inner join 
    tipos_cuentas tc on ca.cod_tipo_cuenta = tc.cod_tipo_cuenta
inner join 
    tipos_movimientos tm on mca.cod_tipo_movimiento = tm.cod_tipo_movimiento
where
    year(mca.fecha_movimiento) = 2020
order by
    mca.nro_cuenta,
    mca.fecha_movimiento,
    mca.nro_movimiento;
go

--El elimminadorinador de tablas
select 'drop table ' + s.name + '.' + o.name
	from sys.objects o
		 join sys.schemas s
			on o.schema_id=s.schema_id
	where o.type='U'

drop table dbo.mov_cajas_ahorros
drop table dbo.tipos_movimientos
drop table dbo.cajas_ahorros
drop table dbo.tipos_cuentas
drop table dbo.clientes
go