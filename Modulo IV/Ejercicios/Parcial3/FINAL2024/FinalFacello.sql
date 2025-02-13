drop table Movimientos
drop table TiposMovimiento
drop table Usuarios
drop table Estaciones
drop table HistorialUbicacion
drop table Bicicletas
drop table Configuraciones

CREATE TABLE Estaciones (
    NumEstacion INT PRIMARY KEY,
    Nombre NVARCHAR(100) UNIQUE NOT NULL,
    Descripcion NVARCHAR(255),
    CoordenadasGPS NVARCHAR(50) NOT NULL,
    CapacidadMaxima INT NOT NULL CHECK (CapacidadMaxima > 0)
);

CREATE TABLE Bicicletas (
    NumBicicletas INT PRIMARY KEY,
    FechaUltimoMantenimiento DATE,
    EnMantenimiento CHAR(1) NOT NULL CHECK (EnMantenimiento IN ('S', 'N'))
);

CREATE TABLE Usuarios (
	TipoDocumento NVARCHAR(20) NOT NULL,
    NumeroDocumento NVARCHAR(20) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    PaisOrigen NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Telefono NVARCHAR(20),
    DatosTarjeta NVARCHAR(100),
    Deuda INT NOT NULL DEFAULT 0 CHECK (Deuda >= 0),
    UNIQUE (TipoDocumento, NumeroDocumento),
	primary key (TipoDocumento, NumeroDocumento)
);

CREATE TABLE TiposMovimiento (
    CodTipo INT PRIMARY KEY,
    Descripcion NVARCHAR(50) NOT NULL
);

CREATE TABLE Movimientos (
    NumMovimiento INT NOT NULL,
    NumBicicletas INT NOT NULL,
    NumEstacion INT NOT NULL,
    TipoDocumento NVARCHAR(20) NULL,
    NumeroDocumento NVARCHAR(20) NULL,
    EstacionFinID INT NULL,
    FechaHoraInicio DATETIME NOT NULL,
    FechaHoraFin DATETIME,
    DistanciaRecorrida DECIMAL(10, 2) NULL CHECK (DistanciaRecorrida >= 0),
    Costo DECIMAL(10, 2) NULL CHECK (Costo >= 0),
    CodTipo INT NOT NULL,
    FOREIGN KEY (NumBicicletas) REFERENCES Bicicletas(NumBicicletas),
    FOREIGN KEY (NumEstacion) REFERENCES Estaciones(NumEstacion),
    FOREIGN KEY (TipoDocumento, NumeroDocumento) REFERENCES Usuarios(TipoDocumento, NumeroDocumento),
    FOREIGN KEY (EstacionFinID) REFERENCES Estaciones(NumEstacion),
    FOREIGN KEY (CodTipo) REFERENCES TiposMovimiento(CodTipo),
	primary key (NumBicicletas, NumEstacion, NumMovimiento)
);

CREATE TABLE HistorialUbicacion (
    NumHistorial INT NOT NULL,
    NumBicicleta INT NOT NULL,
    CoordenadasGPS NVARCHAR(50) NOT NULL,
    FechaHora DATETIME NOT NULL,
    NivelCargaBateria DECIMAL(5, 2) NOT NULL CHECK (NivelCargaBateria BETWEEN 0 AND 100),
    FOREIGN KEY (NumBicicleta) REFERENCES Bicicletas(NumBicicletas),
	primary key (NumHistorial, NumBicicleta)
);

CREATE TABLE Configuraciones (
    CodConfiguracion NVARCHAR(5) PRIMARY KEY,
    DescConfiguracion NVARCHAR(50) NOT NULL,
    Valor DECIMAL(10,2) NOT NULL 
	--Configura la carga minima de la bateria para poder utilizar la bici
	--Configura la regularidad en minutos con la que se registran los datos de la bici
	--Configurar la cantidad de viajes no pagados que puede tener un cliente antes de ser bloqueado
	--Configurar el multiplicador del costo del viaje
);

/*
3.	El atributo “en_mantenimiento” en la entidad “bicicletas” con valor S o N es redundante teniendo en 
cuenta los registros de mantenimiento. Programar los triggers que aseguren que dicho estado es consistente*/


