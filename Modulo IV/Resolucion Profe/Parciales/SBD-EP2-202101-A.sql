-- INGENIERIA EN INFORMATICA - SISTEMAS DE BASES DE DATOS - EVALUACIÓN PARCIAL Nº 2 - TEMA A - 27-05-2021

/* ---------------------------------------------------------------------------------------------------------------
   La siguiente base de datos da soporte a un sistema de gestión de presupuestos de una empresa.
   Se registra la siguiente información:
   - Áreas de la empresa: identificadas con un número y se registra su nombre.
   - Empleados: Identificados por un nro. de legajo y se registra su nombre
   - Cuentas de gastos: Se registra información acerca de las cuentas que se utilizarán en los presupuestos 
     Las cuentas se identifican por un código, se registra además su nombre.
   - Presupuestos: Los presupuestos serán anuales y se requiere información acerca del año al que corresponde, 
     área y responsable del mismo. También se registra la lista de empleados que pueden autorizar gastos sobre 
	 dicho presupuesto.
   - Gastos presupuestadas: Presupuesto, cuenta y total presupuestado
   - Movimientos de gastos de presupuestos: Se registran todos los movimientos para cada cuenta de cada presupuesto. 
     Se registra: presupuesto y cuenta a la que se imputa el gasto, importe y comprobante asociado
   --------------------------------------------------------------------------------------------------------------- */

drop table mov_gastos_presupuestos
drop table gastos_presupuestados
drop table autorizados_presupuestos
drop table presupuestos
drop table personal
drop table cuentas
drop table areas
go

create table areas
(
 nro_area			smallint	not null,
 area				varchar(40)	not null,
 constraint PK__areas__END		
			primary key (nro_area),
 constraint UK__areas__1__END	
			unique (area)
)
go

create table personal
(
 nro_personal			smallint	not null,
 nom_personal			varchar(40)	not null,
 constraint PK__personal__END	
			primary key (nro_personal)
)
go

create table cuentas
(
 cod_cuenta				smallint	not null,
 nom_cuenta				varchar(40)	not null,
 constraint PK__cuentas__END	
			primary key (cod_cuenta)
)
go

create table presupuestos
(
 nro_area				smallint	not null,
 año_presupuesto		smallint	not null,
 nro_personal			smallint	not null,
 constraint PK__presupuestos__END	
			primary key (nro_area, año_presupuesto),
 constraint FK__presupuestos__areas__1__END	
            foreign key (nro_area) references areas,
 constraint FK__presupuestos__personal__1__END
			foreign key (nro_personal) references personal
)
go

create table autorizados_presupuestos
(
 nro_area				smallint	not null,
 año_presupuesto		smallint	not null,
 nro_personal			smallint	not null,
 constraint PK__autorizados_presupuestos__END	
			primary key (nro_area, año_presupuesto, nro_personal),
 constraint FK__autorizados_presupuestos__presupuestos__1__END
			foreign key (nro_area, año_presupuesto) references presupuestos,
 constraint PK__autorizados_presupuestos__personal__1__END
			foreign key (nro_personal) references personal
)
go

create table gastos_presupuestados
(
 nro_area				smallint		not null,
 año_presupuesto		smallint		not null,
 cod_cuenta				smallint		not null,
 total_presupuestado	decimal(10,2)	not null,
 constraint PK__gastos_presupuestados__END
			primary key (nro_area, año_presupuesto, cod_cuenta),
 constraint FK__gastos_presupuestados__presupuestos__1__END
			foreign key (nro_area, año_presupuesto) references presupuestos,
 constraint FK__gastos_presupuestados__cuentas__1__END
			foreign key (cod_cuenta) references cuentas
)
go

