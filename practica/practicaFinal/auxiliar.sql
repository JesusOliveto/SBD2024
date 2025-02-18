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

-- Creación de las tablas
CREATE TABLE Personas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    apellido VARCHAR(50) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    tipoDocumento VARCHAR(50) NOT NULL,
    numeroDocumento VARCHAR(50) NOT NULL,
    domicilio VARCHAR(50) NOT NULL,
    telefono VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL
)

CREATE TABLE SolicitudesCredito (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    montoSolicitado FLOAT NOT NULL,
    fechaSolicitud DATE NOT NULL,
    idGarante INT NOT NULL,
    proyectoObra VARCHAR(50) NOT NULL, 
    estado CHAR(1) NULL, -- A: Aprobado, R: Rechazado, Si está en null es porque no se resolvió
    fechaResolucion DATE NULL, --Si está en null es porque no se resolvió
    FOREIGN KEY (idCliente) REFERENCES Personas(id),
    FOREIGN KEY (idGarante) REFERENCES Personas(id)
)

CREATE TABLE Creditos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idSolicitud INT NOT NULL,
    montoAprobado FLOAT NOT NULL,
    montoNeto FLOAT NOT NULL,
    tramos INT NOT NULL,
    FOREIGN KEY (idSolicitud) REFERENCES SolicitudesCredito(id)
)

CREATE TABLE Gastos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idCredito INT NOT NULL,
    concepto VARCHAR(50) NOT NULL,
    importe FLOAT NOT NULL,
    FOREIGN KEY (idCredito) REFERENCES Creditos(id)
)

CREATE TABLE Comisiones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idCredito INT NOT NULL,
    concepto VARCHAR(50) NOT NULL,
    importe FLOAT NOT NULL,
    FOREIGN KEY (idCredito) REFERENCES Creditos(id)
)


CREATE TABLE Cuotas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idCredito INT NOT NULL,
    fechaVencimiento DATE NOT NULL,
    importeNeto FLOAT NOT NULL,
    intereses FLOAT NOT NULL,
    importeTotal FLOAT NOT NULL,
    fechaCobro DATE NULL, -- Si está en null es porque no se cobró
    FOREIGN KEY (idCredito) REFERENCES Creditos(id)
)

CREATE TABLE Tramos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idCredito INT NOT NULL,
    importe FLOAT NOT NULL,
    fechaAcreditacion DATE NULL, -- Si está en null es porque no se acreditó
    FOREIGN KEY (idCredito) REFERENCES Creditos(id)
)

CREATE TABLE Certificaciones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idTramo INT NOT NULL,
    fecha DATE NOT NULL,
    resultado BIT NOT NULL, -- 0: Rechazado, 1: Aprobado
    observacion VARCHAR(50) NULL,
    FOREIGN KEY (idTramo) REFERENCES Tramos(id)
)

CREATE TABLE Cuentas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idCliente INT NOT NULL,
    idCredito INT NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Personas(id),
    FOREIGN KEY (idCredito) REFERENCES Creditos(id)
)

CREATE TABLE Movimientos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idCuenta INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    fecha DATE NOT NULL,
    importe FLOAT NOT NULL,
    FOREIGN KEY (idCuenta) REFERENCES Cuentas(id)
)

-- Inserción de datos
INSERT INTO Personas (apellido, nombre, tipoDocumento, numeroDocumento, domicilio, telefono, email) VALUES ('Perez', 'Juan', 'DNI', '12345678', 'Calle 123', '12345678', 'perez@hotmail.com')
INSERT INTO Personas (apellido, nombre, tipoDocumento, numeroDocumento, domicilio, telefono, email) VALUES ('Gomez', 'Maria', 'DNI', '87654321', 'Calle 456', '87654321', 'gomez@hotmail.com')
INSERT INTO Personas (apellido, nombre, tipoDocumento, numeroDocumento, domicilio, telefono, email) VALUES ('Gonzalez', 'Pedro', 'DNI', '12345678', 'Calle 789', '12345678', 'pedro@hotmail.com')

INSERT INTO SolicitudesCredito (idCliente, montoSolicitado, fechaSolicitud, idGarante, proyectoObra, estado, fechaResolucion) VALUES (1, 100000, '2020-01-01', 2, 'Proyecto casa nueva', 'A', '2020-01-02')
INSERT INTO SolicitudesCredito (idCliente, montoSolicitado, fechaSolicitud, idGarante, proyectoObra) VALUES (3, 200000, '2022-03-01', 2, 'Proyecto oficina nueva')

INSERT INTO Creditos (idSolicitud, montoAprobado, montoNeto, tramos) VALUES (1, 80000, 60000, 3)

INSERT INTO Gastos (idCredito, concepto, importe) VALUES (1, 'Gasto por papelería', 10000)

