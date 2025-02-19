-- INGENIERIA INFORMÁTICA – SISTEMAS DE BASES DE DATOS – EXAMEN FINAL 05-02-2025 – TEMA 1 

-- Se necesita diseñar e implementar una base de datos que permita gestionar un sistema de reservas de espacios en un coworking. 

-- Se requerirá información sobre: 

-- Espacios de trabajo: Se identifican con un código único y se registra su nombre, capacidad máxima y tipo de espacio de trabajo (Oficina privada, Sala de trabajo compartido, Sala de reuniones, etc.).  

-- Clientes: Se identifican con un número único e incluyen nombre, apellido, número de documento, teléfono y correo electrónico. 

-- Reservas: Se identifican con un número único, fecha y hora de inicio, fecha y hora de finalización, el espacio reservado y el cliente que realizó la reserva. Cada reserva tiene un estado: Pendiente, Confirmada, Cancelada, Utilizada. 

-- Planes de suscripción: Algunos clientes pueden suscribirse a planes de uso del coworking. Estos planes se registran con un código único, nombre del plan, tipo de espacio de trabajo, cantidad de horas disponibles por mes y costo mensual. 

-- Uso de horas de suscripción: Para los clientes con planes de suscripción, se debe llevar un registro del uso de horas, indicando la reserva asociada y la cantidad de horas descontadas del plan. 

-- Pagos: Se registran los pagos realizados por los clientes de las reservas y planes contratados, identificándolo con un código único, el monto abonado, la fecha de pago, el método de pago (Tarjeta de crédito, Transferencia bancaria, etc.) y las reservas y/o planes que paga. Un pago puede pagar una o varias reservas y/o planes de suscripción. Cada reserva o plan de suscripción se debe pagar de una sola vez de manera completa. 

-- Se solicita:  

-- Diseñar un modelo lógico de datos para el problema (30) 

-- Implementar la base de datos (10) 

-- Controlar que un cliente con un plan de suscripción no reserve más horas que las disponibles en su plan (35) 

-- Programar un procedimiento almacenado que reciba un rango de fechas (fecha_desde y fecha_hasta) y muestre: 

-- Cantidad de reservas realizadas por cada tipo de espacio 

-- Total de horas reservadas por cada tipo de espacio 

-- Cantidad de clientes únicos que reservaron cada tipo de espacio 

-- Tasa de ocupación de cada tipo de espacio en relación a su disponibilidad máxima suponiendo que el coworking está abierto 24 horas por día, todos los días 

 

-- Mostrar lo siguiente: (25) 

 

-- TIPO DE ESPACIO	Cant. Reservas		Total horas	Cant. Clientes		Tasa ocupación 

-- Oficina privada		1023			4256		251			84.23% 

-- Sala de reuniones		423			1763		42			62.07% 

