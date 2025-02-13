-- SISTEMAS DE BASES DE DATOS – INGENIERÍA INFORMÁTICA 
 
-- DISEÑO DE BASES DE DATOS RELACIONALES 
 
 
-- Ejercicio N° 7: Construir el modelo de datos lógico y el modelo físico para el siguiente 
-- problema: 
 
-- Una empresa de desarrollos informáticos está dividida en departamentos, en cada uno 
-- de los cuales trabaja un conjunto de profesionales. La empresa desarrolla diferentes 
-- proyectos, algunos propios y otros para clientes específicos. Cada desarrollo se divide 
-- en etapas. Cada etapa está a cargo de un departamento. Cada departamento asigna un 
-- grupo de profesionales para cada una de las tareas que corresponden a las etapas a su 
-- cargo. Se debe mantener información acerca de los departamentos, profesionales, 
-- proyectos, etapas, tareas y clientes. 
 
-- Los proyectos se identifican por un número de proyecto único y se requiere su nombre, 
-- cantidad de horas totales y presupuesto total del mismo y, en el caso que se desarrollen 
-- para un cliente determinado, información acerca de este (nro. cliente (único), nombre, 
-- dirección, teléfono) 
-- Los departamentos se identifican por un número y se requiere su nombre. 
-- Los profesionales se identifican por un número y se requiere su nombre, título, cargo y 
-- departamento en el cual trabajan. 
-- Las etapas se identifican por un número único por proyecto y se requiere como 
-- información su denominación, descripción, horas asignadas, presupuesto y 
-- departamento asignado a la misma. 
-- Las tareas se identifican por un número único y se requiere su nombre. 
-- Además se necesita conocer, para cada tarea correspondiente a una etapa de un 
-- proyecto, los profesionales ocupados en dicha tarea, la cantidad de horas y el 
-- presupuesto asignado a la misma. 
 
-- Consideraciones y aclaraciones: 
 
-- − La empresa tiene varios proyectos. 
-- − El desarrollo de un proyecto es llevado a cabo en varias etapas cada una de las 
-- cuales es asignada a un departamento. 
-- − Una etapa de un proyecto es realizada solo por un departamento. 
-- − Un departamento puede trabajar simultáneamente en varias etapas que pueden 
-- corresponder a uno o varios proyectos. 
-- − Una etapa consta de varias tareas. 
-- − La cantidad de horas y el presupuesto de cada etapa se obtiene sumando la 
-- cantidad de horas y presupuesto de todas las tareas correspondientes a la etapa. 
-- − Una tarea puede ser requerida en varias etapas  pertenecientes a uno o varios 
-- proyectos, pero en cada etapa de cada proyecto la tarea tendrá asignada una 
-- cantidad de horas y un presupuesto determinado. 
-- − Un profesional puede estar trabajando en cero o una tarea correspondiente a una 
-- etapa a cargo de su departamento. 
-- − Una tarea puede ser desarrollada por varios profesionales.


-- Tabla de Departamentos
CREATE TABLE Departamento (
    nro_departamento INT PRIMARY KEY,
    nom_departamento VARCHAR(255) NOT NULL
);



-- Tabla de Títulos
CREATE TABLE Titulo (
    nro_titulo INT PRIMARY KEY,
    nom_titulo VARCHAR(255) NOT NULL
);

-- Tabla de Cargos
CREATE TABLE Cargo (
    nro_cargo INT PRIMARY KEY,
    nom_cargo VARCHAR(255) NOT NULL,
    descripcion VARCHAR(500)
);

-- Tabla de Clientes
CREATE TABLE Cliente (
    nro_cliente INT PRIMARY KEY,
    nom_cliente VARCHAR(255) NOT NULL,
    direccion VARCHAR(500),
    telefono VARCHAR(50)
);

-- Tabla de Tareas
CREATE TABLE Tarea (
    nro_tarea INT PRIMARY KEY,
    nom_tarea VARCHAR(255) NOT NULL
);

-- Tabla de Proyectos
CREATE TABLE Proyecto (
    nro_proyecto INT PRIMARY KEY,
    nom_proyecto VARCHAR(255) NOT NULL,
    cant_horas_totales INT CHECK (cant_horas_totales >= 0),
    presupuesto FLOAT CHECK (presupuesto >= 0),
    nro_cliente INT NULL,
    FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente)
);

-- Tabla de Profesionales
CREATE TABLE Profesional (
    nro_profesional INT PRIMARY KEY,
    nom_profesional VARCHAR(255) NOT NULL,
    nro_titulo INT NOT NULL,
    nro_cargo INT NOT NULL,
    nro_departamento INT NOT NULL,
    FOREIGN KEY (nro_departamento) REFERENCES Departamento(nro_departamento),
    FOREIGN KEY (nro_titulo) REFERENCES Titulo(nro_titulo),
    FOREIGN KEY (nro_cargo) REFERENCES Cargo(nro_cargo)
);



