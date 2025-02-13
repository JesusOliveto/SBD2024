--------------------------------------------------------------------------------------------------------------
-- INGENIERIA EN INFORMATICA - SISTEMAS DE BASES DE DATOS - EVALUACIÓN PARCIAL Nº 3 - TEMA B - 24-06-2021
--------------------------------------------------------------------------------------------------------------
/* -----------------------------------------------------------------------------------------------------------------------------------
   En una empresa se decide sistematizar los procesos de compra de productos.
   Algunas consideraciones surgidas del análisis de requerimientos son las siguientes:

   - Cada producto tiene un único proveedor, el cual tiene una cantidad máxima de días de entrega para 
     cada compra de dicho producto
   - Hay productos que son equivalentes entre sí. Pero el nivel de equivalencia (porcentaje) puede ser 
     diferente. Puede haber productos que son 100% equivalentes y se pueden reemplazar sin ningún problema,
	 y hay otros que tienen un porcentaje menor de equivalencia. Algunos clientes aceptan un producto 
	 similar aunque no igual (% equivalencia menor a 100), pero otros no.
   - Cuando se desea comprar un producto se emite (y se registra) una orden de compra a un proveedor.
   - En la orden de compra se pueden incluir varios productos

   Se implementó una base de datos a través del script siguiente:
*/
use practicaParcial3
go

drop table det_ordenes_compra
drop table ordenes_compra
drop table productos_equivalentes
drop table productos
drop table proveedores
go

create table proveedores
(
 nro_proveedor 		integer			not null,
 nom_proveedor 		varchar(40)		not null,
 constraint PK__proveedores__END	primary key (nro_proveedor),
 constraint UK__proveedores__1__END unique (nom_proveedor)
)
go

create table productos
(
 nro_producto 		integer			not null,
 nom_producto 		varchar(40)		not null,
 nro_proveedor		integer			not null,
 precio_producto	decimal(10,2)	not null,
 dias_entrega		tinyint			not null,
 stock				integer			not null,
 constraint PK__productos__END					primary key (nro_producto),
 constraint UK__productos__1__END				unique (nom_producto),
 constraint FK__productos__proveedores__1__END	foreign key (nro_proveedor) references proveedores
)
go

create table productos_equivalentes
(
 nro_producto 		integer			not null,
 nro_producto_equiv	integer			not null,
 nivel_equivalencia	tinyint			not null,
 constraint PK__productos_equivalentes__END						primary key (nro_producto, nro_producto_equiv),
 constraint FK__productos_equivalentes__productos__1__END		foreign key (nro_producto) references productos,
 constraint FK__productos_equivalentes__productos__2__END		foreign key (nro_producto_equiv) references productos,
 constraint CK__productos_equivalentes__nivel_equivalencia__END check (nivel_equivalencia between 1 and 100)
)
go

create table ordenes_compra
(
 nro_orden_compra 	integer			not null,
 nro_proveedor 		integer			not null,
 fecha_orden_compra date			not null,
 anulada			char(1)			not null	constraint DF__ordenes_compra__anulada__N__END default 'N',
 constraint PK__ordenes_compra__END					primary key (nro_orden_compra),
 constraint FK__ordenes_compra__proveedores__1__END foreign key (nro_proveedor) references proveedores,
 constraint CK__ordenes_compra__anulada__END		check (anulada in ('S','N'))
)
go

create table det_ordenes_compra
(
 nro_orden_compra 	integer			not null,
 nro_producto 		integer			not null,
 fecha_entrega 		date			not null,
 cantidad_pedida 	integer			not null,
 constraint PK__det_ordenes_compra_END						primary key (nro_orden_compra, nro_producto),
 constraint FK__det_ordenes_compra__ordenes_compra__1__END	foreign key (nro_orden_compra) references ordenes_compra,
 constraint FK__det_ordenes_compra__productos__1__END		foreign key (nro_producto) references productos,
 constraint CK__det_ordenes_compra__cantidad_pedida__END	check (cantidad_pedida > 0)
)
go

insert into proveedores (nro_proveedor, nom_proveedor)
values ( 1, 'PROVEEDOR 1'),
       ( 2, 'PROVEEDOR 2'),
       ( 3, 'PROVEEDOR 3'),
       ( 4, 'PROVEEDOR 4'),
       ( 5, 'PROVEEDOR 5'),
       ( 6, 'PROVEEDOR 6'),
       ( 7, 'PROVEEDOR 7'),
       ( 8, 'PROVEEDOR 8'),
       ( 9, 'PROVEEDOR 9'),
       (10, 'PROVEEDOR 10')
