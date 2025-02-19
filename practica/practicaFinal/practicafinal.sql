/*
Un banco necesita gestionar créditos para la construcción de viviendas para lo cual requiere la implementación de una base de datos relacional. 
El proceso a modelar es el siguiente:
1) Una persona solicita un crédito para la construcción de una vivienda. Para ello debe presentar un proyecto de obra y un presupuesto.
2) El banco evalúa el proyecto y el presupuesto y decide si aprueba o rechaza el crédito.
3) Si el crédito es aprobado, el banco lo otorga en tramos de acuerdo a certificaciones de avance de obra. Cada certificación aprueba o no el avance requerido. Si se aprueba, entonces se libera el nuevo tramo del crédito, sino no.
4) El banco le crea una cuenta bancaria al cliente donde se le acreditará cada tramo del crédito y donde el banco hará los débitos correspondientes a las cuotas del crédito.
5) Apenas el crédito se aprueba y la cuenta es creada, el banco acredita el primer tramo del crédito en la cuenta del cliente.

Teniendo en cuenta el proceso descripto, se pide:
a) Registrar los siguientes datos de personas (Clientes ó garantes): 
-Identificador interno numérico autogenerado
-apellido
-nombre
-tipo de documento de identidad
-número de documento de identidad
-domicilio
-teléfonos
-Email.

b) Registrar la solicitud del crédito solicitado: 
-identificador interno numérico del crédito
-cliente que solicita
-monto solicitado
-fecha de solicitud
-garantes propuestos 
-proyecto de obra
-Estado (A: Aprobado, B: Rechazado)
-Fecha de resolución (de aprobación o rechazo) . 

c) En el caso de aprobación registrar un Crédito con los siguientes datos:
-Monto aprobado
-Gastos y comisiones (se necesita un detalle de cada gasto y comisión con el concepto y el importe correspondiente)
-Monto neto del crédito (corresponde al monto aprobado menos el total de gastos y comisiones)
-Lista de cuotas con su fecha de vencimiento, importe neto, intereses e importe total 
-Tramos del crédito (en cuantos tramos se entregará la suma aprobada neta) 

d) Para las certificaciones de avance de obra se debe registrar:
- Fecha y el resultado (avance aprobado o rechazado) y una observación.  

e) En la misma cuenta donde se acreditan los tramos del crédito se debitarán las cuotas correspondientes. Este débito se hará por el monto completo de la cuota. Es decir, no hay pagos parciales de cuotas. Se debe informar el tipo de movimiento, la fecha y el importe. 

Se solicita implementar la base de datos con todas las reglas de integridad declarativas en SQL Server
*/


/*
    Programar los triggers necesarios para controlar que la suma de los montos acreditados (en los Movimientos de la cuenta) de los tramos no supere el monto neto del crédito aprobado.
    ACLARACIÓN: Recordar que por cada acreditación de tramo se debe generar un movimiento en la cuenta del cliente con el tipo “Acreditación de tramo”.
*/


/*
    Programar un SELECT que muestre las cuotas impagas de cada crédito aprobado. 
*/



/*
    Programar un procedimiento almacenado que reciba el número de crédito como argumento y devuelva como resultado los siguientes datos del mismo: 
    a. Nro. de crédito 
    b. Fecha de solicitud 
    c. Estado (pendiente de aprobación, aprobado o rechazado) 
    d. Fecha de resolución (aprobación o rechazo) 
    e. Si el crédito está aprobado: 
        i. Monto aprobado 
        ii. Monto neto a acreditar 
        iii. Total acreditado hasta el momento 
        iv. Cantidad de tramos acreditados 
        v. Total de cuotas 
        vi. Total de cuotas pagadas 
        vii. Importe total de cuotas pagadas 
        viii. Total de cuotas pendientes 
        ix. Importe total de cuotas pendientes
*/



