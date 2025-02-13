-- INGENIERÍA INFORMÁTICA - SISTEMAS DE BASES DE DATOS
-- EVALUACIÓN PARCIAL RECUPERATORIA Nº 3 - 27-06-2024

/* -----------------------------------------------------------------------------------------------------------------------------------
Una empresa que fabrica electrodomésticos desea mantener información acerca de los mismos, sus modelos, los comercios a los cuales 
se les vendió y los clientes que los han adquirido en esos comercios. Además se registran los reclamos que han tenido. 
Para esto decide implementar una base de datos relacional.

La información a almacenar en la misma es la siguiente:

­- La empresa produce diferentes tipos de electrodomésticos. Por ejemplo: heladeras, equipos de aire acondicionado, lavarropas, cocinas, hornos, etc. 
  Se identifican por un código interno único, nombre y clase de electrodoméstico (calefacción, refrigeración, etc.)

- De cada tipo de electrodoméstico se producen varios modelos que se identifican por un código único. Cada uno tiene diferentes prestaciones o características. 
  Se debe mantener información acerca de sus características y el tiempo de garantía medido en meses otorgado por la empresa.

- Se deben registrar las partes que componen los modelos con sus características. Una parte puede ser utilizada para varios 
  modelos. 
  Se debe indicar también, que cantidad de unidades de cada parte se utiliza en el armado de cada modelo. 

­- A medida que se van fabricando los electrodomésticos se deben ir registrando. 
  Cada electrodoméstico fabricado se identifica por un nro. de serie único. Se debe indicar el tipo de electrodoméstico, el modelo, la fecha de fabricación, 
  y si está vendido, el comercio y la fecha de venta al comercio.

- Cuando el comercio lo vende registra en nuestra base de datos los datos del cliente y la fecha de venta al mismo.

- De los comercios se requiere conocer su nombre, dirección y teléfonos. 

- De los clientes se requiere conocer su nombre y DNI.

­- Se deben registrar también las fallas de los electrodomésticos informadas por los clientes. En particular se necesita conocer el electrodoméstico, 
  el cliente, la fecha de registro de la falla, una descripción de la misma y las partes reemplazadas.

La base de datos implementada en Microsoft SQL Server es la siguiente:
*/

drop table dbo.partes_reemplazadas
drop table dbo.reclamos
drop table dbo.electrodomesticos
drop table dbo.clientes
drop table dbo.comercios
drop table dbo.partes_modelos
drop table dbo.partes_electrodomesticos
drop table dbo.modelos_electrodomesticos
drop table dbo.tipos_electrodomesticos
drop table dbo.clases_electrodomesticos

create table dbo.clases_electrodomesticos
(
 cod_clase_electrodomestico		varchar(3)	not null,
 nom_clase_electrodomestico		varchar(40)	not null,
 constraint PK__clases_electrodomesticos__END 
            primary key (cod_clase_electrodomestico)
)

create table dbo.tipos_electrodomesticos
(
 cod_tipo_electrodomestico		varchar(3)	not null,
 nom_tipo_electrodomestico		varchar(40)	not null,
 cod_clase_electrodomestico		varchar(3)	not null,
 constraint PK__tipos_electrodomesticos__END 
            primary key (cod_tipo_electrodomestico),
 constraint FK__tipos_electrodomesticos__clases_electrodomesticos__1__END 
            foreign key (cod_clase_electrodomestico) references dbo.clases_electrodomesticos
)

create table dbo.modelos_electrodomesticos
(
 cod_modelo_electrodomestico	varchar(10)		not null,
 cod_tipo_electrodomestico		varchar(3)		not null,
 caracteristicas				varchar(255)	not null,
 meses_garantia					smallint		not null,
 constraint PK__modelos_electrodomesticos__END 
            primary key (cod_modelo_electrodomestico),
 constraint FK__modelos_electrodomesticos__tipos_electrodomesticos__1__END 
            foreign key (cod_tipo_electrodomestico) references dbo.tipos_electrodomesticos,
 constraint CK__modelos_electrodomesticos__meses_garantia__END
            check (meses_garantia > 0)
)

create table dbo.partes_electrodomesticos
(
 cod_parte_electrodomestico		varchar(10)		not null,
 nom_parte_electrodomestico		varchar(255)	not null,
 caracteristicas				varchar(255)	not null,
 constraint PK__partes_electrodomesticos__END 
            primary key (cod_parte_electrodomestico)
)