/*Hay que hacer que cuando se registre un movimiento de mantemiento se actualice el valor de EnMantenimiento, deberia pasar a S, y cuando se termina ese
movimiento se dbeeria pasar a N, se podria decir que el update e insert de bicletas requiere de una revision en cuanto al atributo EnMantenimineto*/
/*En mi caso la bicicleta entra en mantenimiento con una FechaHoraInicio y una EstacionInicio (de donde sale), y se finaliza el mantenimiento cuando
vuelve a otra estacion, por lo que los datos FechaHoraFin y EstacionFin indican el finalizado del mantenimiento y la reinsercion a otra estacion destino*/

/*Consulta para el trigger*/

SELECT 
    b.NumBicicletas, 
    b.EnMantenimiento,
    m.NumEstacion as EstacionInicio,
    m.EstacionFinID
FROM 
    Bicicletas b
LEFT JOIN 
    Movimientos m ON b.NumBicicletas = m.NumBicicletas --compara por identificador de bicis
                  AND m.CodTipo = (SELECT CodTipo FROM TiposMovimiento WHERE Descripcion = 'Mantenimiento') --limita a mantenimientos
                  AND m.FechaHoraFin IS NULL --no finalizo el mantenimiento
WHERE 
    (b.EnMantenimiento = 'S' AND m.NumMovimiento IS NULL) --Dice que esta en mantenimiento pero no tiene ningun mantenimiento registrado
    OR (b.EnMantenimiento = 'N' AND EXISTS ( --Dice que no esta en mantenimieno pero existe un mantenimiento finalizado
        SELECT 1
        FROM Movimientos m2
        WHERE m2.NumBicicletas = b.NumBicicletas 
          AND m2.CodTipo = (SELECT CodTipo FROM TiposMovimiento WHERE Descripcion = 'Mantenimiento') --limita mantenimientos
          AND m2.FechaHoraFin IS NULL --no tiene el mantenimiento finalizado
    ));


-- tablas y operaciones que afectan 
----------------------------------------------------------------------------------------------
-- tabla				insert			delete			update
----------------------------------------------------------------------------------------------
-- Bicicletas			SI				NO				SI
--					(Si se inserta una 				(Si se cambia manualmente a S o N dependiendo de los movimientos)
--					bici con S)
----------------------------------------------------------------------------------------------
-- Movimientos			SI				SI				SI
--				(si se inserta un     (si se borra     (Si se cierra el mantenimiento o si se cambia el tipo de movimiento o identificador de bici)
--mantenimiento actualizar la tabla)  mantenimiento en curso)
----------------------------------------------------------------------------------------------

/*Triggers*/

CREATE or alter TRIGGER trg_UpdateEnMantenimiento
ON Movimientos
for INSERT, UPDATE
AS
BEGIN
    -- Actualiza EnMantenimiento a 'S' para bicicletas que tienen un movimiento de mantenimiento en proceso
    UPDATE b
    SET b.EnMantenimiento = 'S'
    FROM Bicicletas b
    WHERE EXISTS (
        SELECT 1
        FROM Movimientos m
        WHERE m.NumBicicletas = b.NumBicicletas
          AND m.CodTipo = (SELECT CodTipo FROM TiposMovimiento WHERE Descripcion = 'Mantenimiento')
          AND m.FechaHoraFin IS NULL
    )
    AND b.EnMantenimiento <> 'S';

    -- Actualiza EnMantenimiento a 'N' para bicicletas que no tienen movimientos de mantenimiento en proceso
    UPDATE b
    SET b.EnMantenimiento = 'N'
    FROM Bicicletas b
    WHERE NOT EXISTS (
        SELECT 1
        FROM Movimientos m
        WHERE m.NumBicicletas = b.NumBicicletas
          AND m.CodTipo = (SELECT CodTipo FROM TiposMovimiento WHERE Descripcion = 'Mantenimiento')
          AND m.FechaHoraFin IS NULL
    )
    AND b.EnMantenimiento <> 'N';
END;
GO


create or alter trigger tu_ri_movimientos
on Movimientos
for update
as
begin	   	
	if UPDATE(CodTipo) or UPDATE(NumBicicletas)
   begin
	   raiserror ('Esa opreacion no esta permitida', 16, 1)
	   rollback
	end
end
go