CREATE TABLE Persona (
    ID_Persona INT IDENTITY(1,1) PRIMARY KEY,
    Apellido VARCHAR(100) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Tipo_Documento VARCHAR(20) NOT NULL,
    Numero_Documento VARCHAR(20) UNIQUE NOT NULL,
    Domicilio VARCHAR(255) NOT NULL,
    Telefono VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Solicitud_Credito (
    ID_Solicitud_Credito INT IDENTITY(1,1) PRIMARY KEY,
    ID_Persona INT NOT NULL,
    Monto_Solicitado FLOAT NOT NULL CHECK (Monto_Solicitado > 0),
    Fecha_Solicitud DATE NOT NULL,
    Proyecto_Obra TEXT NOT NULL,
    Estado CHAR(1) NOT NULL CHECK (Estado IN ('A', 'B')),
    Fecha_Resolucion DATE,
    FOREIGN KEY (ID_Persona) REFERENCES Persona(ID_Persona) ON DELETE CASCADE
);

CREATE TABLE Garante_Credito (
    ID_Solicitud_Credito INT NOT NULL,
    ID_Persona INT NOT NULL,
    PRIMARY KEY (ID_Solicitud_Credito, ID_Persona),
    FOREIGN KEY (ID_Solicitud_Credito) REFERENCES Solicitud_Credito(ID_Solicitud_Credito) ON DELETE CASCADE,
    FOREIGN KEY (ID_Persona) REFERENCES Persona(ID_Persona)
);

CREATE TABLE Cuenta_Bancaria (
    ID_Cuenta INT IDENTITY(1,1) PRIMARY KEY,
    ID_Persona INT NOT NULL,
    Saldo FLOAT NOT NULL DEFAULT 0,
    FOREIGN KEY (ID_Persona) REFERENCES Persona(ID_Persona) ON DELETE CASCADE
);

CREATE TABLE Credito (
    ID_Credito INT IDENTITY(1,1) PRIMARY KEY,
    ID_Solicitud_Credito INT NOT NULL,
    Monto_Aprobado FLOAT NOT NULL CHECK (Monto_Aprobado > 0),
    Monto_Neto FLOAT NOT NULL CHECK (Monto_Neto >= 0),
    ID_Cuenta INT NOT NULL,
    FOREIGN KEY (ID_Solicitud_Credito) REFERENCES Solicitud_Credito(ID_Solicitud_Credito) ON DELETE CASCADE,
    FOREIGN KEY (ID_Cuenta) REFERENCES Cuenta_Bancaria(ID_Cuenta) 
);

CREATE TABLE Gasto (
    ID_Gasto INT IDENTITY(1,1) PRIMARY KEY,
    ID_Credito INT NOT NULL,
    Concepto VARCHAR(255) NOT NULL,
    Importe FLOAT NOT NULL CHECK (Importe > 0),
    FOREIGN KEY (ID_Credito) REFERENCES Credito(ID_Credito) ON DELETE CASCADE
);

CREATE TABLE Comision (
    ID_Comision INT IDENTITY(1,1) PRIMARY KEY,
    ID_Credito INT NOT NULL,
    Concepto VARCHAR(255) NOT NULL,
    Importe FLOAT NOT NULL CHECK (Importe > 0),
    FOREIGN KEY (ID_Credito) REFERENCES Credito(ID_Credito) ON DELETE CASCADE
);

CREATE TABLE Cuota (
    ID_Cuota INT IDENTITY(1,1) PRIMARY KEY,
    ID_Credito INT NOT NULL,
    Fecha_Vencimiento DATE NOT NULL,
    Importe_Neto FLOAT NOT NULL CHECK (Importe_Neto > 0),
    Intereses FLOAT NOT NULL CHECK (Intereses >= 0),
    Importe_Total FLOAT NOT NULL CHECK (Importe_Total>0),
    ID_Cuenta INT NOT NULL,
    FOREIGN KEY (ID_Credito) REFERENCES Credito(ID_Credito) ON DELETE CASCADE,
    FOREIGN KEY (ID_Cuenta) REFERENCES Cuenta_Bancaria(ID_Cuenta) 
);

CREATE TABLE Tramo (
    ID_Tramo INT IDENTITY(1,1) PRIMARY KEY,
    ID_Credito INT NOT NULL,
    Numero_Tramo INT NOT NULL CHECK (Numero_Tramo > 0),
    Monto_Tramo FLOAT NOT NULL CHECK (Monto_Tramo > 0),
    ID_Certificacion INT NULL,
    FOREIGN KEY (ID_Credito) REFERENCES Credito(ID_Credito) ON DELETE CASCADE
);



CREATE TABLE Movimiento (
    ID_Movimiento INT IDENTITY(1,1) PRIMARY KEY,
    ID_Credito INT NOT NULL,
    ID_Cuenta INT NOT NULL,
    Tipo_Movimiento VARCHAR(50) NOT NULL CHECK (Tipo_Movimiento IN ('Acreditación', 'Débito')),
    Fecha DATE NOT NULL,
    Importe FLOAT NOT NULL CHECK (Importe > 0),
    FOREIGN KEY (ID_Credito) REFERENCES Credito(ID_Credito) ON DELETE CASCADE,
    FOREIGN KEY (ID_Cuenta) REFERENCES Cuenta_Bancaria(ID_Cuenta) 
);


CREATE TABLE Certificacion (
    ID_Certificacion INT IDENTITY(1,1) PRIMARY KEY,
    ID_Tramo INT NOT NULL,
    ID_Credito INT NOT NULL,
    Fecha DATE NOT NULL,
    Resultado CHAR(1) NOT NULL CHECK (Resultado IN ('A', 'R')),
    Observacion TEXT,
    FOREIGN KEY (ID_Tramo) REFERENCES Tramo(ID_Tramo) ON DELETE CASCADE,
    FOREIGN KEY (ID_Credito) REFERENCES Credito(ID_Credito) 
);



-- Insertar personas (clientes y garantes)
INSERT INTO Persona (Apellido, Nombre, Tipo_Documento, Numero_Documento, Domicilio, Telefono, Email)
VALUES 
('Gonzalez', 'Juan', 'DNI', '12345678', 'Calle Falsa 123', '1122334455', 'juan@example.com'),
('Perez', 'María', 'DNI', '87654321', 'Av. Siempre Viva 742', '1133445566', 'maria@example.com'),
('Lopez', 'Carlos', 'DNI', '56781234', 'San Martín 555', '1144556677', 'carlos@example.com');

-- Insertar solicitudes de crédito
INSERT INTO Solicitud_Credito (ID_Persona, Monto_Solicitado, Fecha_Solicitud, Proyecto_Obra, Estado, Fecha_Resolucion)
VALUES 
(1, 500000, '2024-02-01', 'Construcción de vivienda unifamiliar', 'A', '2024-02-10'),
(2, 300000, '2024-02-05', 'Remodelación de casa', 'B', '2024-02-12');

-- Insertar garantes para las solicitudes de crédito
INSERT INTO Garante_Credito (ID_Solicitud_Credito, ID_Persona)
VALUES 
(1, 3);

-- Insertar cuentas bancarias para los clientes aprobados
INSERT INTO Cuenta_Bancaria (ID_Persona, Saldo)
VALUES 
(1, 0),
(2, 0);

-- Insertar créditos aprobados
INSERT INTO Credito (ID_Solicitud_Credito, Monto_Aprobado, Monto_Neto, ID_Cuenta)
VALUES 
(1, 500000, 480000, 1);

-- Insertar gastos y comisiones del crédito
INSERT INTO Gasto (ID_Credito, Concepto, Importe)
VALUES 
(1, 'Gastos administrativos', 10000),
(1, 'Gastos notariales', 5000);

INSERT INTO Comision (ID_Credito, Concepto, Importe)
VALUES 
(1, 'Comisión por apertura', 5000);

-- Insertar cuotas del crédito
INSERT INTO Cuota (ID_Credito, Fecha_Vencimiento, Importe_Neto, Intereses, Importe_Total, ID_Cuenta)
VALUES 
(1, '2024-03-10', 40000, 5000, 45000, 1),
(1, '2024-04-10', 40000, 5000, 45000, 1);

-- Insertar tramos del crédito
INSERT INTO Tramo (ID_Credito, Numero_Tramo, Monto_Tramo, ID_Certificacion)
VALUES 
(1, 1, 200000, NULL),
(1, 2, 280000, NULL);

-- Insertar certificaciones de avance de obra
INSERT INTO Certificacion (ID_Tramo, ID_Credito, Fecha, Resultado, Observacion)
VALUES 
(1, 1, '2024-03-01', 'A', 'Primera etapa completada satisfactoriamente');

-- Insertar movimientos en la cuenta bancaria
INSERT INTO Movimiento (ID_Credito, ID_Cuenta, Tipo_Movimiento, Fecha, Importe)
VALUES 
(1, 1, 'Acreditación', '2024-02-15', 200000),
(1, 1, 'Débito', '2024-03-10', 45000);


INSERT INTO Movimiento (ID_Credito, ID_Cuenta, Tipo_Movimiento, Fecha, Importe)
VALUES (1, 1, 'Acreditación', '2024-03-05', 300000);




/*
    Programar los triggers necesarios para controlar que la suma de los montos acreditados (en los Movimientos de la cuenta) de los tramos no supere el monto neto del crédito aprobado.
    ACLARACIÓN: Recordar que por cada acreditación de tramo se debe generar un movimiento en la cuenta del cliente con el tipo “Acreditación de tramo”.
*/

-- PASO 1: Crear una consuta de filas que no cumplen con la regla de integridad
SELECT C.ID_Credito, C.Monto_Neto, SUM(M.Importe) AS Total_Acreditado
FROM Credito C
JOIN Movimiento M ON C.ID_Credito = M.ID_Credito
WHERE M.Tipo_Movimiento = 'Acreditación'
GROUP BY C.ID_Credito, C.Monto_Neto
HAVING SUM(M.Importe) > C.Monto_Neto;

-- PASO 2: Determinar tablas y operaciones que afectan la regla de integridad

-- TABLA     |    INSERT 	 |	  DELETE     |	  UPDATE                     |
-- ------------------------------------------------------------------------------
-- Credito   |   ---         |     ---       |  mod. Monto_Neto --> controlar |
--           |               |               |  mod. Monto_Aprobado --> controlar |
-- ------------------------------------------------------------------------------
-- Movimiento|   controlar   |     ---       |  mod Importe --> controlar       |
-- ------------------------------------------------------------------------------

-- Se deberán crear los siguientes triggers:
--    -- insert Movimiento
--    -- update Credito
--    -- update Movimiento

--- PASO 3: Programar los triggers

-- TRIGGER USANDO TABLAS INSERTED Y DELETED
-- CREATE TRIGGER ti_ri_movimiento
-- ON Movimiento
-- FOR INSERT
-- AS
-- BEGIN
--     DECLARE @ID_Credito INT;
--     DECLARE
--     @Monto_Neto FLOAT,
--     @Total_Acreditado FLOAT;

--     SELECT @ID_Credito = ID_Credito
--     FROM inserted;

--     SELECT @Monto_Neto = C.Monto_Neto, @Total_Acreditado = SUM(M.Importe)
--     FROM Credito C
--     JOIN Movimiento M ON C.ID_Credito = M.ID_Credito
--     WHERE M.Tipo_Movimiento = 'Acreditación' AND C.ID_Credito = @ID_Credito
--     GROUP BY C.Monto_Neto;

--     IF @Total_Acreditado > @Monto_Neto
--     BEGIN
--         RAISERROR('El monto total acreditado supera el monto neto del crédito', 16, 1);
--         ROLLBACK;
--     END
-- END;


--TRIGGER USANDO IF EXISTS
CREATE TRIGGER ti_ri_movimiento
ON Movimiento
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT C.ID_Credito, C.Monto_Neto, SUM(M.Importe) AS Total_Acreditado
        FROM Credito C
        JOIN Movimiento M ON C.ID_Credito = M.ID_Credito
        WHERE M.Tipo_Movimiento = 'Acreditación'
        GROUP BY C.ID_Credito, C.Monto_Neto
        HAVING SUM(M.Importe) > C.Monto_Neto
    )
    BEGIN
        RAISERROR('El monto total acreditado supera el monto neto del crédito', 16, 1);
        ROLLBACK;
    END
