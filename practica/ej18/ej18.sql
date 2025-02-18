-- SISTEMAS DE BASES DE DATOS – INGENIERÍA INFORMÁTICA 
 
-- DISEÑO DE BASES DE DATOS RELACIONALES 
 
 
-- Ejercicio N° 18: Construir el modelo de datos lógico y el modelo físico para el siguiente 
-- problema: 
 
-- Se requiere diseñar un modelo de bases de datos relacionales para satisfacer los 
-- requerimientos de información acerca de los presupuestos de diferentes áreas de una 
-- empresa. 
 
-- La información que se deberá registrar será la siguiente: 
 
-- − Áreas de la empresa: identificadas con un número. Se deberá registrar su nombre. 
 
-- − Empleados: Identificados por un nro. de legajo. Registrar además, nombre, 
-- documento y dirección 
 
-- − Plan de cuentas: Se registrará información acerca de las cuentas que se utilizarán en 
-- los presupuestos (similar a un sistema contable). Las cuentas se identifican por un 
-- código, se registrará además su nombre, si es de ingreso o de egreso y el área que la 
-- utilizará. 
 
-- − Presupuestos: Los presupuestos serán anuales y se requerirá información acerca del 
-- año al que corresponde, área y responsable del mismo. También se registrará la lista 
-- de empleados que pueden autorizar gastos sobre dicho presupuesto. 
 
-- − Detalle de presupuestos: Presupuesto, cuenta, total presupuestado 
 
-- − Ejecución de presupuestos: Se registrarán todos los movimientos (ingresos o 
-- egresos) para cada cuenta de cada presupuesto. Se requiere: presupuesto, área, 
-- cuenta, fecha, importe, comprobante, nro. movimento (único por comprobante). 
 
--  Regla 1: No se pueden registrar gastos que superen el presupuesto asignado
--  Descripción: Antes de insertar un gasto en la tabla Ejecucion_Presupuestos, se debe verificar que el importe total gastado en esa cuenta no supere el total presupuestado en Detalle_Presupuestos.

-- Trigger:

-- Se ejecuta antes de insertar o actualizar un gasto.
-- Si el nuevo gasto supera el límite, se cancela la operación.



-- Regla 2: Si se elimina un presupuesto, sus detalles y ejecución deben eliminarse también
--  Descripción: Si un presupuesto es eliminado de la tabla Presupuestos, se deben eliminar automáticamente los registros en Detalle_Presupuestos y Ejecucion_Presupuestos asociados a él.

-- Trigger:

-- Se ejecuta después de eliminar un presupuesto.
-- Borra los detalles y la ejecución del presupuesto eliminado.




CREATE TABLE Area (
    nro_area INT PRIMARY KEY,
    nom_area VARCHAR(255) NOT NULL
);

CREATE TABLE Empleado (
    nro_legajo INT PRIMARY KEY,
    nom_empleado VARCHAR(255) NOT NULL,
    documento VARCHAR(20) UNIQUE NOT NULL,
    direccion VARCHAR(255)
);

CREATE TABLE Comprobante (
    nro_movimiento INT PRIMARY KEY,
    comprobante VARCHAR(255) NOT NULL
);

CREATE TABLE Presupuesto (
    anio_presupuesto INT check (anio_presupuesto BETWEEN 1900 AND 2999),
    nro_area INT,
    responsable INT,
    PRIMARY KEY (anio_presupuesto, nro_area),
    FOREIGN KEY (nro_area) REFERENCES Area(nro_area) ON DELETE CASCADE,
    FOREIGN KEY (responsable) REFERENCES Empleado(nro_legajo) ON DELETE SET NULL
);

CREATE TABLE EmpleadoAutorizante (
    nro_legajo INT,
    anio_presupuesto INT,
    nro_area INT,
    PRIMARY KEY (nro_legajo, anio_presupuesto, nro_area),
    FOREIGN KEY (nro_legajo) REFERENCES Empleado(nro_legajo) ON DELETE CASCADE,
    FOREIGN KEY (anio_presupuesto, nro_area) REFERENCES Presupuesto(anio_presupuesto, nro_area) ON DELETE CASCADE
);