create table mov_gastos_presupuestos
(
 nro_area				smallint		not null,
 año_presupuesto		smallint		not null,
 cod_cuenta				smallint		not null,
 nro_movimiento			integer			not null,
 comprobante			varchar(50)		not null,
 importe				decimal(10,2)	not null,
 constraint PK__mov_gastos_presupuestados__END
			primary key (nro_area, año_presupuesto, cod_cuenta, nro_movimiento),
 constraint FK__mov_gastos_presupuestados__gastos_presupuestados__1__END
			foreign key (nro_area, año_presupuesto, cod_cuenta) references gastos_presupuestados
)
go

insert into areas (nro_area, area)
values (10, 'AREA 10'),
       (20, 'AREA 20'),
       (30, 'AREA 30'),
       (40, 'AREA 40'),
       (50, 'AREA 50'),
       (60, 'AREA 60')
go

insert into personal (nro_personal, nom_personal)
values ( 1, 'EMPLEADO 1'),
       ( 2, 'EMPLEADO 2'),
       ( 3, 'EMPLEADO 3'),
       ( 4, 'EMPLEADO 4'),
       ( 5, 'EMPLEADO 5'),
       ( 6, 'EMPLEADO 6'),
       ( 7, 'EMPLEADO 7'),
       ( 8, 'EMPLEADO 8'),
       ( 9, 'EMPLEADO 9'),
       (10, 'EMPLEADO 10')
go

insert into cuentas (cod_cuenta, nom_cuenta)
values ( 100, 'CUENTA 100'),
       ( 200, 'CUENTA 200'),
       ( 300, 'CUENTA 300'),
       ( 400, 'CUENTA 400'),
       ( 500, 'CUENTA 500'),
       ( 600, 'CUENTA 600'),
       ( 700, 'CUENTA 700'),
       ( 800, 'CUENTA 800'),
       ( 900, 'CUENTA 900'),
       (1000, 'CUENTA 1000')
go

insert into presupuestos (nro_area, año_presupuesto, nro_personal)
values (10, 2020, 1),
       (10, 2021, 2),
       (20, 2020, 3),
       (20, 2021, 4),
       (30, 2021, 7)
go

insert into autorizados_presupuestos (nro_area, año_presupuesto, nro_personal)
values (10, 2020, 2),
       (10, 2020, 4),
       (10, 2020, 5),

       (10, 2021, 3),
       (10, 2021, 7),
       (10, 2021, 10),

       (20, 2020, 4),
       (20, 2020, 9),

       (20, 2021, 5),
       (20, 2021, 6),
       (20, 2021, 7),
       (20, 2021, 2),

       (30, 2021, 6),
       (30, 2021, 1),
       (30, 2021, 8),
       (30, 2021, 10)
go

insert into gastos_presupuestados(nro_area, año_presupuesto, cod_cuenta, total_presupuestado)
values (10, 2020, 100, 200000.00),
       (10, 2020, 200, 150000.00),
       (10, 2020, 400,  75000.00),

       (10, 2021, 200, 1150000.00),
       (10, 2021, 300, 2000000.00),
       (10, 2021, 500,  800000.00),
       (10, 2021, 700,   30000.00),
       
	   (20, 2020, 300, 520000.00),
       (20, 2020, 400, 550000.00),
       (20, 2020, 500, 560000.00),
       
       (20, 2021, 400, 550000.00),
       (20, 2021, 800, 440000.00),
       (20, 2021, 900, 330000.00),
	   (20, 2021,1000, 220000.00),

       (30, 2021, 500,  34000.00),
       (30, 2021, 600, 660000.00),
       (30, 2021, 700, 890000.00),
       (30, 2021, 800,1200000.00),
       (30, 2021, 900, 400000.00)
go

