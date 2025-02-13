/*
INGENIERIA INFORMATICA - SISTEMAS DE BASES DE DATOS � EXAMEN FINAL

Una empresa se dedica a la gesti�n de eventos. 

Cada evento es organizado por una o m�s empresas y cada evento adem�s, puede tener uno o varios sponsors o no tener ninguno. 
Un evento que a�n no tiene registradas las empresas organizadoras no puede tener registrado sus sponsors.
Un sponsor no puede ser ninguna de las empresas que organizan el evento. O sea, en cada evento, una empresa no puede ser organizadora y sponsor.
Un evento tiene como informaci�n: Un identificador �nico, denominaci�n, tipo, fecha, hora de inicio, hora de finalizaci�n y costo (puede ser nulo, lo que indicar�a que el evento no tiene costo).
Si un interesado a un evento se quiere inscribir en otro, el sistema debiera tomar sus datos de la base de datos sin necesidad de que deba informarlos nuevamente. La identificaci�n de las personas se realiza a trav�s del tipo y n�mero de documento. Los datos que se deben registrar son: apellido, nombre, tipo y n�mero de documento, tel�fono e email.
De la inscripci�n debe registrarse, la persona, la fecha de inscripci�n, si es invitado o no y si est� dado de baja o no. Adem�s, se puede registrar si asisti� al evento o no.
Para aquellos eventos con costo, los inscriptos no invitados, deben abonar en uno o varios pagos el costo del evento. De esta informaci�n se debe registrar, la fecha del pago, el importe y el n�mero de recibo.
Un inscripto est� confirmado solo si est� invitado o si el evento no tiene costo o si ha pagado el costo completo del evento.
La informaci�n de asistencia solo se podr� registrar para los inscriptos confirmados y no dados de baja. Un inscripto no confirmado o dado de baja tendr� informaci�n de asistencia nula.

Se solicita: 

1.	Elaborar un modelo l�gico de datos normalizado hasta 4FN �SIN REDUNDANCIAS�. (25)

2.	Implementar la base de datos con todas sus reglas de integridad declarativas e indicar las reglas de integridad que no pueden implementarse en forma declarativa. (25)

3.	Agregar a la tabla de inscripciones la columna �confirmado�, obligatoria, con valores �S� o �N� y valor por defecto �N�. Esta columna agrega redundancia al modelo por lo que se deber�n determinar y programar los triggers que aseguren la consistencia. (25)
4.	Programar un procedimiento almacenado que recibe como argumentos: el identificador del evento y el argumento �cuales� con valores posibles (T: Todos, P: Pendientes, C: Confirmados, I: Invitados, B: Dados de baja, A: Asistieron). Si ese argumento no es informado se debe tomar con el valor �T�.
El procedimiento debe devolver la lista de los inscriptos al evento solicitado que cumplen con el criterio de selecci�n indicado en el argumento �cuales�.
Tipo_documento	Nro_documento	Apellido	Nombre	Estado	deuda
Xxx	xxxxxxxx	Xxxxxxxxxxxxx	xxxxxxxxxxxxx	Xxxxxxxx	xxxx.xx
Xxx	xxxxxxxx	Xxxxxxxxxxxxx	xxxxxxxxxxxxx	Xxxxxxxx	xxxx.xx
Xxx	xxxxxxxx	Xxxxxxxxxxxxx	xxxxxxxxxxxxx	Xxxxxxxx	xxxx.xx
Xxx	xxxxxxxx	Xxxxxxxxxxxxx	xxxxxxxxxxxxx	Xxxxxxxx	xxxx.xx

Donde, estado es la denominaci�n del estado (Pendiente, Confirmado, Baja, Asisti�, Invitado) y la deuda solo se deber� mostrar si el estado es pendiente. (25)

*/