END;


create trigger tu_ri_movimiento
on Movimiento
for update
as
begin
    if exists (
        select C.ID_Credito, C.Monto_Neto, SUM(M.Importe) AS Total_Acreditado
        from Credito C
        join Movimiento M on C.ID_Credito = M.ID_Credito
        where M.Tipo_Movimiento = 'Acreditación'
        group by C.ID_Credito, C.Monto_Neto
        having SUM(M.Importe) > C.Monto_Neto
    )
    begin
        raiserror('El monto total acreditado supera el monto neto del crédito',16,1)
        rollback
    end
end;

create trigger tu_ri_credito
on Credito
for update
as
begin
    if exists (
        select C.ID_Credito, C.Monto_Neto, SUM(M.Importe) AS Total_Acreditado
        from Credito C
        join Movimiento M on C.ID_Credito = M.ID_Credito
        where M.Tipo_Movimiento = 'Acreditación'
        group by C.ID_Credito, C.Monto_Neto
        having SUM(M.Importe) > C.Monto_Neto
    )
    begin
        raiserror('El monto total acreditado supera el monto neto del crédito',16,1)
        rollback
    end
end;


/*
    Programar un SELECT que muestre las cuotas impagas de cada crédito aprobado. 
*/

SELECT C.ID_Credito, Cu.ID_Cuota, Cu.Fecha_Vencimiento, Cu.Importe_Total
FROM Credito C
JOIN Cuota Cu ON C.ID_Credito = Cu.ID_Credito
WHERE C.ID_Credito IN (
    SELECT ID_Credito
    FROM Credito
    WHERE ID_Credito NOT IN (
        SELECT ID_Credito
        FROM Movimiento
        WHERE Tipo_Movimiento = 'Débito'
    )
);