insert into mov_gastos_presupuestos(nro_area, año_presupuesto, cod_cuenta, nro_movimiento, comprobante, importe)
values (10, 2020, 100,  1, 'Factura N° 10 - Proveedor 1',  1573.00),
       (10, 2020, 100,  2, 'Factura N° 44 - Proveedor 3', 20500.00),
       (10, 2020, 100,  3, 'Factura N° 66 - Proveedor 2', 15000.00),
       (10, 2020, 100,  4, 'Factura N° 77 - Proveedor 1', 56000.00),
       
	   (10, 2020, 200,  1, 'Factura N°  3 - Proveedor 1', 3000.00),
       (10, 2020, 200,  2, 'Factura N° 33 - Proveedor 3', 2000.00),
       
       (10, 2020, 400,  1, 'Factura N° 21 - Proveedor 4', 12000.00),
	   (10, 2020, 400,  2, 'Factura N° 11 - Proveedor 5', 22000.00),

       (10, 2021, 200,  1, 'Factura N° 66 - Proveedor 8', 1200.00),
       (10, 2021, 200,  2, 'Factura N° 16 - Proveedor 6', 1100.00),
       (10, 2021, 200,  3, 'Factura N° 36 - Proveedor 5', 2000.00),
       (10, 2021, 200,  4, 'Factura N° 46 - Proveedor 2', 5000.00),

       (10, 2021, 500,  1, 'Factura N° 31 - Proveedor 8', 8000.00),
       (10, 2021, 500,  2, 'Factura N° 41 - Proveedor 4', 800.00),
       (10, 2021, 500,  3, 'Factura N° 11 - Proveedor 1', 850.00),

	   (20, 2020, 300,  1, 'Factura N° 33 - Proveedor 2', 5200.00),
	   (20, 2020, 300,  2, 'Factura N° 45 - Proveedor 1', 200.00),

       (20, 2020, 400,  1, 'Factura N° 22 - Proveedor 3', 1550.00),
       (20, 2020, 400,  2, 'Factura N° 33 - Proveedor 7', 2550.00),
       (20, 2020, 400,  3, 'Factura N° 44 - Proveedor 9', 3550.00),

       (20, 2021, 400,  1, 'Factura N° 61 - Proveedor 1', 1550.00),
       (20, 2021, 400,  2, 'Factura N° 51 - Proveedor 2', 3550.00),
       (20, 2021, 400,  3, 'Factura N° 51 - Proveedor 3', 4550.00),

       (20, 2021, 900,  1, 'Factura N° 81 - Proveedor 4', 330.00),
       (20, 2021, 900,  2, 'Factura N° 71 - Proveedor 4', 330.00),

	   (20, 2021,1000,  1, 'Factura N° 33 - Proveedor 3', 1220.00),
	   (20, 2021,1000,  2, 'Factura N° 22 - Proveedor 2', 220.00),
					    	
       (30, 2021, 500,  1, 'Factura N° 55 - Proveedor 5',  345.00),
       (30, 2021, 500,  2, 'Factura N° 44 - Proveedor 4',  340.00),

       (30, 2021, 700,  1, 'Factura N° 11 - Proveedor 1', 890.00),
       (30, 2021, 700,  2, 'Factura N° 12 - Proveedor 2', 8900.00),
       (30, 2021, 700,  3, 'Factura N° 13 - Proveedor 3', 900.00),
       (30, 2021, 700,  4, 'Factura N° 14 - Proveedor 4', 9000.00),

       (30, 2021, 800,  1, 'Factura N° 99 - Proveedor 9', 2000.00),
       (30, 2021, 800,  2, 'Factura N° 88 - Proveedor 8', 200.00),

       (30, 2021, 900,  1, 'Factura N° 23 - Proveedor 3', 400.00),
       (30, 2021, 900,  2, 'Factura N° 34 - Proveedor 4', 4000.00),
       (30, 2021, 900,  3, 'Factura N° 45 - Proveedor 5', 40000.00),
       (30, 2021, 900,  4, 'Factura N° 56 - Proveedor 6', 1400.00)
go