create table dbo.partes_modelos
(
 cod_modelo_electrodomestico	varchar(10)		not null,
 cod_parte_electrodomestico		varchar(10)		not null,
 cantidad						tinyint			not null,
 constraint PK__partes_modelos__END 
            primary key (cod_modelo_electrodomestico, cod_parte_electrodomestico),
 constraint FK__partes_modelos__modelos_electrodomesticos__1__END
            foreign key (cod_modelo_electrodomestico) references dbo.modelos_electrodomesticos,
 constraint FK__partes_modelos__partes_electrodomesticos__1__END
            foreign key (cod_parte_electrodomestico) references dbo.partes_electrodomesticos,
 constraint CK__partes_modelos__cantidad__END
            check (cantidad > 0)
)

create table dbo.comercios
(
 nro_comercio					smallint		not null,
 nom_comercio					varchar(40)		not null,
 dir_comercio					varchar(255)	not null,
 tel_comercio					varchar(40)		not null,
 constraint PK__comercios__END
            primary key (nro_comercio)
)

create table dbo.clientes
(
 nro_cliente					integer			not null,
 nom_cliente					varchar(40)		not null,
 dni_cliente					integer			not null,
 constraint PK__clientes__END
            primary key (nro_cliente),
 constraint UK__clientes__1__END
			unique (dni_cliente)
)

create table dbo.electrodomesticos
(
 nro_serie						varchar(20)		not null,
 cod_modelo_electrodomestico	varchar(10)		not null,
 fecha_fabricacion				date			not null,
 nro_comercio					smallint		null,
 fecha_venta_comercio			date			null,
 nro_cliente					integer			null,
 fecha_venta_cliente			date			null,
 constraint PK__electrodomesticos__END 
            primary key (nro_serie),
 constraint FK__electrodomesticos__modelos_electrodomesticos__1__END
            foreign key (cod_modelo_electrodomestico) references dbo.modelos_electrodomesticos,
 constraint FK__electrodomesticos__comercios__1__END
            foreign key (nro_comercio) references dbo.comercios,
 constraint FK__electrodomesticos__clientes__1__END
            foreign key (nro_cliente) references dbo.clientes,
 constraint CK__electrodomesticos__ventas__END
            check (nro_comercio is null     and fecha_venta_comercio is null     and nro_cliente is null     and fecha_venta_cliente is null or
			       nro_comercio is not null and fecha_venta_comercio is not null and nro_cliente is null     and fecha_venta_cliente is null or
			       nro_comercio is not null and fecha_venta_comercio is not null and nro_cliente is not null and fecha_venta_cliente is not null)
)

create table dbo.reclamos
(
 nro_reclamo					integer			not null,
 nro_serie						varchar(20)		not null,
 fecha_reclamo					date			not null,
 observaciones					varchar(255)	not null,
 constraint PK__reclamos__END
			primary key (nro_reclamo),
 constraint FK__reclamos__electrodomesticos__1__END
			foreign key (nro_serie) references dbo.electrodomesticos
)

create table dbo.partes_reemplazadas
(
 nro_reclamo					integer			not null,
 cod_parte_electrodomestico		varchar(10)		not null,
 cantidad						tinyint			not null,
 constraint PK__partes_reemplazadas__END
            primary key (nro_reclamo, cod_parte_electrodomestico),
 constraint FK__partes_reemplazadas__reclamos__1__END
			foreign key (nro_reclamo) references dbo.reclamos,
 constraint FK__partes_reemplazadas__partes_electrodomesticos__1__END
			foreign key (cod_parte_electrodomestico) references dbo.partes_electrodomesticos
)

-- Insertar datos en la tabla clases_electrodomesticos
INSERT INTO dbo.clases_electrodomesticos (cod_clase_electrodomestico, nom_clase_electrodomestico)
VALUES 
('CAL', 'Calefacción'),
('REF', 'Refrigeración')

-- Insertar datos en la tabla tipos_electrodomesticos
INSERT INTO dbo.tipos_electrodomesticos (cod_tipo_electrodomestico, nom_tipo_electrodomestico, cod_clase_electrodomestico)
VALUES 
('HEL', 'Heladera', 'REF'),
('AIR', 'Aire Acondicionado', 'REF')

-- Insertar datos en la tabla modelos_electrodomesticos
INSERT INTO dbo.modelos_electrodomesticos (cod_modelo_electrodomestico, cod_tipo_electrodomestico, caracteristicas, meses_garantia)
VALUES 
('MOD1', 'HEL', 'Heladera con freezer', 24),
('MOD2', 'AIR', 'Aire acondicionado split', 12)

