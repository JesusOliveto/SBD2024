drop table det_ordenes_compra
drop table ordenes_compra
drop table proveedores_productos
drop table proveedores
drop table productos
go

create table productos
(nro_producto 		integer,
 nom_producto 		varchar(40),
 stock				integer
 primary key (nro_producto)
)
go

create table proveedores
(nro_proveedor 		integer primary key,
 nom_proveedor 		varchar(40)
)
go

create table proveedores_productos
(nro_proveedor 		integer references proveedores,
 nro_producto		integer references productos,
 precio_producto	decimal(10,2),
 dias_entrega		tinyint,
 categoria		char(1),
 primary key (nro_proveedor, nro_producto),
 unique (nro_producto, categoria)
)
go

create table ordenes_compra
(nro_orden_compra 	integer primary key,
 nro_proveedor 		integer references proveedores,
 fecha_orden_compra	date,
 anulada		char(1) default 'N' check (anulada in ('S','N'))
)
go

create table det_ordenes_compra
(nro_orden_compra 	integer references ordenes_compra,
 nro_producto 		integer references productos,
 fecha_entrega 		date,
 cantidad_entrega 	integer,
 primary key (nro_orden_compra, nro_producto, fecha_entrega)
)
go

/*
Se debe programar un procedimiento que reciba como argumentos el nro. de producto a comprar 
la cantidad y la fecha en la que se necesita recibir el producto. 
El procedimiento debe buscar los proveedores del producto y elegir uno entre todos ellos al 
cual solicitar el producto.

Los criterios de selección son: 

1. Aquellos proveedores que lo puedan entregar a tiempo
2. Si hay más de uno, elegir el de menor precio
3. Si hay más de uno, elegir el de mayor categoría (las categorías van de la A (la mayor) 
   hasta la Z (la menor)). 

Si no existe ningún proveedor que cumple con el primer requisito, entonces el procedimiento
devuelve un mensaje de error.

Si se encuentra el proveedor, entonces se inserta una orden de compra con su detalle para
dicho proveedor. El nro. de orden de compra será el siguiente al último registrado. La fecha 
de la orden de compra será la actual. La fecha de entrega será la fecha actual + la cantidad
de días de entrega del proveedor. La cantidad será la solicitada.
*/

insert into productos 
values (1, 'Producto 1', 100)
insert into productos 
values (2, 'Producto 2', 100)
insert into productos 
values (3, 'Producto 3', 100)
insert into productos 
values (4, 'Producto 4', 100)
insert into productos 
values (5, 'Producto 5', 100)
go

insert into proveedores
values (1, 'Proveedor 1')
insert into proveedores
values (2, 'Proveedor 2')
insert into proveedores
values (3, 'Proveedor 3')
insert into proveedores
values (4, 'Proveedor 4')
insert into proveedores
values (5, 'Proveedor 5')
insert into proveedores
values (6, 'Proveedor 6')
go

-- Proveedor 1 por menor precio
insert into proveedores_productos
values (1, 1, 50.00, 10, 'C')
insert into proveedores_productos
values (2, 1, 60.00, 10, 'A')
insert into proveedores_productos
values (3, 1, 50.00, 20, 'B')
insert into proveedores_productos
values (4, 1, 50.00, 15, 'D')
go

-- Proveedor 2 por menor categoria
insert into proveedores_productos
values (1, 2, 50.00, 8, 'C')
insert into proveedores_productos
values (2, 2, 50.00, 9, 'A')
go

-- Proveedor 4 por ser unico proveedor
insert into proveedores_productos
values (4, 3, 50.00, 10, 'C')
go

-- Proveedor 4 porque es el unico que puede entregarlo en la fecha solicitada
insert into proveedores_productos
values (1, 4, 50.00, 17, 'C')
insert into proveedores_productos
values (2, 4, 60.00, 18, 'A')
insert into proveedores_productos
values (3, 4, 50.00, 15, 'B')
insert into proveedores_productos
values (4, 4, 90.00, 7, 'D')
go

-- ningun proveedor puede entregarlo en la fecha solicitada --> ERROR
insert into proveedores_productos
values (3, 5, 50.00, 12, 'C')
insert into proveedores_productos
values (4, 5, 60.00, 20, 'A')
insert into proveedores_productos
values (5, 5, 50.00, 30, 'B')
insert into proveedores_productos
values (6, 5, 50.00, 15, 'D')
go

-- realizar pruebas con estos argumentos
execute generar_orden_compra @nro_producto = 1, @cantidad = 300, @fecha = '2001-12-20'
go
execute generar_orden_compra @nro_producto = 2, @cantidad = 300, @fecha = '2001-12-20'
go
execute generar_orden_compra @nro_producto = 3, @cantidad = 300, @fecha = '2001-12-20'
go
execute generar_orden_compra @nro_producto = 4, @cantidad = 300, @fecha = '2001-12-20'
go
execute generar_orden_compra @nro_producto = 5, @cantidad = 300, @fecha = '2001-12-20'
go