drop table Pago
drop table Inscripci�n
drop table Persona
drop table EventoEntidad
drop table Entidad
drop table Evento
go
-- Tabla Entidad
CREATE TABLE Entidad (
    NumEntidad INT PRIMARY KEY,
    Nombre NVARCHAR(255) NOT NULL,
    Direcci�n NVARCHAR(255),
    Tel�fono NVARCHAR(20),
    Email NVARCHAR(255)
);

-- Tabla Evento
CREATE TABLE Evento (
    NumEvento INT PRIMARY KEY,
    Denominaci�n NVARCHAR(255) NOT NULL,
    Tipo NVARCHAR(100) NOT NULL,
    Fecha DATE NOT NULL,
    HoraInicio TIME NOT NULL,
    HoraFin TIME NOT NULL,
    Costo DECIMAL(10, 2)
);

-- Tabla Persona
CREATE TABLE Persona (
	TipoDoc NVARCHAR(10) NOT NULL,
	NumDoc NVARCHAR(20) NOT NULL,
    Apellido NVARCHAR(255) NOT NULL,
    Nombre NVARCHAR(255) NOT NULL,
    Tel�fono NVARCHAR(20),
    Email NVARCHAR(255),
    UNIQUE (TipoDoc, NumDoc),
	PRIMARY KEY (NumDoc, TipoDoc)
);

-- Tabla Inscripci�n
CREATE TABLE Inscripci�n (
    TipoDoc NVARCHAR(10),
	NumDoc NVARCHAR(20),
    NumEvento INT,
    FechaInscripci�n DATE NOT NULL,
    Invitado BIT NOT NULL,
    DadoDeBaja BIT NOT NULL,
    Asisti� BIT,
    FOREIGN KEY (TipoDoc,NumDoc) REFERENCES Persona(TipoDoc,NumDoc),
    FOREIGN KEY (NumEvento) REFERENCES Evento(NumEvento),
    UNIQUE (TipoDoc,NumDoc, NumEvento),
	CHECK (Invitado IN (0, 1)),
    CHECK (DadoDeBaja IN (0, 1)),
    CHECK (Asisti� IN (0, 1))
);

-- Tabla Pago
CREATE TABLE Pago (
    NumPago INT,
    TipoDoc NVARCHAR(10),
	NumDoc NVARCHAR(20),
    NumEvento INT,
    FechaPago DATE NOT NULL,
    Importe DECIMAL(10, 2) NOT NULL,
    NumeroRecibo NVARCHAR(50),
    FOREIGN KEY (TipoDoc,NumDoc, NumEvento) REFERENCES Inscripci�n(TipoDoc,NumDoc, NumEvento),
	PRIMARY KEY (NumPago, TipoDoc,NumDoc, NumEvento),
	CHECK (Importe > 0)
);

-- Tabla EventoEntidad
CREATE TABLE EventoEntidad (
    NumEvento INT,
    NumEntidad INT,
    EsSponsor BIT NOT NULL,
    PRIMARY KEY (NumEvento, NumEntidad),
    FOREIGN KEY (NumEvento) REFERENCES Evento(NumEvento),
    FOREIGN KEY (NumEntidad) REFERENCES Entidad(NumEntidad),
    CHECK (EsSponsor IN (0, 1))
);

ALTER TABLE Inscripci�n
ADD Confirmado CHAR(1) NOT NULL DEFAULT 'N' CHECK (Confirmado IN ('S', 'N'));

select * from Inscripci�n

INSERT INTO Entidad (NumEntidad, Nombre, Direcci�n, Tel�fono, Email) VALUES
(1, 'Empresa A', 'Direccion A', '123456789', 'empresaA@example.com'),
(2, 'Empresa B', 'Direccion B', '987654321', 'empresaB@example.com');

-- Insertar datos en la tabla Evento
INSERT INTO Evento (NumEvento, Denominaci�n, Tipo, Fecha, HoraInicio, HoraFin, Costo) VALUES
(1, 'Evento Gratuito', 'Tipo 1', '2024-08-01', '10:00', '12:00', NULL),
(2, 'Evento Pago', 'Tipo 2', '2024-08-02', '14:00', '16:00', 100.00);