-- Insertar datos en la tabla partes_electrodomesticos
INSERT INTO dbo.partes_electrodomesticos (cod_parte_electrodomestico, nom_parte_electrodomestico, caracteristicas)
VALUES 
('P001', 'Compresor', 'Compresor de alta eficiencia'),
('P002', 'Filtro', 'Filtro de aire HEPA')

-- Insertar datos en la tabla partes_modelos
INSERT INTO dbo.partes_modelos (cod_modelo_electrodomestico, cod_parte_electrodomestico, cantidad)
VALUES 
('MOD1', 'P001', 1),  -- La heladera (MOD1) usa 1 compresor (P001)
('MOD1', 'P002', 2),  -- La heladera (MOD1) usa 2 filtros (P002)
('MOD2', 'P002', 1)  -- El aire acondicionado (MOD2) usa 1 filtro (P002)

-- Insertar datos en la tabla comercios
INSERT INTO dbo.comercios (nro_comercio, nom_comercio, dir_comercio, tel_comercio)
VALUES 
(1, 'ElectroShop', 'Av. Principal 123', '123-4567')

-- Insertar datos en la tabla clientes
INSERT INTO dbo.clientes (nro_cliente, nom_cliente, dni_cliente)
VALUES 
(1, 'Juan Pérez', 12345678)

-- Insertar datos en la tabla electrodomesticos
INSERT INTO dbo.electrodomesticos (nro_serie, cod_modelo_electrodomestico, fecha_fabricacion, nro_comercio, fecha_venta_comercio, nro_cliente, fecha_venta_cliente)
VALUES 
('S001', 'MOD1', '2023-01-01', 1, '2023-02-01', 1, '2023-03-01'),  -- Electrodoméstico vendido a un cliente
('S002', 'MOD2', '2023-01-15', 1, '2023-02-15', 1, '2023-03-15')  -- Otro electrodoméstico vendido a un cliente

-- Insertar datos en la tabla reclamos
INSERT INTO dbo.reclamos (nro_reclamo, nro_serie, fecha_reclamo, observaciones)
VALUES 
(1, 'S001', '2024-06-01', 'El compresor no funciona')

-- Insertar datos en la tabla partes_reemplazadas
-- Este registro no cumple la regla de integridad (parte no pertenece al modelo)
/*INSERT INTO dbo.partes_reemplazadas (nro_reclamo, cod_parte_electrodomestico, cantidad)
VALUES 
(1, 'P002', 3)  -- La heladera (MOD1) usa solo 2 filtros (P002) pero se intentan reemplazar 3*/

INSERT INTO dbo.electrodomesticos (nro_serie, cod_modelo_electrodomestico, fecha_fabricacion, nro_comercio, fecha_venta_comercio, nro_cliente, fecha_venta_cliente)
VALUES 
('S003', 'MOD2', '2023-01-20', 1, '2023-02-20', 1, '2023-03-20')  -- Otro electrodoméstico vendido a un cliente

-- Insertar datos adicionales en la tabla reclamos
INSERT INTO dbo.reclamos (nro_reclamo, nro_serie, fecha_reclamo, observaciones)
VALUES 
(2, 'S002', '2024-06-10', 'El filtro necesita ser reemplazado'), -- Reclamo correcto
(3, 'S003', '2024-06-15', 'El compresor no funciona')           -- Reclamo con parte incorrecta



/*
1. Programar todos los triggers necesarios para asegurar la siguiente regla de integridad: (50)

   "Las partes reemplazadas deben pertenecer al modelo del electrodomestico y la cantidad reemplazada no puede ser 
    mayor a la cantidad que se utiliza para fabricar dicho electrodomestico"
	Que la parte remplaza pertenezca al electrodomestico usado en el modelo del electrodomestico 
2. Programar un procedimiento almacenado que reciba como argumento el identificador de una parte, y un período de años para
   analizar (año_desde y año_hasta), y devuelva, por cada año, la cantidad de fallas que ha tenido esa parte (reclamos donde 
   se haya reemplazado esa parte) dentro del período de garantía (se cuenta desde la fecha de venta al cliente) del electrodoméstico 
   y la cantidad de fallas fuera del período de garantía. 
   
   Si un año no tuvo fallas igual se debe informar con cantidades = 0.

   Mostrar lo siguiente: (50)

   ----------------------------------------------------------------------------------------------------------
   año			cant_fallas_garantia		cant_fallas_fuera_garantia
   ----------------------------------------------------------------------------------------------------------
   XXXX					XXX								XXX
   XXXX					XXX								XXX
*/