-- Sala de trabajo comp.		324			561		65			51.87% 

 

 
CREATE TABLE TipoEspacio (
    id_tipo_espacio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE EspaciosTrabajo (
    id_espacio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    capacidad_maxima INT NOT NULL,
    id_tipo_espacio INT NOT NULL,
    FOREIGN KEY (id_tipo_espacio) REFERENCES TipoEspacio(id_tipo_espacio)
);

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    numero_documento INT UNIQUE NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Reservas (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    id_espacio INT NOT NULL,
    id_cliente INT NOT NULL,
    estado ENUM('Pendiente', 'Confirmada', 'Cancelada', 'Utilizada') NOT NULL,
    FOREIGN KEY (id_espacio) REFERENCES EspaciosTrabajo(id_espacio),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE PlanesSuscripcion (
    id_plan INT PRIMARY KEY AUTO_INCREMENT,
    nombre_plan VARCHAR(255) NOT NULL,
    id_tipo_espacio INT NOT NULL,
    horas_mensuales INT NOT NULL,
    costo_mensual FLOAT NOT NULL,
    FOREIGN KEY (id_tipo_espacio) REFERENCES TipoEspacio(id_tipo_espacio)
);

CREATE TABLE UsoHorasSuscripcion (
    id_cliente INT NOT NULL,
    id_plan INT NOT NULL,
    horas_utilizadas INT NOT NULL,
    PRIMARY KEY (id_cliente, id_plan),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_plan) REFERENCES PlanesSuscripcion(id_plan)
);

CREATE TABLE MetodoPago (
    id_metodo_pago INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE Pagos (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    fecha_pago DATETIME NOT NULL,
    id_metodo_pago INT NOT NULL,
    monto FLOAT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_metodo_pago) REFERENCES MetodoPago(id_metodo_pago)
);

CREATE TABLE PagosReservas (
    id_pago INT NOT NULL,
    id_reserva INT NOT NULL,
    PRIMARY KEY (id_pago, id_reserva),
    FOREIGN KEY (id_pago) REFERENCES Pagos(id_pago),
    FOREIGN KEY (id_reserva) REFERENCES Reservas(id_reserva)
);

CREATE TABLE PagosPlanes (
    id_pago INT NOT NULL,
    id_plan INT NOT NULL,
    PRIMARY KEY (id_pago, id_plan),
    FOREIGN KEY (id_pago) REFERENCES Pagos(id_pago),
    FOREIGN KEY (id_plan) REFERENCES PlanesSuscripcion(id_plan)
);





-- Controlar que un cliente con un plan de suscripción no reserve más horas que las disponibles en su plan (35) 
--REGLA DE INTEGRIDAD: si un cliente posee un plan de suscripcion, no puede reservar mas horas de las que tiene disponibles
--PASO 1: Crear una consuta de filas que no cumplen con la regla de integridad

SELECT 
    uhs.id_cliente, 
    c.nombre, 
    c.apellido, 
    uhs.id_plan, 
    ps.nombre_plan, 
    ps.horas_mensuales, 
    COALESCE(SUM(TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin)), 0) AS horas_reservadas,
    (COALESCE(SUM(TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin)), 0) - ps.horas_mensuales) AS horas_excedidas
FROM UsoHorasSuscripcion uhs
JOIN Clientes c ON uhs.id_cliente = c.id_cliente
JOIN PlanesSuscripcion ps ON uhs.id_plan = ps.id_plan
JOIN Reservas r ON uhs.id_cliente = r.id_cliente
WHERE r.estado IN ('Pendiente', 'Confirmada', 'Utilizada')
GROUP BY uhs.id_cliente, uhs.id_plan, ps.horas_mensuales
HAVING horas_reservadas > ps.horas_mensuales;


--PASO 2: Determinar tablas y operaciones que afectan la regla de integridad
------------------------------------------------------------------------------
-- TABLA     |    INSERT 	 |	  DELETE     |	  UPDATE                     |
------------------------------------------------------------------------------
-- Reservas  |   controlar   |     ---       |  mod. estado --> controlar   |
--           |               |               |  mod. fecha  --> controlar   |
------------------------------------------------------------------------------
-- UsoHorasSuscripcion|     |     ---       |  mod. horas_utilizadas --> controlar   |
------------------------------------------------------------------------------

--triggers a crear
--insert Reservas
--update Reservas
--update UsoHorasSuscripcion


--PASO 3: Programar los triggers

CREATE OR ALTER TRIGGER tiu_ri_reservas
ON Reservas
FOR INSERT, UPDATE
AS
begin
    IF EXISTS (
        SELECT 
            uhs.id_cliente, 
            c.nombre, 
            c.apellido, 
            uhs.id_plan, 
            ps.nombre_plan, 
            ps.horas_mensuales, 
            COALESCE(SUM(TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin)), 0) AS horas_reservadas,
            (COALESCE(SUM(TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin)), 0) - ps.horas_mensuales) AS horas_excedidas
        FROM UsoHorasSuscripcion uhs
        JOIN Clientes c ON uhs.id_cliente = c.id_cliente
        JOIN PlanesSuscripcion ps ON uhs.id_plan = ps.id_plan
        JOIN Reservas r ON uhs.id_cliente = r.id_cliente
        WHERE r.estado IN ('Pendiente', 'Confirmada', 'Utilizada')
        GROUP BY uhs.id_cliente, uhs.id_plan, ps.horas_mensuales
        HAVING horas_reservadas > ps.horas_mensuales
    )
    BEGIN
        RAISEERROR('El cliente ha excedido la cantidad de horas disponibles en su plan de suscripcion', 16, 1);
        ROLLBACK;
    END