-- Insertar datos en la tabla Persona
INSERT INTO Persona (TipoDoc, NumDoc, Apellido, Nombre, Tel�fono, Email) VALUES
('DNI', '12345678', 'Perez', 'Juan', '111111111', 'juan.perez@example.com'),
('DNI', '87654321', 'Gomez', 'Maria', '222222222', 'maria.gomez@example.com');

-- Insertar datos en la tabla Inscripci�n
INSERT INTO Inscripci�n (TipoDoc, NumDoc, NumEvento, FechaInscripci�n, Invitado, DadoDeBaja, Asisti�, Confirmado) VALUES
('DNI', '12345678', 1, '2024-07-01', 1, 0, 1, 'S'), -- Cumple la condici�n: invitado y confirmado
('DNI', '87654321', 2, '2024-07-02', 0, 0, 0, 'N'), -- No cumple la condici�n: no ha pagado el costo
('DNI', '87654321', 1, '2024-07-03', 0, 0, 0, 'S'), -- No cumple la condici�n: evento gratuito, pero no est� confirmado
('DNI', '12345678', 2, '2024-07-04', 0, 0, 0, 'N'); -- Cumple la condici�n: no ha pagado el costo

-- Insertar datos en la tabla Pago
INSERT INTO Pago (NumPago, TipoDoc, NumDoc, NumEvento, FechaPago, Importe, NumeroRecibo) VALUES
(1, 'DNI', '12345678', 2, '2024-07-05', 50.00, 'R001'), -- Pago parcial
(2, 'DNI', '12345678', 2, '2024-07-06', 50.00, 'R002'); -- Pago completo

-- Insertar datos en la tabla EventoEntidad
INSERT INTO EventoEntidad (NumEvento, NumEntidad, EsSponsor) VALUES
(1, 1, 0), -- Empresa A organiza Evento Gratuito
(2, 1, 1), -- Empresa A es sponsor de Evento Pago
(2, 2, 0); -- Empresa B organiza Evento Pago


select * from Persona
select * from Evento
select * from Inscripci�n
select * from Pago
/*Modificacion pedida*/
ALTER TABLE Inscripci�n
ADD Confirmado CHAR(1) NOT NULL DEFAULT 'N' CHECK (Confirmado IN ('S', 'N'));
/*Consulta para ver quienes no cumplen la regla de integridad*/
--Consulta
SELECT 
    I.TipoDoc,
    I.NumDoc,
    I.NumEvento,
    I.Invitado,
    I.Confirmado,
    E.Costo,
    COALESCE(SUM(P.Importe),0) AS TotalPagado
FROM 
    Inscripci�n I
JOIN 
    Evento E ON I.NumEvento = E.NumEvento
LEFT JOIN 
    Pago P ON I.TipoDoc = P.TipoDoc AND I.NumDoc = P.NumDoc AND I.NumEvento = P.NumEvento
GROUP BY 
    I.TipoDoc,
    I.NumDoc,
    I.NumEvento,
    I.Invitado,
    I.Confirmado,
    E.Costo
HAVING 
    (I.Invitado = 0 AND E.Costo IS NOT NULL AND COALESCE(SUM(P.Importe),0) < E.Costo AND I.Confirmado = 'S') --No es invitado, tiene costo, costo no esta pagado, confirmado=S
    OR
	(I.Invitado = 0 AND E.Costo IS NOT NULL AND COALESCE(SUM(P.Importe),0) = E.Costo AND I.Confirmado = 'N') --No es invitado, tiene costo, costo no esta pagado, confirmado=N
    OR
    (I.Invitado = 0 AND E.Costo IS NULL AND I.Confirmado <> 'S') --No es invitado, No tiene costo, Confirmado=N
    OR 
    (I.Invitado = 1 AND I.Confirmado <> 'S');--Son invitados, Confirmados=N