--1)
--Consulta que no cumple la regla de integridad

SELECT 
    pr.nro_reclamo, 
    pr.cod_parte_electrodomestico, 
    pr.cantidad AS cantidad_reemplazada, 
	pm.cod_modelo_electrodomestico,
    pm.cantidad AS cantidad_utilizada,
    e.cod_modelo_electrodomestico
FROM 
    dbo.partes_reemplazadas pr
JOIN 
    dbo.reclamos r ON pr.nro_reclamo = r.nro_reclamo
JOIN 
    dbo.electrodomesticos e ON r.nro_serie = e.nro_serie
LEFT JOIN 
    dbo.partes_modelos pm ON e.cod_modelo_electrodomestico = pm.cod_modelo_electrodomestico 
                           AND pr.cod_parte_electrodomestico = pm.cod_parte_electrodomestico
WHERE 
    pm.cod_parte_electrodomestico IS NULL 
    OR pr.cantidad > pm.cantidad

-- tablas y operaciones que afectan 
----------------------------------------------------------------------------------------------
-- tabla				insert			delete			update
----------------------------------------------------------------------------------------------
-- partes_remplazadas	SI				NO				SI->cod_parte_electrodomestico,nro_reclamo
----------------------------------------------------------------------------------------------
-- reclamos				NO				NO				SI->nro_serie
----------------------------------------------------------------------------------------------
-- electrodomesticos	NO				NO				SI->cod_modelo_electrodomestico
----------------------------------------------------------------------------------------------
-- partes_modelo		NO				SI				SI->cantidad,cod_partes_electrodomesticos
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--triggers----------------------------------------------------------------------------------------------
create or alter trigger  tiu_ri_partes_remplazadas
on partes_reemplazadas
for insert,update
as
begin
	if exists(
			SELECT 
			pr.nro_reclamo, 
			pr.cod_parte_electrodomestico, 
			pr.cantidad AS cantidad_reemplazada, 
			pm.cod_modelo_electrodomestico,
			pm.cantidad AS cantidad_utilizada,
			e.cod_modelo_electrodomestico
		FROM 
			inserted pr
		JOIN 
			dbo.reclamos r ON pr.nro_reclamo = r.nro_reclamo
		JOIN 
			dbo.electrodomesticos e ON r.nro_serie = e.nro_serie
		LEFT JOIN 
			dbo.partes_modelos pm ON e.cod_modelo_electrodomestico = pm.cod_modelo_electrodomestico 
								   AND pr.cod_parte_electrodomestico = pm.cod_parte_electrodomestico
		WHERE 
			pm.cod_parte_electrodomestico IS NULL 
			OR pr.cantidad > pm.cantidad
	)
	begin
	     raiserror('Esta ingresando partes o cantidad erroneas al modelo del electrodomestico', 16, 1)
		 rollback
	  end
end
go

-- Insertar datos en la tabla partes_reemplazadas
-- Este registro no cumple la regla de integridad (parte no pertenece al modelo)
INSERT INTO dbo.partes_reemplazadas (nro_reclamo, cod_parte_electrodomestico, cantidad)
VALUES 
(1, 'P002', 3)  -- La heladera (MOD1) usa solo 2 filtros (P002) pero se intentan reemplazar 3

-- Insertar datos en la tabla partes_reemplazadas
-- Reclamo correcto
INSERT INTO dbo.partes_reemplazadas (nro_reclamo, cod_parte_electrodomestico, cantidad)
VALUES 
(2, 'P002', 1),	 -- El aire acondicionado (MOD2) usa 1 filtro (P002) y se reemplaza 1 filtro (correcto)
(3, 'P001', 1)  --utiliza una parte que no existe

create or alter trigger tu_ri_partes_modelo
on partes_modelos
for update
as
begin	   	
	if UPDATE(cod_parte_electrodomestico) or UPDATE(cod_modelo_electrodomestico) or UPDATE(cantidad)
   begin
	   raiserror ('Esa opreacion no esta permitida', 16, 1)
	   rollback
	end
end
go

CREATE or alter TRIGGER td_ri_partes_modelos
ON partes_modelos
FOR DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN dbo.partes_reemplazadas pr ON d.cod_parte_electrodomestico = pr.cod_parte_electrodomestico
    )
    BEGIN
        RAISERROR ('No se puede eliminar la parte del modelo porque está registrada como reemplazada en algún reclamo.', 16, 1)
        ROLLBACK
    END