CREATE TABLE DetallePresupuesto (
    anio_presupuesto INT,
    nro_area INT,
    nro_cuenta INT,
    total_presupuestado INT NOT NULL CHECK (total_presupuestado >= 0),
    PRIMARY KEY (anio_presupuesto, nro_area, nro_cuenta),
    FOREIGN KEY (anio_presupuesto, nro_area) REFERENCES Presupuesto(anio_presupuesto, nro_area) ON DELETE CASCADE
);

CREATE TABLE EjecucionPresupuesto (
    anio_presupuesto INT,
    nro_area INT,
    nro_movimiento INT,
    nro_cuenta INT,
    fecha DATE NOT NULL,
    importe INT NOT NULL CHECK (importe >= 0),
    PRIMARY KEY (anio_presupuesto, nro_area, nro_movimiento),
    FOREIGN KEY (anio_presupuesto, nro_area) REFERENCES Presupuesto(anio_presupuesto, nro_area) ON DELETE CASCADE,
    FOREIGN KEY (nro_movimiento) REFERENCES Comprobante(nro_movimiento) ON DELETE CASCADE
);

CREATE TABLE PlanCuentas (
    cod_cuenta INT PRIMARY KEY,
    nom_cuenta VARCHAR(255) NOT NULL,
    tipo_cuenta CHAR(1) CHECK (tipo_cuenta IN ('I', 'E')), -- I = Ingreso, E = Egreso
    anio_presupuesto INT,
    nro_area INT,
    nro_movimiento INT,
    FOREIGN KEY (anio_presupuesto, nro_area, nro_movimiento) REFERENCES EjecucionPresupuesto(anio_presupuesto, nro_area, nro_movimiento) ON DELETE CASCADE
);


--TRIGGER 1 
---- Paso 1: consulta de filas que no cumplen con la regla de integridad

SELECT *
FROM EjecucionPresupuesto ep
JOIN DetallePresupuesto dp ON ep.anio_presupuesto = dp.anio_presupuesto AND ep.nro_area = dp.nro_area
WHERE ep.importe > dp.total_presupuestado;

---- Paso 2: determinar tablas y operaciones que afectan la regla de integridad

------------------------------------------------------------------------------
-- TABLA                |    INSERT 	 |	  DELETE     |	  UPDATE         |
------------------------------------------------------------------------------
-- EjecucionPresupuesto |   controlar   |     ---       |  mod. importe    |
--                      |               |               |  mod. cuenta     |
------------------------------------------------------------------------------

--paso 3: programar el trigger

CREATE TRIGGER tiu_ri_EjecucionPresupuesto
ON EjecucionPresupuesto
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM inserted ep
        JOIN DetallePresupuesto dp ON ep.anio_presupuesto = dp.anio_presupuesto AND ep.nro_area = dp.nro_area
        WHERE ep.importe > dp.total_presupuestado
    )
    BEGIN
        RAISERROR('El importe supera el total presupuestado', 16, 1);
        ROLLBACK;
    END
END;


--TRIGGER 2

-- Regla 2: Si se elimina un presupuesto, sus detalles y ejecución deben eliminarse también
--  Descripción: Si un presupuesto es eliminado de la tabla Presupuestos, se deben eliminar automáticamente los registros en Detalle_Presupuestos y Ejecucion_Presupuestos asociados a él.

---- Paso 1: consulta de filas que no cumplen con la regla de integridad

SELECT *
FROM deleted d
JOIN DetallePresupuesto dp ON d.anio_presupuesto = dp.anio_presupuesto AND d.nro_area = dp.nro_area;

---- Paso 2: determinar tablas y operaciones que afectan la regla de integridad

------------------------------------------------------------------------------
-- TABLA                |    INSERT 	 |	  DELETE     |	  UPDATE         |
------------------------------------------------------------------------------
-- Presupuesto          |     ---       |   controlar   |  ---             |
------------------------------------------------------------------------------

--paso 3: programar el trigger

CREATE TRIGGER td_pa_Presupuesto
ON Presupuesto
FOR DELETE
AS
BEGIN
    DELETE FROM DetallePresupuesto
    WHERE anio_presupuesto IN (SELECT anio_presupuesto FROM deleted)
    AND nro_area IN (SELECT nro_area FROM deleted);

    DELETE FROM EjecucionPresupuesto
    WHERE anio_presupuesto IN (SELECT anio_presupuesto FROM deleted)
    AND nro_area IN (SELECT nro_area FROM deleted);
END;