/*Tabla del trigger*/
----------------------------------------------------------------------------------------------
-- tabla				insert			delete			update
----------------------------------------------------------------------------------------------
-- Inscripciones		SI				NO				SI
----------------------------------------------------------------------------------------------
-- Eventos				NO				NO				SI	si, cambia el costo del evento
----------------------------------------------------------------------------------------------
-- Pagos				SI				Si				SI
--				(Ver si pago el costo) (Ver si no		(Ver que no rompa el pago del costo) /*Se pueden bloquear el borrado y actulizacion del monto*/
--										rompe el pago del costo)
--										
----------------------------------------------------------------------------------------------

/*TRIGGERS*/
create or alter trigger tiu_ri_inscripcion
on Inscripci�n
for insert, update
as
begin
	 if exists (SELECT I.TipoDoc,I.NumDoc,I.NumEvento,I.Invitado,I.Confirmado,E.Costo,COALESCE(SUM(P.Importe),0) AS TotalPagado
			FROM 
				inserted I
			JOIN 
				Evento E ON I.NumEvento = E.NumEvento
			LEFT JOIN 
				Pago P ON I.TipoDoc = P.TipoDoc AND I.NumDoc = P.NumDoc AND I.NumEvento = P.NumEvento
			GROUP BY I.TipoDoc,I.NumDoc,I.NumEvento,I.Invitado,I.Confirmado,E.Costo
			HAVING 
				(I.Invitado = 0 AND E.Costo IS NOT NULL AND COALESCE(SUM(P.Importe),0) < E.Costo AND I.Confirmado = 'S') --No es invitado, tiene costo, costo no esta pagado, confirmado=S
				OR
				(I.Invitado = 0 AND E.Costo IS NOT NULL AND COALESCE(SUM(P.Importe),0) = E.Costo AND I.Confirmado = 'N') --No es invitado, tiene costo, costo no esta pagado, confirmado=N
				OR
				(I.Invitado = 0 AND E.Costo IS NULL AND I.Confirmado <> 'S') --No es invitado, No tiene costo, Confirmado=N
				OR 
				(I.Invitado = 1 AND I.Confirmado <> 'S')/*Son invitados, Confirmados=N*/)
	 begin
	     raiserror('Verificar confirmacion', 16, 1)
		 rollback
	  end
end
go

create or alter trigger tu_ri_evento
on Evento
for update
as
begin	   	
	if UPDATE(Costo)
   begin
	   raiserror ('Esa opreacion no esta permitida', 16, 1)
	   rollback
	end
end
go

CREATE or alter TRIGGER trg_Pago_AfterInsertUpdate
ON Pago
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar las reglas de integridad y actualizar la columna Confirmado en Inscripci�n
    UPDATE I
    SET Confirmado = 'S'
    FROM Inscripci�n I
    JOIN Evento E ON I.NumEvento = E.NumEvento
    WHERE I.Invitado = 0
      AND E.Costo IS NOT NULL
      AND I.Confirmado = 'N'
      AND EXISTS (
          SELECT 1
          FROM (
              SELECT P.TipoDoc, P.NumDoc, P.NumEvento, COALESCE(SUM(P.Importe), 0) AS TotalPagado
              FROM Pago P
              GROUP BY P.TipoDoc, P.NumDoc, P.NumEvento
              HAVING COALESCE(SUM(P.Importe), 0) >= E.Costo
          ) AS PagoTotal
          WHERE PagoTotal.TipoDoc = I.TipoDoc
            AND PagoTotal.NumDoc = I.NumDoc
            AND PagoTotal.NumEvento = I.NumEvento
      );
END;