go

insert into productos (nro_producto, nom_producto, nro_proveedor, precio_producto, dias_entrega, stock)
values ( 1, 'PRODUCTO 1',  1, 150.00, 30, 100),
       ( 2, 'PRODUCTO 2',  1, 250.00, 60, 200),
       ( 3, 'PRODUCTO 3',  2, 350.00, 10, 200),
       ( 4, 'PRODUCTO 4',  2, 450.00, 20, 0),
       ( 5, 'PRODUCTO 5',  2, 550.00, 40, 20),
       ( 6, 'PRODUCTO 6',  3, 650.00, 50, 50),
       ( 7, 'PRODUCTO 7',  4, 125.00, 10, 10),
       ( 8, 'PRODUCTO 8',  5, 275.00, 70, 5),
       ( 9, 'PRODUCTO 9',  6, 350.00, 15, 150),
       (10, 'PRODUCTO 10', 6, 400.00, 25, 0),
       (11, 'PRODUCTO 11', 7, 100.00, 50, 10),
       (12, 'PRODUCTO 12', 8, 600.00, 90, 40)

insert into productos_equivalentes (nro_producto, nro_producto_equiv, nivel_equivalencia)
values (1,  7, 100),
       (1, 11, 80),
       (2,  8, 50),
       (3,  9, 100),
       (5, 10, 100),
       (5, 12, 100)
go

insert into ordenes_compra (nro_orden_compra, nro_proveedor, fecha_orden_compra, anulada)
values ( 1, 1, '2021-01-01', 'N'),
       ( 2, 1, '2021-01-31', 'N'),
       ( 3, 2, '2021-02-11', 'N'),
       ( 4, 2, '2021-03-12', 'N'),
       ( 5, 2, '2021-03-09', 'N'),
       ( 6, 4, '2021-03-23', 'N'),
       ( 7, 5, '2021-04-29', 'N'),
	   ( 8, 6, '2021-05-15', 'N'),
	   ( 9, 7, '2021-05-15', 'N'),
	   (10, 8, '2021-05-16', 'S')

insert into det_ordenes_compra (nro_orden_compra, nro_producto, fecha_entrega, cantidad_pedida)
values (1,  1, '2021-07-11', 50),
       (1,  2, '2021-08-01', 20),
       (2,  1, '2021-07-25', 200),
       (3,  3, '2021-07-27', 10),
       (3,  5, '2021-08-31', 50),
       (4,  4, '2021-07-23', 100),
       (4,  5, '2021-07-24', 20),
       (5,  3, '2021-10-30', 50),
       (6,  7, '2021-07-03', 50),
       (7,  8, '2021-07-07', 80),
       (8,  9, '2021-07-13', 80),
       (8, 11, '2021-07-14', 80),
       (9, 12, '2021-07-15', 80)
go


/*
1. Regla de integridad: todos los productos incluidos en una orden de compra deben ser provistos por 
   el proveedor al cual se le emite la misma.
   
   Realizar el análisis, diseño e implementación de triggers que aseguren dicha regla, 
   desarrollando los siguientes pasos:

   a. Programar la lista de detalles de órdenes de compra que no cumplen la regla de integridad (5)

   b. Construir una tabla gráfica que muestre las tablas involucradas (en filas), las operaciones
      de actualización sobre las tablas (en columnas) y las acciones a tener en cuenta (en celdas)(10)

   c. Programar los triggers que aseguran dicha regla de integridad, según la tabla del paso anterior.(25)

2. Programar un procedimiento almacenado que recibe como argumentos: (60)
   - nro_producto
   - cantidad
   - fecha
   y realice lo siguiente:

   a. si el stock del producto alcanza para entregar esa cantidad:
      --> devolver un result set con una fila y dos columnas: nro_retorno = 1, msj_retorno = 'Ok.'

   b. si el stock del producto + stock de todos los productos equivalentes con nivel de equivalencia = 100
      alcanza para entregar esa cantidad:
      --> devolver un result set con una fila y dos columnas: nro_retorno = 2, msj_retorno = 'Ok. Se completa con productos equivalentes.'

   c. si el stock del producto + las cantidades pedidas en órdenes de compra de ese producto 
      con fecha de entrega > a la actual y fecha de entrega <= fecha (argumento):
      --> devolver un result set con una fila y dos columnas: nro_retorno = 3, msj_retorno = 'Ok. Se completa con compras pendientes.'

   d. si el stock del producto 
      + stock de todos los productos equivalentes con nivel de equivalencia = 100 
      + las cantidades pedidas en órdenes de compra de ese producto y de sus equivalentes con nivel de equivalencias = 100 
        con fecha de entrega > a la actual y fecha de entrega <= fecha (argumento):
      --> devolver un result set con una fila con dos columnas: nro_retorno = 4, msj_retorno = 'Ok. Se completa con productos equivalentes y compras pendientes.'

   e. si la fecha actual + cantidad de días de entrega del proveedor para ese producto <= fecha (argumento):
      1. insertar una orden de compra y su detalle, solicitando el producto donde:
         - nro_orden_compra: el próximo
         - nro_proveedor: el del producto
         - fecha_orden_compra: la actual
         - anulada: N
         - nro_producto: el solicitado
         - fecha_entrega: la actual + dias de entrega
         - cantidad_pedida: la cantidad solicitada - stock del producto solicitado
      2. devolver un result set con una fila con dos columnas: nro_retorno = -1, msj_retorno = 'Se registró una orden de compra para completar el pedido.'

   f. sino:         
      --> devolver un result set con una fila con dos columnas: nro_retorno = -2, msj_retorno = 'No se puede satisfacer el pedido.'

   Evaluación:
   - Implementación del punto a:  5 puntos
   
   - Implementación del punto b: 10 puntos
   
   - Implementación del punto c: 10 puntos
   
   - Implementación del punto d: 10 puntos
   
   - Implementación del punto e: 10 puntos
  
   - Lógica y programación general del procedimiento: 15 puntos
*/                 

