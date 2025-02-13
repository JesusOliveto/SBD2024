--programar en SQL SERVER
select 'drop table ' + s.name + '.' + o.name
	from sys.objects o
		 join sys.schemas s
			on o.schema_id=s.schema_id
	where o.type='U'

drop table dbo.Areas
drop table dbo.Personal
drop table dbo.Personal_areas
drop table dbo.Proyectos
drop table dbo.Personal_proyectos

create table Areas (
    nro_area int primary key,
    nombre_area varchar(50),
    lideres bit               -- 1 si puede aportar lideres a proyectos, 0 si no
);

create table Personal(
    nro_empleado int primary key,
    nombre_empleado varchar(50)
)

create table Personal_areas(
    nro_empleado int,
    nro_area int,
    fecha_inicio date,
    fecha_fin date,
    primary key(nro_empleado, nro_area),
    foreign key(nro_empleado) references Personal(nro_empleado),
    foreign key(nro_area) references Areas(nro_area)
)

Create table Proyectos(
    nro_proyecto int primary key,
    nombre_proyecto varchar(50),
    nro_area int,
    foreign key(nro_area) references Areas(nro_area)
)

create table Personal_proyectos(
    nro_proyecto int,
    nro_empleado int,
    nro_area int,
    lider bit,
    primary key(nro_proyecto, nro_empleado, nro_area),
    foreign key(nro_proyecto) references Proyectos(nro_proyecto),
    foreign key(nro_empleado) references Personal(nro_empleado),
    foreign key(nro_area) references Areas(nro_area)
)


INSERT INTO Areas (nro_area, nombre_area, lideres)
VALUES
    (1, 'Research and Development', 1),
    (2, 'Marketing', 0),
    (3, 'Human Resources', 0),
    (4, 'Sales', 1),
    (5, 'IT Support', 1);

-- Insert sample data into Personal table
INSERT INTO Personal (nro_empleado, nombre_empleado)
VALUES
    (101, 'John Doe'),
    (102, 'Jane Smith'),
    (103, 'Alice Johnson'),
    (104, 'Chris Lee'),
    (105, 'Mike Brown');

-- Insert sample data into Personal_areas table
INSERT INTO Personal_areas (nro_empleado, nro_area, fecha_inicio, fecha_fin)
VALUES
    (101, 1, '2020-01-01', '2023-12-31'),
    (102, 2, '2021-06-15', '2023-12-31'),
    (103, 3, '2019-03-01', '2023-12-31'),
    (104, 4, '2022-09-10', '2023-12-31'),
    (105, 5, '2020-07-25', '2023-12-31');

-- Insert sample data into Proyectos table
INSERT INTO Proyectos (nro_proyecto, nombre_proyecto, nro_area)
VALUES
    (201, 'Project Alpha', 1),
    (202, 'Project Beta', 2),
    (203, 'Project Gamma', 3),
    (204, 'Project Delta', 4),
    (205, 'Project Epsilon', 5);

-- Insert sample data into Personal_proyectos table
INSERT INTO Personal_proyectos (nro_proyecto, nro_empleado, nro_area, lider)
VALUES
    (201, 101, 1, 1),
    (202, 102, 2, 0),
    (203, 103, 3, 0),
    (204, 104, 4, 1),
    (205, 105, 5, 0),
    (201, 102, 1, 1),  -- Employee from a different area participating in a project
    (204, 101, 4, 0);  -- Another cross-area participation example

select * from Personal_proyectos

--REGLA DE INTEGRIDAD: EL LIDER DE UN PROYECTO DEBE SER UN EMPLEADO QUE PERTENEZCA AL AREA DEL PROYECTO

--1) programar una consulta que muestre las filas que no cumplen con la regla de integridad

select *
    from Personal_proyectos pp
        join Proyectos pr
            on pp.nro_proyecto = pr.nro_proyecto
            and pp.nro_area = pr.nro_area
        where pp.lider = 1
go

select * from Personal_proyectos

SELECT 
    pp.nro_proyecto,pp.nro_empleado,pp.nro_area AS area_proyecto,pa.nro_area AS area_empleado,pp.lider
FROM 
    Personal_proyectos pp
JOIN 
    Personal_areas pa ON pp.nro_empleado = pa.nro_empleado
WHERE 
    pp.lider = 1 
    AND pp.nro_area <> pa.nro_area

--2) determinar las tablas y operaciones que afectan la regla de integridad

/*
------------------------------------------------------------------------------
   TABLA     |    INSERT 	 |	  DELETE      |	  UPDATE                     |
------------------------------------------------------------------------------
Personal_proyectos    -->si           -->no           -->si
------------------------------------------------------------------------------
Proyectos         -->no           -->no               -->si
------------------------------------------------------------------------------
Areas             -->no           -->no               -->no

-- insert sobre Personal_proyectos
-- update sobre Personal_proyectos
-- update sobre Proyectos
*/