/*GPT*/
CREATE or alter TRIGGER trg_Inscripci�n_Insert
ON Inscripci�n
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar la columna Confirmado
    UPDATE I
    SET Confirmado = 
        CASE
            WHEN I.Invitado = 1 THEN 'S'
            WHEN E.Costo IS NULL THEN 'S'
            WHEN E.Costo IS NOT NULL AND (
                SELECT COALESCE(SUM(P.Importe), 0)
                FROM Pago P
                WHERE P.TipoDoc = I.TipoDoc AND P.NumDoc = I.NumDoc AND P.NumEvento = I.NumEvento
            ) >= E.Costo THEN 'S'
            ELSE 'N'
        END
    FROM Inscripci�n I
    JOIN Evento E ON I.NumEvento = E.NumEvento
    WHERE EXISTS (SELECT 1 FROM inserted ins WHERE ins.TipoDoc = I.TipoDoc AND ins.NumDoc = I.NumDoc AND ins.NumEvento = I.NumEvento);
END;

CREATE or alter TRIGGER trg_Inscripci�n_Update
ON Inscripci�n
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Actualizar la columna Confirmado
    UPDATE I
    SET Confirmado = 
        CASE
            WHEN I.Invitado = 1 THEN 'S'
            WHEN E.Costo IS NULL THEN 'S'
            WHEN E.Costo IS NOT NULL AND (
                SELECT COALESCE(SUM(P.Importe), 0)
                FROM Pago P
                WHERE P.TipoDoc = I.TipoDoc AND P.NumDoc = I.NumDoc AND P.NumEvento = I.NumEvento
            ) >= E.Costo THEN 'S'
            ELSE 'N'
        END
    FROM Inscripci�n I
    JOIN Evento E ON I.NumEvento = E.NumEvento
    WHERE EXISTS (SELECT 1 FROM inserted ins WHERE ins.TipoDoc = I.TipoDoc AND ins.NumDoc = I.NumDoc AND ins.NumEvento = I.NumEvento);
END;
/*GPT*/

/*TRIGGERS*/
/*Procedimiento Almacenado*/
CREATE or alter PROCEDURE sp_ObtenerInscriptos
    @NumEvento INT,
    @cuales CHAR(1) = 'T' -- Valor por defecto 'T'
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        I.TipoDoc,
        I.NumDoc,
        P.Apellido,
        P.Nombre,
        CASE 
            WHEN I.DadoDeBaja = 1 THEN 'Baja'
            WHEN I.Asisti� = 1 THEN 'Asisti�'
            WHEN I.Invitado = 1 THEN 'Invitado'
            WHEN I.Confirmado = 'S' THEN 'Confirmado'
            WHEN I.Confirmado = 'N' THEN 'Pendiente'
        END AS Estado,
        CASE 
            WHEN E.Costo IS NOT NULL AND COALESCE(SUM(PA.Importe), 0) < E.Costo THEN E.Costo - COALESCE(SUM(PA.Importe), 0)
            ELSE 0
        END AS Deuda
    FROM 
        Inscripci�n I
    JOIN 
        Persona P ON I.TipoDoc = P.TipoDoc AND I.NumDoc = P.NumDoc
    JOIN 
        Evento E ON I.NumEvento = E.NumEvento
    LEFT JOIN 
        Pago PA ON I.TipoDoc = PA.TipoDoc AND I.NumDoc = PA.NumDoc AND I.NumEvento = PA.NumEvento
    WHERE 
        I.NumEvento = @NumEvento
        AND (
			@cuales = 'T'
			OR (@cuales = 'C' AND I.Confirmado = 'S')
            OR (@cuales = 'P' AND I.Confirmado = 'N' AND I.Invitado = 0 AND I.DadoDeBaja = 0 AND I.Asisti� = 0)
            OR (@cuales = 'I' AND I.Invitado = 1)
            OR (@cuales = 'B' AND I.DadoDeBaja = 1)
            OR (@cuales = 'A' AND I.Asisti� = 1)

        )
    GROUP BY 
        I.TipoDoc,
        I.NumDoc,
        P.Apellido,
        P.Nombre,
        I.DadoDeBaja,
        I.Asisti�,
        I.Invitado,
        I.Confirmado,
        E.Costo
    ORDER BY 
        P.Apellido, P.Nombre;
END;
GO

EXECUTE sp_ObtenerInscriptos 1, 'A'

select * from Inscripci�n