INSERT INTO Comisiones (idCredito, concepto, importe) VALUES (1, 'Comisión por otorgamiento', 10000)

INSERT INTO Cuotas (idCredito, fechaVencimiento, importeNeto, intereses, importeTotal, fechaCobro) VALUES (1, '2020-02-01', 10000, 1000, 11000, '2020-02-01')
INSERT INTO Cuotas (idCredito, fechaVencimiento, importeNeto, intereses, importeTotal) VALUES (1, '2020-03-01', 10000, 1000, 11000)
INSERT INTO Cuotas (idCredito, fechaVencimiento, importeNeto, intereses, importeTotal) VALUES (1, '2020-04-01', 10000, 1000, 11000)
INSERT INTO Cuotas (idCredito, fechaVencimiento, importeNeto, intereses, importeTotal) VALUES (1, '2020-05-01', 10000, 1000, 11000)
INSERT INTO Cuotas (idCredito, fechaVencimiento, importeNeto, intereses, importeTotal) VALUES (1, '2020-06-01', 10000, 1000, 11000)
INSERT INTO Cuotas (idCredito, fechaVencimiento, importeNeto, intereses, importeTotal) VALUES (1, '2020-07-01', 10000, 1000, 11000)

INSERT INTO Tramos (idCredito, importe, fechaAcreditacion) VALUES (1, 20000, '2020-01-02')
INSERT INTO Tramos (idCredito, importe) VALUES (1, 20000)
INSERT INTO Tramos (idCredito, importe) VALUES (1, 20000)

INSERT INTO Certificaciones (idTramo, fecha, resultado, observacion) VALUES (1, '2020-01-02', 1, 'Avance aprobado')

INSERT INTO Cuentas (idCliente, idCredito) VALUES (1, 1)

INSERT INTO Movimientos (idCuenta, tipo, fecha, importe) VALUES (1, 'Acreditación de tramo', '2020-01-02', 20000)
INSERT INTO Movimientos (idCuenta, tipo, fecha, importe) VALUES (1, 'Débito de cuota', '2020-02-01', 11000)

/*
    Programar los triggers necesarios para controlar que la suma de los montos acreditados (en los Movimientos de la cuenta) de los tramos no supere el monto neto del crédito aprobado.
    ACLARACIÓN: Recordar que por cada acreditación de tramo se debe generar un movimiento en la cuenta del cliente con el tipo “Acreditación de tramo”.
*/

-- Trigger para controlar que la suma de los montos acreditados (en los Movimientos de la cuenta) de los tramos no supere el monto neto del crédito aprobado.
CREATE TRIGGER trControlarMontoAcreditado ON Movimientos
AFTER INSERT
AS
BEGIN
    DECLARE @idCuenta INT
    DECLARE @idCredito INT
    DECLARE @montoNeto FLOAT
    DECLARE @montoAcreditado FLOAT

    SELECT @idCuenta = idCuenta FROM inserted
    SELECT @idCredito = idCredito FROM Cuentas WHERE id = @idCuenta
    SELECT @montoNeto = montoNeto FROM Creditos WHERE id = @idCredito
    SELECT @montoAcreditado = SUM(importe) FROM Movimientos WHERE idCuenta = @idCuenta AND tipo = 'Acreditación de tramo'

    IF @montoAcreditado > @montoNeto
    BEGIN
        RAISERROR ('El monto acreditado no puede superar el monto neto del crédito aprobado', 16, 1)
        ROLLBACK TRANSACTION
    END
END

/*
    Programar un SELECT que muestre las cuotas impagas de cada crédito aprobado. 
*/

CREATE VIEW vCuotasImpagas AS
SELECT c.id AS idCredito, cu.id AS idCuota, cu.fechaVencimiento, cu.importeNeto, cu.intereses, cu.importeTotal
FROM Creditos c
INNER JOIN Cuotas cu ON c.id = cu.idCredito
WHERE cu.fechaCobro IS NULL

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