3) Crear los triggers
*/

/*GPT*/
CREATE or alter TRIGGER trg_CheckProjectLeader
ON Personal_proyectos
AFTER INSERT, UPDATE
AS
BEGIN
    -- Check if the leader is an employee from the project's area
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Personal_areas pa ON i.nro_empleado = pa.nro_empleado
        WHERE i.lider = 1 AND i.nro_area <> pa.nro_area
    )
    BEGIN
        -- If not, raise an error and rollback the transaction
        RAISERROR ('El líder de un proyecto debe ser un empleado que pertenezca al área del proyecto', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
/*GPT ete funciona josha*/

create or alter trigger tiu_ri_personal_proyectos
on Personal_proyectos
for insert, update
as
begin
    if exists(
        select *
            from inserted i
                join Proyectos pr
                    on i.nro_proyecto = pr.nro_proyecto
                    and i.nro_area = pr.nro_area
            where i.lider = 1
    )
    begin
        raiserror('El lider de un proyecto debe ser un empleado que pertenezca al area del proyecto', 16, 1)
        rollback 
    end
end

create or alter trigger tu_ri_proyectos
on Proyectos
for update
as
begin
    if exists(
        select *
            from inserted i
                join Personal_proyectos pp
                    on i.nro_proyecto = pp.nro_proyecto
                    and i.nro_area = pp.nro_area
            where pp.lider = 1
    )
    begin
        raiserror('El lider de un proyecto debe ser un empleado que pertenezca al area del proyecto', 16, 1)
        rollback 
    end
end




--REGLA DE INTEGRIDAD: CADA PROYECTO DEBE TENER UNO Y SÓLO UN LIDER, A MENOS QUE NO HAYA EMPLEADOS EN EL AREA DEL PROYECTO

--1) programar una consulta que muestre las filas que no cumplen con la regla de integridad

select pp.nro_proyecto, count(*)
    from Personal_proyectos pp
    group by pp.nro_proyecto
    having count(case when pp.lider = 1 then 1 else null end ) != 1

select * from Personal_proyectos

SELECT 
    p.nro_proyecto,
    p.nombre_proyecto,
    COUNT(CASE WHEN pp.lider = 1 THEN 1 END) AS num_lideres,
    COUNT(pa.nro_empleado) AS num_empleados_area
FROM 
    Proyectos p
LEFT JOIN 
    Personal_proyectos pp ON p.nro_proyecto = pp.nro_proyecto AND pp.lider = 1
LEFT JOIN 
    Personal_areas pa ON p.nro_area = pa.nro_area
GROUP BY 
    p.nro_proyecto, 
    p.nombre_proyecto
HAVING 
    (COUNT(CASE WHEN pp.lider = 1 THEN 1 END) != 1 AND COUNT(pa.nro_empleado) > 0)
    OR (COUNT(CASE WHEN pp.lider = 1 THEN 1 END) > 1);

--2) determinar las tablas y operaciones que afectan la regla de integridad

/*
------------------------------------------------------------------------------
   TABLA     |    INSERT 	 |	  DELETE      |	  UPDATE                     |
------------------------------------------------------------------------------
Personal_proyectos    -->si           -->si           -->si
------------------------------------------------------------------------------

-- insert sobre Personal_proyectos
-- delete sobre Personal_proyectos
-- update sobre Personal_proyectos
*/


--3) Crear los triggers


create or alter trigger tiud_ri_personal_proyectos
on Personal_proyectos
for insert, update, delete
as
begin
    if exists(
        select pp.nro_proyecto, count(*)
            from Personal_proyectos pp
			where exists (select * from inserted i
							where pp.nro_proyecto=i.nro_proyecto)
            group by pp.nro_proyecto
            having count(case when pp.lider = 1 then 1 else null end ) != 1
    )
    begin
        raiserror('Cada proyecto debe tener uno y solo un lider', 16, 1)
        rollback 
    end
end

update pp
	set lider= case when nro_empleado=1 then 0 else 1 end
--select * 
from Personal_proyectos pp
where nro_proyecto=1
	and nro_area=1
	and nro_empleado in (1,12)

--4) probar los triggers

insert into Areas values(1, 'area1', 1)
insert into Personal values(1, 'empleado1')
insert into Personal values(2, 'empleado2')
insert into Personal_areas values(1, 1, '20210101', null)
insert into Proyectos values(1, 'proyecto1', 1)
insert into Personal_proyectos values(1, 1, 1, 1)
insert into Personal_proyectos values(1, 2, 1, 1)
delete from Personal_proyectos where nro_empleado = 1