/*1)a. Programar la lista de detalles de órdenes de compra que no cumplen la regla de integridad (5)*/
SELECT 
    doc.nro_orden_compra,
    doc.nro_producto,
    p.nro_proveedor AS proveedor_producto, 
    oc.nro_proveedor AS proveedor_orden
FROM 
    det_ordenes_compra doc
JOIN 
    productos p ON doc.nro_producto = p.nro_producto
JOIN 
    ordenes_compra oc ON doc.nro_orden_compra = oc.nro_orden_compra
WHERE 
    p.nro_proveedor != oc.nro_proveedor;

/*De esta consulta podemos ver que se utilizan 3 tablas, det_ordenes_compra, ordenes_compra y productos, ahora hay que 
analizar estas 3 en base a la tabla de actualizacion*/

/*1)b. Construir una tabla gráfica que muestre las tablas involucradas (en filas), las operaciones
      de actualización sobre las tablas (en columnas) y las acciones a tener en cuenta (en celdas)*/

/*
--------------------------------------------------------------------------------------------------------------
tabla						insert						delete						update			
--------------------------------------------------------------------------------------------------------------
det_ordenes_compra			SI							NO							SI (si se modifica nro_producto)
																						(si se modifica el nro_orden_compra) Esto se puede resolver prohibiendo la modificacion del nro_producto y nro_orden_compra
--------------------------------------------------------------------------------------------------------------
ordenes_compra				NO							NO							SI (si se modifica proveedor) Esto tambien se puede resolver como arriba
--------------------------------------------------------------------------------------------------------------
productos					NO							NO							SI (se puede cambiar el proveedor de un producto)
--------------------------------------------------------------------------------------------------------------
*/
/*Trigger insert det_ordenes_compra*/
create or alter trigger ti_det_ordenes_compra
on det_ordenes_compra
for insert
as
begin
/*Usando la consulta para ver cuales son las erroneas podemos hacer el trigger cambiando la tabla a verificar por inserted*/
	if exists(SELECT 
					doc.nro_orden_compra,
					doc.nro_producto,
					p.nro_proveedor AS proveedor_producto, 
					oc.nro_proveedor AS proveedor_orden
				FROM 
					inserted doc
				JOIN 
					productos p ON doc.nro_producto = p.nro_producto
				JOIN 
					ordenes_compra oc ON doc.nro_orden_compra = oc.nro_orden_compra
				WHERE 
					p.nro_proveedor != oc.nro_proveedor)
			begin
				raiserror('El producto no tiene el mismo proveedor',16,1)
				rollback
			end

end
go
/*Trigger update det_ordenes_compra version simple*/
create or alter trigger tu_det_ordenes_compra
on det_ordenes_compra
for update
as
begin
/*Solucion bloqueando la edicion de la tabla*/
	if UPDATE(nro_producto) or UPDATE(nro_orden_compra)
	begin
		raiserror('No se puede modificar el numero del producto ni el numero de la orden de compra, elimine e inserte un nuevo registro',16,1)
		rollback
	end