-- Tabla de Etapas
CREATE TABLE Etapa (
    nro_proyecto INT NOT NULL,
    nro_etapa INT NOT NULL,
    denominacion VARCHAR(255) NOT NULL,
    descripcion VARCHAR(500),
    horas_asignadas INT CHECK (horas_asignadas >= 0),
    presupuesto FLOAT CHECK (presupuesto >= 0),
    departamento_asignado INT NOT NULL,
    PRIMARY KEY (nro_proyecto, nro_etapa),
    FOREIGN KEY (departamento_asignado) REFERENCES Departamento(nro_departamento),
    FOREIGN KEY (nro_proyecto) REFERENCES Proyecto(nro_proyecto)
);

-- Relación entre Tareas y Etapas (Corrección de la clave foránea)
CREATE TABLE Tarea_Etapa (
    nro_proyecto INT NOT NULL, -- Agregado para coincidir con la clave primaria de Etapa
    nro_etapa INT NOT NULL,
    nro_tarea INT NOT NULL,
    cantidad_horas INT CHECK (cantidad_horas >= 0),
    presupuesto FLOAT CHECK (presupuesto >= 0),
    PRIMARY KEY (nro_proyecto, nro_etapa, nro_tarea),
    FOREIGN KEY (nro_proyecto, nro_etapa) REFERENCES Etapa(nro_proyecto, nro_etapa),
    FOREIGN KEY (nro_tarea) REFERENCES Tarea(nro_tarea)
);

-- Relación entre Profesionales y Tareas_Etapas
CREATE TABLE Profesional_Tarea_Etapa
(
    nro_profesional INT NOT NULL,
    nro_proyecto INT NOT NULL,
    nro_etapa INT NOT NULL,
    nro_tarea INT NOT NULL,
    PRIMARY KEY (nro_profesional, nro_tarea, nro_etapa, nro_proyecto),
    FOREIGN KEY (nro_profesional) REFERENCES Profesional(nro_profesional),
    FOREIGN KEY (nro_proyecto, nro_etapa, nro_tarea) REFERENCES Tarea_Etapa(nro_proyecto, nro_etapa, nro_tarea)
);



--triggers

--trigger actualiza horas y presupuesto de etapa

--PASO 1 : crear una consulta que obtenga la suma de las horas y presupuesto de las tareas de una etapa

SELECT nro_proyecto, nro_etapa, SUM(cantidad_horas) AS horas_etapa, SUM(presupuesto) AS presupuesto_etapa
FROM Tarea_Etapa
WHERE nro_proyecto = @nro_proyecto AND nro_etapa = @nro_etapa
GROUP BY nro_proyecto, nro_etapa;


--PASO 2: determinar las tablas y operaciones que afectan la regla de integridad

/*
------------------------------------------------------------------------------
   TABLA     |    INSERT 	 |	  DELETE      |	  UPDATE                     |
------------------------------------------------------------------------------
    Tarea_Etapa    si se inserta	si se elimina     cantidad_horas    --> controlar
                    una tarea      una tarea         presupuesto       --> controlar
                    en una etapa   en una etapa
                    --> controlar    --> controlar
------------------------------------------------------------------------------
-- insert sobre Tarea_Etapa
-- delete sobre Tarea_Etapa
-- update sobre Tarea_Etapa
*/

--PASO 3: Crear el trigger

CREATE OR ALTER TRIGGER tiud_pa_Tarea_Etapa
ON Tarea_Etapa
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @nro_proyecto INT;
    DECLARE @nro_etapa INT;
    DECLARE @horas_etapa INT;
    DECLARE @presupuesto_etapa FLOAT;

    -- Obtener el número de proyecto y etapa afectado
    SELECT @nro_proyecto = nro_proyecto, @nro_etapa = nro_etapa
    FROM inserted;

    -- Actualizar las horas y presupuesto de la etapa
    UPDATE Etapa
    SET horas_asignadas = (SELECT SUM(cantidad_horas) FROM Tarea_Etapa WHERE nro_proyecto = @nro_proyecto AND nro_etapa = @nro_etapa),
        presupuesto = (SELECT SUM(presupuesto) FROM Tarea_Etapa WHERE nro_proyecto = @nro_proyecto AND nro_etapa = @nro_etapa)
    WHERE nro_proyecto = @nro_proyecto AND nro_etapa = @nro_etapa;
END;

--Regla de integridad: la suma de presupuesto y horas de las etapas debe ser igual o menor al presupuesto y horas totales del proyecto

--PASO 1: crear una consulta que obtenga la suma de las horas y presupuesto de las etapas de un proyecto

SELECT nro_proyecto, SUM(horas_asignadas) AS horas_proyecto, SUM(presupuesto) AS presupuesto_proyecto
FROM Etapa
WHERE nro_proyecto = @nro_proyecto
GROUP BY nro_proyecto;