end;

CREATE OR ALTER TRIGGER tu_ri_usohorassuscripcion
ON UsoHorasSuscripcion
FOR UPDATE
AS
begin
    IF EXISTS (
        SELECT 
            uhs.id_cliente, 
            c.nombre, 
            c.apellido, 
            uhs.id_plan, 
            ps.nombre_plan, 
            ps.horas_mensuales, 
            COALESCE(SUM(TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin)), 0) AS horas_reservadas,
            (COALESCE(SUM(TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin)), 0) - ps.horas_mensuales) AS horas_excedidas
        FROM UsoHorasSuscripcion uhs
        JOIN Clientes c ON uhs.id_cliente = c.id_cliente
        JOIN PlanesSuscripcion ps ON uhs.id_plan = ps.id_plan
        JOIN Reservas r ON uhs.id_cliente = r.id_cliente
        WHERE r.estado IN ('Pendiente', 'Confirmada', 'Utilizada')
        GROUP BY uhs.id_cliente, uhs.id_plan, ps.horas_mensuales
        HAVING horas_reservadas > ps.horas_mensuales
    )
    BEGIN
        RAISEERROR('El cliente ha excedido la cantidad de horas disponibles en su plan de suscripcion', 16, 1);
        ROLLBACK;
    END
end;


-- Programar un procedimiento almacenado que reciba un rango de fechas (fecha_desde y fecha_hasta) y muestre: 

-- Cantidad de reservas realizadas por cada tipo de espacio 

-- Total de horas reservadas por cada tipo de espacio 

-- Cantidad de clientes únicos que reservaron cada tipo de espacio 

-- Tasa de ocupación de cada tipo de espacio en relación a su disponibilidad máxima suponiendo que el coworking está abierto 24 horas por día, todos los días 

 

-- Mostrar lo siguiente: (25) 

 

-- TIPO DE ESPACIO	Cant. Reservas		Total horas	Cant. Clientes		Tasa ocupación 

-- Oficina privada		1023			4256		251			84.23% 

-- Sala de reuniones		423			1763		42			62.07% 

-- Sala de trabajo comp.		324			561		65			51.87% 


CREATE PROCEDURE ObtenerEstadisticasCoworking (
    IN fecha_desde DATETIME,
    IN fecha_hasta DATETIME
)
BEGIN
    -- Crear tabla temporal para almacenar los resultados
    CREATE TEMPORARY TABLE IF NOT EXISTS EstadisticasCoworking (
        tipo_espacio VARCHAR(255),
        cant_reservas INT,
        total_horas INT,
        cant_clientes INT,
        tasa_ocupacion FLOAT
    );

    -- Insertar datos en la tabla temporal
    INSERT INTO EstadisticasCoworking (tipo_espacio, cant_reservas, total_horas, cant_clientes, tasa_ocupacion)
    SELECT 
        te.nombre AS tipo_espacio,
        COUNT(r.id_reserva) AS cant_reservas,
        COALESCE(SUM(TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin)), 0) AS total_horas,
        COUNT(DISTINCT r.id_cliente) AS cant_clientes,
        ROUND((COALESCE(SUM(TIMESTAMPDIFF(HOUR, r.fecha_inicio, r.fecha_fin)), 0) / 
               (COUNT(e.id_espacio) * 24 * DATEDIFF(fecha_hasta, fecha_desde))) * 100, 2) AS tasa_ocupacion
    FROM Reservas r
    JOIN EspaciosTrabajo e ON r.id_espacio = e.id_espacio
    JOIN TipoEspacio te ON e.id_tipo_espacio = te.id_tipo_espacio
    WHERE r.fecha_inicio BETWEEN fecha_desde AND fecha_hasta
    GROUP BY te.nombre;

    -- Mostrar los resultados
    SELECT * FROM EstadisticasCoworking;

    -- Eliminar la tabla temporal
    DROP TEMPORARY TABLE IF EXISTS EstadisticasCoworking;