end
go
/*Trigger update det_ordenes_compra version compleja*/
/*
create or alter trigger tu_det_ordenes_compra
on det_ordenes_compra
for update
as
begin
/*En este caso las filas updeteadas tambien son sometidas a la verificacion*/
	if exists(SELECT 
					doc.nro_orden_compra,
					doc.nro_producto,
					p.nro_proveedor AS proveedor_producto, 
					oc.nro_proveedor AS proveedor_orden
				FROM 
					inserted doc
				JOIN 
					productos p ON doc.nro_producto = p.nro_producto
				JOIN 
					ordenes_compra oc ON doc.nro_orden_compra = oc.nro_orden_compra
				WHERE 
					p.nro_proveedor != oc.nro_proveedor)
			begin
				raiserror('El producto no tiene el mismo proveedor',16,1)
				rollback
			end

end
go*/

/*Trigger update ordenes_compra version simple*/
create or alter trigger tu_ordenes_compra
on ordenes_compra
for update
as
begin
/*Solucion bloqueando la edicion de la tabla*/
	if exists (select *
				from det_ordenes_compra doc
				join inserted i
				on doc.nro_orden_compra = i.nro_orden_compra) /*Si existe un detalle de compra para la compra y se intenta modificar el proveedor, rompe la regla de integridad*/
	and
	UPDATE(nro_proveedor) /*Igual solo con esto es funcional*/
	begin
		raiserror('No se puede modificar proveedor de la orden de compra, elimine e inserte un nuevo registro',16,1)
		rollback
	end
end
go

/*Trigger update producto version simple*/
create or alter trigger tu_productos
on productos
for update
as
begin
/*Solucion bloqueando la edicion de la tabla*/
	if exists (select * 
				from inserted i
				join det_ordenes_compra doc
				on i.nro_producto=doc.nro_producto) /*Vemos si se modifica un nro_producto que existe en un det_ordenes_compra*/
	and 
	UPDATE(nro_producto)
	begin
		raiserror('No se puede modificar el numero del producto, elimine e inserte un nuevo registro',16,1)
		rollback
	end
end
go