/*
    Programar un procedimiento almacenado que reciba el número de crédito como argumento y devuelva como resultado los siguientes datos del mismo: 
    a. Nro. de crédito 
    b. Fecha de solicitud 
    c. Estado (pendiente de aprobación, aprobado o rechazado) 
    d. Fecha de resolución (aprobación o rechazo) 
    e. Si el crédito está aprobado: 
        i. Monto aprobado 
        ii. Monto neto a acreditar 
        iii. Total acreditado hasta el momento 
        iv. Cantidad de tramos acreditados 
        v. Total de cuotas 
        vi. Total de cuotas pagadas 
        vii. Importe total de cuotas pagadas 
        viii. Total de cuotas pendientes 
        ix. Importe total de cuotas pendientes
*/


CREATE PROCEDURE Datos_Credito
    @ID_Credito INT
AS
BEGIN
    SELECT 
        C.ID_Credito,
        SC.Fecha_Solicitud,
        SC.Estado,
        SC.Fecha_Resolucion,
        C.Monto_Aprobado,
        C.Monto_Neto,
        SUM(M.Importe) AS Total_Acreditado,
        COUNT(T.ID_Tramo) AS Tramos_Acreditados,
        COUNT(Cu.ID_Cuota) AS Total_Cuotas,
        COUNT(Cu.ID_Cuota) - COUNT(M2.ID_Movimiento) AS Cuotas_Pendientes,
        SUM(Cu.Importe_Total) AS Importe_Total_Cuotas,
        SUM(CASE WHEN M2.Tipo_Movimiento = 'Débito' THEN Cu.Importe_Total ELSE 0 END) AS Importe_Total_Pagado
    FROM Credito C
    JOIN Solicitud_Credito SC ON C.ID_Solicitud_Credito = SC.ID_Solicitud_Credito
    JOIN Movimiento M ON C.ID_Credito = M.ID_Credito
    JOIN Tramo T ON C.ID_Credito = T.ID_Credito
    JOIN Cuota Cu ON C.ID_Credito = Cu.ID_Credito
    LEFT JOIN Movimiento M2 ON C.ID_Credito = M2.ID_Credito AND M2.Tipo_Movimiento = 'Débito'
    WHERE C.ID_Credito = @ID_Credito
    GROUP BY C.ID_Credito, SC.Fecha_Solicitud, SC.Estado, SC.Fecha_Resolucion, C.Monto_Aprobado, C.Monto_Neto;
END;

EXEC Datos_Credito 1;