CREATE PROCEDURE ObtenerDatosCredito(@numCredito INT)
AS
BEGIN
    DECLARE @estado CHAR(1)
    DECLARE @fechaResolucion DATE

    SELECT
        SC.id AS 'Nro. de crédito',
        SC.fechaSolicitud AS 'Fecha de solicitud',
        CASE 
            WHEN SC.estado IS NULL THEN 'Pendiente de aprobación'
            WHEN SC.estado = 'A' THEN 'Aprobado'
            WHEN SC.estado = 'R' THEN 'Rechazado'
            ELSE 'Desconocido'
        END AS 'Estado',
        SC.fechaResolucion AS 'Fecha de resolución',
        C.montoAprobado AS 'Monto aprobado',
        C.montoNeto AS 'Monto neto a acreditar',
        (SELECT SUM(importe) FROM Tramos WHERE idCredito = C.id AND fechaAcreditacion IS NOT NULL) AS 'Total acreditado hasta el momento',
        (SELECT COUNT(id) FROM Tramos WHERE idCredito = C.id AND fechaAcreditacion IS NOT NULL) AS 'Cantidad de tramos acreditados',
        (SELECT COUNT(id) FROM Cuotas WHERE idCredito = C.id) AS 'Total de cuotas',
        (SELECT COUNT(id) FROM Cuotas WHERE idCredito = C.id AND fechaCobro IS NOT NULL) AS 'Total de cuotas pagadas',
        (SELECT SUM(importeTotal) FROM Cuotas WHERE idCredito = C.id AND fechaCobro IS NOT NULL) AS 'Importe total de cuotas pagadas',
        (SELECT COUNT(id) FROM Cuotas WHERE idCredito = C.id AND fechaCobro IS NULL) AS 'Total de cuotas pendientes',
        (SELECT SUM(importeTotal) FROM Cuotas WHERE idCredito = C.id AND fechaCobro IS NULL) AS 'Importe total de cuotas pendientes'
    FROM SolicitudesCredito SC
    INNER JOIN Creditos C ON SC.id = C.idSolicitud
    WHERE SC.id = @numCredito;

END;

-- Ejecucción del procedimiento almacenado
EXEC ObtenerDatosCredito 1


-- Trigger para controlar que la suma de los montos acreditados (en los Movimientos de la cuenta) de los tramos no supere el monto neto del crédito aprobado.
CREATE TRIGGER trControlarMontoAcreditado ON Movimientos
AFTER INSERT
AS
BEGIN
    DECLARE @idCuenta INT
    DECLARE @idCredito INT
    DECLARE @montoNeto FLOAT
    DECLARE @montoAcreditado FLOAT

    SELECT @idCuenta = idCuenta FROM inserted
    SELECT @idCredito = idCredito FROM Cuentas WHERE id = @idCuenta
    SELECT @montoNeto = montoNeto FROM Creditos WHERE id = @idCredito
    SELECT @montoAcreditado = SUM(importe) FROM Movimientos WHERE idCuenta = @idCuenta AND tipo = 'Acreditación de tramo'

    IF @montoAcreditado > @montoNeto
    BEGIN
        RAISERROR ('El monto acreditado no puede superar el monto neto del crédito aprobado', 16, 1)
        ROLLBACK TRANSACTION
    END
END



CREATE PROCEDURE ObtenerDatosCredito(@numCredito INT)
AS
BEGIN
    DECLARE @estado CHAR(1)
    DECLARE @fechaResolucion DATE

    SELECT
        SC.id AS 'Nro. de crédito',
        SC.fechaSolicitud AS 'Fecha de solicitud',
        CASE 
            WHEN SC.estado IS NULL THEN 'Pendiente de aprobación'
            WHEN SC.estado = 'A' THEN 'Aprobado'
            WHEN SC.estado = 'R' THEN 'Rechazado'
            ELSE 'Desconocido'
        END AS 'Estado',
        SC.fechaResolucion AS 'Fecha de resolución',
        C.montoAprobado AS 'Monto aprobado',
        C.montoNeto AS 'Monto neto a acreditar',
        (SELECT SUM(importe) FROM Tramos WHERE idCredito = C.id AND fechaAcreditacion IS NOT NULL) AS 'Total acreditado hasta el momento',
        (SELECT COUNT(id) FROM Tramos WHERE idCredito = C.id AND fechaAcreditacion IS NOT NULL) AS 'Cantidad de tramos acreditados',
        (SELECT COUNT(id) FROM Cuotas WHERE idCredito = C.id) AS 'Total de cuotas',
        (SELECT COUNT(id) FROM Cuotas WHERE idCredito = C.id AND fechaCobro IS NOT NULL) AS 'Total de cuotas pagadas',
        (SELECT SUM(importeTotal) FROM Cuotas WHERE idCredito = C.id AND fechaCobro IS NOT NULL) AS 'Importe total de cuotas pagadas',
        (SELECT COUNT(id) FROM Cuotas WHERE idCredito = C.id AND fechaCobro IS NULL) AS 'Total de cuotas pendientes',
        (SELECT SUM(importeTotal) FROM Cuotas WHERE idCredito = C.id AND fechaCobro IS NULL) AS 'Importe total de cuotas pendientes'
    FROM SolicitudesCredito SC
    INNER JOIN Creditos C ON SC.id = C.idSolicitud
    WHERE SC.id = @numCredito;

END;

-- Ejecucción del procedimiento almacenado
EXEC ObtenerDatosCredito 1