/*
EJERCICIOS:
   a. Ha surgido un nuevo requerimiento en el sistema de gestión de presupuestos: Se requiere un cambio de modelo. En la tabla de 
      presupuestos se eliminará la columna que tiene la información del empleado responsable. Esa información pasará a la tabla
	  autorizaciones_presupuestos, donde habrá que registrar al responsable y "marcarlo" como "responsable" para distinguirlo de los
	  habilitados para registrar gastos.
      Debe elaborar un script para cambiar la base de datos con las operaciones necesarias para dar soporte al nuevo requerimiento. 
	  Esto puede implicar: eliminar, modificar o crear tablas o columnas.
	  NOTA: NO MODIFIQUE EL SCRIPT ORIGINAL!. Debe programar un nuevo script para cambiar la base de datos. Tenga en cuenta que el orden 
	  de las operaciones puede ser crítico. Por ejemplo, no se puede eliminar una columna si tiene una regla de integridad. Primero deberá
	  eliminar la regla de integridad. (30)

   b. Debe migrar los datos actuales agregando la información del responsable de cada presupuesto a la tabla de personal autorizado para
      realizar pedidos y marcarlos como responsables
	  NOTA2: La migración puede requerir mezclar las operaciones del script programado en el punto a, y el del punto b para no perder 
	  información. (30)

   c. Mostrar para el año 2020 el saldo para cada cuenta de presupuesto. Tener en cuenta que una cuenta puede no tener movimientos asociados 
      (mov_gastos_presupuestos). En ese caso el saldo será el total presupuestado para esa cuenta. Debe mostrarse ordenado por area y nombre de cuenta. (40)
	  El formato es el siguiente:

      AREA			NOM_CUENTA			TOTAL_PRES		SALDO
      ------------	-----------------	------------	----------
      AREA 10		CUENTA 100			150000.00		73400.00
      AREA 10		CUENTA 400			 33000.00		33000.00
      AREA 10		CUENTA 500			200000.00		    0.00
      AREA 20		CUENTA 300			500000.00		  100.00
      AREA 20		CUENTA 400			 45000.00		 4560.00
 	  ....
*/

--a)

-- Paso 1: Añadir una nueva columna 'es_responsable' en la tabla 'autorizados_presupuestos'
ALTER TABLE autorizados_presupuestos
ADD es_responsable BIT NOT NULL DEFAULT 0;

-- Paso 2: Migrar los datos de 'nro_personal' de la tabla 'presupuestos' a la tabla 'autorizados_presupuestos'
-- Insertar responsables que no estén ya en la tabla
INSERT INTO autorizados_presupuestos (nro_area, año_presupuesto, nro_personal, es_responsable)
SELECT p.nro_area, p.año_presupuesto, p.nro_personal, 1
FROM presupuestos p
WHERE NOT EXISTS (
    SELECT 1
    FROM autorizados_presupuestos a
    WHERE a.nro_area = p.nro_area
    AND a.año_presupuesto = p.año_presupuesto
    AND a.nro_personal = p.nro_personal
);

-- Actualizar 'es_responsable' para los responsables existentes
UPDATE autorizados_presupuestos
SET es_responsable = 1
FROM presupuestos p
WHERE autorizados_presupuestos.nro_area = p.nro_area
AND autorizados_presupuestos.año_presupuesto = p.año_presupuesto
AND autorizados_presupuestos.nro_personal = p.nro_personal;

-- Paso 3: Eliminar la columna 'nro_personal' de la tabla 'presupuestos'
alter table presupuestos drop constraint FK__presupuestos__personal__1__END;
go
ALTER TABLE presupuestos
DROP COLUMN nro_personal;

-- Verificación: Comprobar que la migración y actualización se ha realizado correctamente
SELECT * FROM autorizados_presupuestos WHERE es_responsable = 1;
select * from presupuestos


--2. migrar los datos actuales 
insert into autorizados_presupuestos (nro_area, año_presupuesto, nro_personal, responsable) 
	select nro_area, año_presupuesto, nro_personal, 1 
	from presupuestos 
go