/*2)*/
CREATE or alter PROCEDURE verificar_stock_producto
    @nro_producto INT,
    @cantidad INT,
    @fecha DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @stock_actual INT;
	DECLARE @stock_total_equivalentes INT;
	DECLARE @stock_compras_pendientes INT;
	DECLARE @stock_total_equivalentes_y_pendientes INT;
	DECLARE @dias_entrega INT;
    DECLARE @nro_proveedor INT;
    DECLARE @nueva_fecha_entrega DATE;
    DECLARE @cantidad_faltante INT;

    -- Obtener el stock actual del producto
    SELECT @stock_actual = stock
    FROM productos
    WHERE nro_producto = @nro_producto;

    -- Verificar si el stock alcanza para entregar la cantidad pedida
    IF @stock_actual >= @cantidad
    BEGIN
        -- Devolver resultado indicando que el stock es suficiente
        SELECT 1 AS nro_retorno, 'Ok.' AS msj_retorno;
    END
	ELSE
	begin
		SELECT @stock_total_equivalentes = SUM(p.stock)
		FROM productos_equivalentes pe
		JOIN productos p ON pe.nro_producto_equiv = p.nro_producto
		WHERE pe.nro_producto = @nro_producto AND pe.nivel_equivalencia = 100;
		-- Verificar si el stock total (producto + equivalentes) alcanza para entregar la cantidad pedida
		IF @stock_actual + ISNULL(@stock_total_equivalentes, 0) >= @cantidad
		BEGIN
			-- Devolver resultado indicando que el stock total es suficiente utilizando productos equivalentes
			SELECT 2 AS nro_retorno, 'Ok. Se completa con productos equivalentes.' AS msj_retorno;
		END
		ELSE
		BEGIN
			SELECT @stock_compras_pendientes = SUM(doc.cantidad_pedida)
			FROM det_ordenes_compra doc
			JOIN ordenes_compra oc ON doc.nro_orden_compra = oc.nro_orden_compra
			WHERE doc.nro_producto = @nro_producto
				AND doc.fecha_entrega > '2021-01-01'/*GETDATE()*/
				AND doc.fecha_entrega <= @fecha
				AND oc.anulada = 'N';
			
			-- Verificar si el stock total (producto + compras pendientes) alcanza para entregar la cantidad pedida
			IF @stock_actual + ISNULL(@stock_compras_pendientes, 0) >= @cantidad
			BEGIN
				-- Devolver resultado indicando que el stock total es suficiente utilizando compras pendientes
				SELECT 3 AS nro_retorno, 'Ok. Se completa con compras pendientes.' AS msj_retorno;
			END
			ELSE
			BEGIN
				-- Calcular el stock total de los productos equivalentes con nivel de equivalencia 100% y sus compras pendientes
				SELECT @stock_total_equivalentes_y_pendientes = SUM(p.stock + ISNULL(d.cantidad_pedida, 0))
				FROM productos_equivalentes pe
				JOIN productos p ON pe.nro_producto_equiv = p.nro_producto
				LEFT JOIN det_ordenes_compra d ON d.nro_producto = p.nro_producto
				LEFT JOIN ordenes_compra o ON d.nro_orden_compra = o.nro_orden_compra
				WHERE pe.nro_producto = @nro_producto
				  AND pe.nivel_equivalencia = 100
				  AND (d.fecha_entrega > '2021-01-01'/*GETDATE()*/ AND d.fecha_entrega <= @fecha AND o.anulada = 'N' OR d.nro_producto IS NULL);

				-- Verificar si el stock total (producto + equivalentes + compras pendientes) alcanza para entregar la cantidad pedida
				IF @stock_actual + ISNULL(@stock_total_equivalentes_y_pendientes, 0) +  ISNULL(@stock_compras_pendientes, 0)>= @cantidad
				BEGIN
					-- Devolver resultado indicando que el stock total es suficiente utilizando productos equivalentes y compras pendientes
					SELECT 4 AS nro_retorno, 'Ok. Se completa con productos equivalentes y compras pendientes.' AS msj_retorno;
				END
				ELSE
				BEGIN
					-- Obtener los días de entrega y el proveedor del producto solicitado
					SELECT @dias_entrega = dias_entrega, @nro_proveedor = nro_proveedor
					FROM productos
					WHERE nro_producto = @nro_producto;

					-- Calcular la nueva fecha de entrega
					SET @nueva_fecha_entrega = DATEADD(day, @dias_entrega, '2021-01-01'/*GETDATE()*/);

					-- Verificar si la fecha actual + días de entrega <= @fecha
					IF @nueva_fecha_entrega <= @fecha
					BEGIN
						-- Calcular la cantidad faltante
						SET @cantidad_faltante = @cantidad - (@stock_actual + ISNULL(@stock_total_equivalentes_y_pendientes, 0) +  ISNULL(@stock_compras_pendientes, 0))/*@stock_actual*/;

						-- Obtener el próximo número de orden de compra
						DECLARE @nro_orden_compra INT;
						SELECT @nro_orden_compra = ISNULL(MAX(nro_orden_compra), 0) + 1 FROM ordenes_compra;

						-- Insertar una nueva orden de compra
						INSERT INTO ordenes_compra (nro_orden_compra, nro_proveedor, fecha_orden_compra, anulada)
						VALUES (@nro_orden_compra, @nro_proveedor, GETDATE(), 'N');

						-- Insertar el detalle de la nueva orden de compra
						INSERT INTO det_ordenes_compra (nro_orden_compra, nro_producto, fecha_entrega, cantidad_pedida)
						VALUES (@nro_orden_compra, @nro_producto, @nueva_fecha_entrega, @cantidad_faltante);

						-- Devolver resultado indicando que se registró una nueva orden de compra
						SELECT -1 AS nro_retorno, 'Se registró una orden de compra para completar el pedido.' AS msj_retorno;
						RETURN;
					END
					else
					begin
						-- Devolver resultado indicando que el stock es insuficiente
						SELECT -2 AS nro_retorno, 'No se puede satisfacer el pedido.' AS msj_retorno;
					end
				END
			END
		END
	end
END;
GO

select * from productos
select * from productos_equivalentes
select * from det_ordenes_compra
select * from ordenes_compra
execute verificar_stock_producto @nro_producto=1, @cantidad=100, @fecha='2021-08-01'
execute verificar_stock_producto @nro_producto=1, @cantidad=110, @fecha='2021-08-01'
execute verificar_stock_producto @nro_producto=1, @cantidad=350, @fecha='2021-08-01'
execute verificar_stock_producto @nro_producto=1, @cantidad=410, @fecha='2021-08-01'
execute verificar_stock_producto @nro_producto=1, @cantidad=411, @fecha='2021-08-01'