--PASO 2: determinar las tablas y operaciones que afectan la regla de integridad

/*
------------------------------------------------------------------------------
   TABLA     |    INSERT 	 |	  DELETE      |	  UPDATE                     |
------------------------------------------------------------------------------
    Etapa    si se inserta	si se elimina     horas_asignadas    --> controlar
                una etapa      una etapa         presupuesto       --> controlar
                en un proyecto en un proyecto
                --> controlar    --> controlar
------------------------------------------------------------------------------

-- insert sobre Etapa
-- delete sobre Etapa
-- update sobre Etapa
*/

--PASO 3: Crear el trigger para controlar la regla de integridad

CREATE OR ALTER TRIGGER tiud_ri_Etapa
ON Etapa
AFTER INSERT, UPDATE, DELETE
AS
begin
    DECLARE @nro_proyecto INT;
    DECLARE @horas_proyecto INT;
    DECLARE @presupuesto_proyecto FLOAT;

    -- Obtener el número de proyecto afectado
    SELECT @nro_proyecto = nro_proyecto
    FROM inserted;

    -- si la suma de horas y presupuesto de las etapas supera las horas y presupuesto totales del proyecto, lanzar un error
    SELECT @horas_proyecto = SUM(horas_asignadas), @presupuesto_proyecto = SUM(presupuesto)
    FROM Etapa
    WHERE nro_proyecto = @nro_proyecto
    GROUP BY nro_proyecto;

    IF @horas_proyecto > (SELECT cant_horas_totales FROM Proyecto WHERE nro_proyecto = @nro_proyecto)
        OR @presupuesto_proyecto > (SELECT presupuesto FROM Proyecto WHERE nro_proyecto = @nro_proyecto)
    BEGIN
        RAISERROR ('La suma de horas y presupuesto de las etapas supera las horas y presupuesto totales del proyecto', 16, 1);
        ROLLBACK TRANSACTION;
    END;

end;


--Regla de integridad: los profesionales asignados a una tarea deben pertenecer al departamento asignado a la etapa

--PASO 1: crear una consulta que obtenga los profesionales asignados a una tarea y el departamento asignado a la etapa

SELECT p.nro_profesional, p.nom_profesional, p.nro_departamento, te.nro_tarea, te.nro_etapa, te.nro_proyecto
FROM Profesional p
JOIN Profesional_Tarea_Etapa pte ON p.nro_profesional = pte.nro_profesional
JOIN Tarea_Etapa te ON pte.nro_tarea = te.nro_tarea AND pte.nro_etapa = te.nro_etapa AND pte.nro_proyecto = te.nro_proyecto

--PASO 2: determinar las tablas y operaciones que afectan la regla de integridad

/*
------------------------------------------------------------------------------
   TABLA     |    INSERT 	 |	  DELETE      |	  UPDATE                     |
------------------------------------------------------------------------------
Profesional_Tarea_Etapa    si se inserta	delete         nro_profesional    --> controlar
                            una asignación  no requiere    nro_tarea          --> controlar
                            de tarea                       nro_etapa          --> controlar
                            --> controlar    
------------------------------------------------------------------------------

-- insert sobre Profesional_Tarea_Etapa
-- update sobre Profesional_Tarea_Etapa
*/

--PASO 3: Crear el trigger para controlar la regla de integridad

CREATE OR ALTER TRIGGER tiud_ri_Profesional_Tarea_Etapa
ON Profesional_Tarea_Etapa
AFTER INSERT, UPDATE
AS
begin
    DECLARE @nro_proyecto INT;
    DECLARE @nro_etapa INT;
    DECLARE @nro_tarea INT;
    DECLARE @nro_profesional INT;
    DECLARE @nro_departamento_profesional INT;
    DECLARE @nro_departamento_etapa INT;

    -- Obtener los datos de la asignación de tarea
    SELECT @nro_proyecto = nro_proyecto, @nro_etapa = nro_etapa, @nro_tarea = nro_tarea, @nro_profesional = nro_profesional
    FROM inserted;

    -- Obtener el departamento del profesional
    SELECT @nro_departamento_profesional = nro_departamento
    FROM Profesional
    WHERE nro_profesional = @nro_profesional;

    -- Obtener el departamento de la etapa
    SELECT @nro_departamento_etapa = departamento_asignado
    FROM Etapa
    WHERE nro_proyecto = @nro_proyecto AND nro_etapa = @nro_etapa;

    -- Si el departamento del profesional no coincide con el departamento de la etapa, lanzar un error
    IF @nro_departamento_profesional <> @nro_departamento_etapa
    BEGIN
        RAISERROR ('El profesional asignado a la tarea no pertenece al departamento asignado a la etapa', 16, 1);
        ROLLBACK TRANSACTION;
    END;

end;