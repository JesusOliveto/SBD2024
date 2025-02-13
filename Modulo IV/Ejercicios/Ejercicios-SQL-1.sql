use sbd
go

drop table dbo.emp
drop table dbo.cargos
drop table dbo.deptos


drop table dbo.empleados
drop table dbo.departamentos
go

create table dbo.deptos
(
 nro_depto 		tinyint		not null,
 nom_depto		varchar(20)	not null,
 constraint PK__dbo_deptos__END 
            primary key (nro_depto)
)
go

create table dbo.cargos
(
 nro_cargo 		tinyint		not null,
 nom_cargo		varchar(20)	not null,
 constraint PK__dbo_cargos__END 
            primary key (nro_cargo)
)
go

create table dbo.emp
(
 nro_emp		integer			not null,
 nom_emp		varchar(20)		not null,
 nro_cargo		tinyint			not null,
 salario		decimal(8,2)	not null,
 porc_comision	decimal(4,2)	null,
 fecha_ingreso	date			not null,
 nro_depto		tinyint			not null,
 director		integer			null,
 constraint PK__dbo_emp__END						  
            primary key (nro_emp),
 constraint FK__dbo_emp__dbo_cargos__1__END           
            foreign key (nro_cargo) references dbo.cargos
            on delete cascade
			on update cascade,
 constraint FK__dbo_emp__dbo_deptos__1__END           
            foreign key (nro_depto) references dbo.deptos,
 constraint FK__dbo_emp__dbo_emp__1__END              
            foreign key (director)  references dbo.emp,
 constraint CK__dbo_emp__salario__END                 
            check (salario > 0.00),
 constraint CK__dbo_emp__comision_vendedor__END       
            check (nro_cargo  = 4 and porc_comision is not null or
                   nro_cargo != 4 and porc_comision is null)
)
go

insert into dbo.deptos (nro_depto, nom_depto)
values (10, 'CONTABILIDAD'),
       (20, 'COMPRAS'),
       (30, 'VENTAS'),
       (40, 'PRODUCCION')
go

insert into dbo.cargos (nro_cargo, nom_cargo)
values (1, 'PRESIDENTE')
insert into dbo.cargos (nro_cargo, nom_cargo)
values (2, 'DIRECTOR')
insert into dbo.cargos (nro_cargo, nom_cargo)
values (3, 'ADMINISTRATIVO')
insert into dbo.cargos (nro_cargo, nom_cargo)
values (4, 'VENDEDOR')
insert into dbo.cargos (nro_cargo, nom_cargo)
values (5, 'ADMINISTRATIVO SR')
go

insert into dbo.emp (nro_emp, nom_emp, nro_cargo, salario, porc_comision, fecha_ingreso, nro_depto, director)
values ( 1, 'PEREZ',            1, 3500.00, NULL, '2000-01-01', 10, null),
       ( 2, 'RODRIGUEZ',        2, 2500.00, NULL, '1999-01-01', 10, 1),
       ( 3, 'LOPEZ',            2, 2500.00, NULL, '2000-01-01', 20, 1),
       ( 4, 'DOMINGUEZ',        2, 2500.00, NULL, '1999-07-01', 30, 1),
       ( 5, 'GONZALEZ',         3, 1500.00, NULL, '2000-07-01', 10, 2),
       ( 6, 'MONTERO GONZALEZ', 4, 1200.00, 1.50, '2000-05-01', 10, 2),
       ( 7, 'SANCHEZ',          3, 1500.00, NULL, '2000-08-01', 20, 3),
       ( 8, 'JIMENEZ',          3, 1500.00, NULL, '1999-12-01', 20, 3),
       ( 9, 'MARIANI',          4, 1500.00, 3.00, '2000-02-01', 30, 4),
       (10, 'GIULIANI',         4, 1000.00, 2.15, '2000-03-01', 30, 4)
go

/*
EJERCICIOS:

1.	(nom_emp, nro_depto) de todos los empleados
2.	(todos los datos) de los empleados con salario entre 1500 y 2000
3.	(nro_emp, nom_emp, salario) de los empleados con cargo 'VENDEDOR' o 'ADMINISTRATIVO'
4.	(nom_emp, nom_depto) de todos los empleados
5.	(nom_emp) de los empleados del departamento 'CONTABILIDAD'
6.	(nom_depto) de los departamentos que tengan empleados
7.	(nom_depto) de los departamentos que tengan empleados con cargo 'VENDEDOR'
8.	(nom_depto) de los departamentos que no tengan empleados con cargo 'VENDEDOR'
9.	(nro_emp) de los empleados que trabajan en el mismo departamento que el empleado 'JIMENEZ'
10.	(nro_emp) de los empleados más antiguos que el 'PRESIDENTE'
11.	(nom_depto) de los departamentos que tienen empleados en todos los cargos
12.	(nro_emp, nom_emp, salario_anual) de los empleados con cargo 'VENDEDOR'. (salario_anual = salario*12)
13.	Cantidad de empleados por departamento (nom_depto, cantidad)
14.	Máximo, mínimo y promedio de salarios por departamento (nom_depto, máximo, mínimo, promedio)
15.	Máximo, mínimo y promedio de salarios (máximo, mínimo, promedio)
16.	(nom_depto) de los departamentos que tengan más de 3 empleados
17.	(nro_emp,nro_depto) de los empleados con menor salario en cada departamento
18.	(nro_emp,nro_depto) de los empleados con salario mayor al promedio del departamento
19.	(nro_emp) de los empleados con menor salario que el mayor salario del departamento nro. 30
*/