END
go

create or alter trigger tu_ri_electrodomesticos
on electrodomesticos
for update
as
begin	   	
	if UPDATE(cod_modelo_electrodomestico)
   begin
	   raiserror ('Esa opreacion no esta permitida', 16, 1)
	   rollback
	end
end
go

create or alter trigger tu_ri_reclamos
on reclamos
for update
as
begin	   	
	if UPDATE(nro_serie)
   begin
	   raiserror ('Esa opreacion no esta permitida', 16, 1)
	   rollback
	end
end
go
--triggers---------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

-- PUNTOS: 50


/*
2. Programar un procedimiento almacenado que reciba como argumento el identificador de una parte, y un período de años para
   analizar (año_desde y año_hasta), y devuelva, por cada año, la cantidad de fallas que ha tenido esa parte (reclamos donde 
   se haya reemplazado esa parte) dentro del período de garantía (se cuenta desde la fecha de venta al cliente) del electrodoméstico 
   y la cantidad de fallas fuera del período de garantía. 
   
   Si un año no tuvo fallas igual se debe informar con cantidades = 0.

   Mostrar lo siguiente: (50)

   ----------------------------------------------------------------------------------------------------------
   año			cant_fallas_garantia		cant_fallas_fuera_garantia
   ----------------------------------------------------------------------------------------------------------
   XXXX					XXX								XXX
   XXXX					XXX								XXX
*/
-------------------------------------------------------------------------------------------------------

CREATE or alter PROCEDURE sp_cantidad_fallas_por_parte
    @cod_parte_electrodomestico VARCHAR(10),
    @anio_desde INT,
    @anio_hasta INT
AS
BEGIN
    -- Crear una tabla temporal para almacenar los años del período
    CREATE TABLE #Anos (
        anio INT
    )

    -- Insertar los años en la tabla temporal
    DECLARE @anio INT = @anio_desde
    WHILE @anio <= @anio_hasta
    BEGIN
        INSERT INTO #Anos (anio) VALUES (@anio)
        SET @anio = @anio + 1
    END

    -- Crear una tabla temporal para almacenar los resultados
    CREATE TABLE #FallasPorAno (
        anio INT,
        cantidad_fallas_dentro_garantia INT,
        cantidad_fallas_fuera_garantia INT
    )

    -- Insertar la cantidad de fallas por año en la tabla temporal
    INSERT INTO #FallasPorAno (anio, cantidad_fallas_dentro_garantia, cantidad_fallas_fuera_garantia)
    SELECT
        a.anio,
        ISNULL(f.cantidad_fallas_dentro_garantia, 0) AS cantidad_fallas_dentro_garantia,
        ISNULL(f.cantidad_fallas_fuera_garantia, 0) AS cantidad_fallas_fuera_garantia
    FROM
        #Anos a
    LEFT JOIN (
        SELECT
            YEAR(r.fecha_reclamo) AS anio,
            COUNT(CASE WHEN DATEDIFF(MONTH, e.fecha_venta_cliente, r.fecha_reclamo) <= me.meses_garantia THEN 1 ELSE NULL END) AS cantidad_fallas_dentro_garantia,
            COUNT(CASE WHEN DATEDIFF(MONTH, e.fecha_venta_cliente, r.fecha_reclamo) > me.meses_garantia THEN 1 ELSE NULL END) AS cantidad_fallas_fuera_garantia
        FROM
            dbo.reclamos r
        JOIN
            dbo.partes_reemplazadas pr ON r.nro_reclamo = pr.nro_reclamo
        JOIN
            dbo.electrodomesticos e ON r.nro_serie = e.nro_serie
        JOIN
            dbo.modelos_electrodomesticos me ON e.cod_modelo_electrodomestico = me.cod_modelo_electrodomestico
        WHERE
            pr.cod_parte_electrodomestico = @cod_parte_electrodomestico
            AND YEAR(r.fecha_reclamo) BETWEEN @anio_desde AND @anio_hasta
        GROUP BY
            YEAR(r.fecha_reclamo)
    ) f ON a.anio = f.anio

    -- Seleccionar los resultados de la tabla temporal
    SELECT * FROM #FallasPorAno

    -- Eliminar las tablas temporales
    DROP TABLE #FallasPorAno
    DROP TABLE #Anos
END

execute sp_cantidad_fallas_por_parte 'P002', 2023, 2024

-- PUNTOS: 50

-- PUNTAJE TOTAL: 100