CREATE TRIGGER trg_CheckEnMantenimientoOnInsert
ON Bicicletas
INSTEAD OF INSERT
AS
BEGIN
    -- Verifica que todos los registros nuevos tengan EnMantenimiento = 'N'
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.EnMantenimiento <> 'N'
    )
    BEGIN
        RAISERROR('El atributo EnMantenimiento debe ser ''N'' para los nuevos registros en la tabla Bicicletas.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Si la verificación pasa, inserta los registros nuevos
    INSERT INTO Bicicletas (NumBicicletas, FechaUltimoMantenimiento, EnMantenimiento)
    SELECT NumBicicletas, FechaUltimoMantenimiento, EnMantenimiento
    FROM inserted;
END;
GO

create or alter trigger tu_ri_Bicicletas
on Bicicletas
for update
as
begin	   	
	if UPDATE(EnMantenimiento)
   begin
	   raiserror ('Esa opreacion no esta permitida', 16, 1)
	   rollback
	end
end
go

CREATE TRIGGER trg_PreventDeleteMovimientos
ON Movimientos
INSTEAD OF DELETE
AS
BEGIN
    -- Genera un error si se intenta eliminar un registro
    RAISERROR('No se permite eliminar registros de la tabla Movimientos.', 16, 1);
    
    -- Opcionalmente, podrías registrar el intento de eliminación en una tabla de auditoría aquí

    -- No realiza la eliminación, por lo que los registros permanecen en la tabla
END;
GO

/*
4.	Programar un procedimiento almacenado que recibe el identificador de una estación y devuelva 
como resultado todas las bicicletas que estuvieron estacionadas en dicha estación en esa fecha con el 
estado actual, el nivel de batería (salvo cuando está en mantenimiento o reubicando) y las coordenadas 
(salvo cuando está en mantenimiento) */

CREATE PROCEDURE sp_ObtenerEstadoBicicletas
    @NumEstacion INT,
    @FechaActual DATE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH MovimientoEstado AS (
        SELECT 
            m.NumBicicletas,
            m.CodTipo,
            m.FechaHoraFin,
            ROW_NUMBER() OVER (PARTITION BY m.NumBicicletas ORDER BY m.FechaHoraInicio DESC) AS rn
        FROM 
            Movimientos m
        WHERE 
            (m.NumEstacion = @NumEstacion AND m.FechaHoraInicio <= @FechaActual)
            OR (m.EstacionFinID = @NumEstacion AND (m.FechaHoraFin IS NULL OR m.FechaHoraFin >= @FechaActual))
    ),
    EstadoBicicletas AS (
        SELECT
            b.NumBicicletas,
            CASE
                WHEN m.CodTipo IS NOT NULL AND m.CodTipo = (SELECT CodTipo FROM TiposMovimiento WHERE Descripcion = 'Viaje') AND m.FechaHoraFin IS NULL THEN 'En uso'
                WHEN m.CodTipo IS NOT NULL AND m.CodTipo = (SELECT CodTipo FROM TiposMovimiento WHERE Descripcion = 'Mantenimiento') AND m.FechaHoraFin IS NULL THEN 'En Mantenimiento'
                WHEN m.CodTipo IS NOT NULL AND m.CodTipo = (SELECT CodTipo FROM TiposMovimiento WHERE Descripcion = 'Reubicacion') AND m.FechaHoraFin IS NULL THEN 'Reubicando'
                ELSE 'Estacionada'
            END AS Estado,
            h.NivelCargaBateria,
            h.CoordenadasGPS
        FROM 
            Bicicletas b
        LEFT JOIN 
            MovimientoEstado m ON b.NumBicicletas = m.NumBicicletas AND m.rn = 1
        LEFT JOIN 
            HistorialUbicacion h ON b.NumBicicletas = h.NumBicicleta
            AND h.FechaHora = (SELECT MAX(FechaHora) FROM HistorialUbicacion WHERE NumBicicleta = b.NumBicicletas AND FechaHora <= @FechaActual)
    )
    SELECT 
        NumBicicletas,
        Estado,
        NivelCargaBateria,
        CoordenadasGPS
    FROM 
        EstadoBicicletas
    WHERE 
        NumBicicletas IN (
            SELECT DISTINCT NumBicicletas 
            FROM Movimientos
            WHERE (NumEstacion = @NumEstacion AND FechaHoraInicio <= @FechaActual)
            OR (EstacionFinID = @NumEstacion AND FechaHoraFin IS NULL)
        )
END;
GO
