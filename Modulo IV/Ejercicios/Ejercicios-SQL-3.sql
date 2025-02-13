drop table examenes
drop table materias
drop table matriculas
drop table alumnos
drop table carreras
go

create table carreras
(
 cod_carrera				smallint		not null primary key,
 nom_carrera				varchar(40)		not null unique,
 nota_aprob_examen_final	tinyint			not null check (nota_aprob_examen_final > 0) default 4
)
go

create table materias
(
 cod_carrera		smallint	not null references carreras,
 cod_materia		varchar(10)	not null,
 nom_materia		varchar(40)	not null,
 cuat_materia		tinyint		not null check ( cuat_materia > 0 ),
 optativa			char(1)		not null check ( optativa in ('S','N')),
 primary key (cod_carrera, cod_materia)
)
go

create table alumnos
(
 nro_alumno			integer		 not null primary key,
 nom_alumno			varchar(40)  not null,
 tipo_doc_alumno	varchar(3)   not null default 'DNI',
 nro_doc_alumno		integer		 not null unique
)
go

create table matriculas
(
 nro_alumno			integer		not null references alumnos,
 cod_carrera		smallint	not null references carreras,
 ano_ingreso		smallint	not null,
 primary key (nro_alumno, cod_carrera)
)
go

create table examenes
(
 nro_alumno			integer			not null,
 cod_carrera		smallint		not null,
 cod_materia		varchar(10)		not null,
 fecha_examen		date			not null,
 nro_libro			smallint		not null,
 nro_acta			tinyint			not null,
 nota_examen		decimal(4,2)	null,
 primary key (nro_libro, nro_acta, nro_alumno),
 unique (nro_alumno, cod_carrera, cod_materia, fecha_examen),
 foreign key (nro_alumno, cod_carrera) references matriculas,
 foreign key (cod_carrera, cod_materia) references materias
)
go

insert into alumnos (nro_alumno, nom_alumno, nro_doc_alumno)
values ( 1,'ALUMNO 1', 11111111),
       ( 2,'ALUMNO 2', 22222222),
       ( 3,'ALUMNO 3', 33333333),
       ( 4,'ALUMNO 4', 44444444),
       ( 5,'ALUMNO 5', 55555555),
       ( 6,'ALUMNO 6', 66666666),
       ( 7,'ALUMNO 7', 77777777),
       ( 8,'ALUMNO 8', 88888888),
       ( 9,'ALUMNO 9', 99999999),
       (10,'ALUMNO 10',10101010)
go

insert into carreras (cod_carrera, nom_carrera, nota_aprob_examen_final)
values (1,'CARRERA 1',4),
       (2,'CARRERA 2',4),
       (3,'CARRERA 3',6)
go

insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (1,1,'MATERIA 1-1',1,'S'),
       (1,2,'MATERIA 1-2',2,'N'),
       (1,3,'MATERIA 1-3',3,'N'),
       (1,4,'MATERIA 1-4',4,'N'),
       (1,5,'MATERIA 1-5',5,'N')

insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (2,1,'MATERIA 2-1',1,'N'),
       (2,2,'MATERIA 2-2',2,'S'),
       (2,3,'MATERIA 2-3',3,'N'),
       (2,4,'MATERIA 2-4',4,'N'),
       (2,5,'MATERIA 2-5',5,'N')

insert into materias (cod_carrera, cod_materia, nom_materia, cuat_materia, optativa)
values (3,1,'MATERIA 3-1',1,'N'),
       (3,2,'MATERIA 3-2',2,'N'),
       (3,3,'MATERIA 3-3',3,'S'),
       (3,4,'MATERIA 3-4',4,'N'),
       (3,5,'MATERIA 3-5',5,'N')
go

insert into matriculas (nro_alumno, cod_carrera, ano_ingreso)
values ( 1,1,2015),
       ( 2,1,2015),
       ( 3,1,2015),
       ( 4,1,2015),
       ( 5,1,2015),
       ( 6,2,2015),
       ( 7,2,2016),
       ( 8,2,2016),
       ( 9,2,2016),
       (10,2,2016),
       ( 1,3,2016),
       ( 6,3,2016)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,1,1,'2015-06-10',1,1,10),
       (1,1,2,'2015-06-11',1,2,9),
       (1,1,3,'2015-06-12',1,3,8),
       (1,1,4,'2015-06-13',1,4,7),
       (1,1,5,'2015-06-14',1,5,6)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (2,1,2,'2015-06-11',1,1,9),
       (2,1,3,'2015-06-12',1,2,8),
       (2,1,4,'2015-06-13',1,3,7),
       (2,1,5,'2015-06-14',1,4,6)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (3,1,1,'2016-06-11',1,1,10),
       (3,1,3,'2016-06-12',1,2,9),
       (3,1,4,'2016-06-13',1,3,8),
       (3,1,5,'2016-06-14',1,4,7)
go
 
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (4,1,2,'2016-06-11',1,1,10),
       (4,1,3,'2016-06-12',1,2,10),
       (4,1,4,'2016-06-13',1,3,10),
       (4,1,5,'2016-06-14',1,4,9)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (5,1,1,'2015-06-11',1,1,10),
       (5,1,2,'2015-06-12',1,2,null),
       (5,1,2,'2015-06-13',1,3,null),
       (5,1,2,'2016-06-14',1,4,10),
       (5,1,3,'2016-06-15',1,5,6),
       (5,1,4,'2016-06-16',1,6,6),
       (5,1,5,'2016-06-17',1,7,6)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,2,1,'2016-06-10',1,1,10),
       (6,2,2,'2016-06-11',1,2,10),
       (6,2,3,'2016-06-12',1,3,10)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (7,2,1,'2016-06-11',1,1,5),
       (7,2,3,'2016-06-12',1,2,5),
       (7,2,4,'2017-06-13',1,3,5),
       (7,2,5,'2017-06-14',1,4,5)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (8,2,1,'2018-06-11',1,1,10),
       (8,2,3,'2018-06-12',1,2,10),
       (8,2,4,'2020-06-13',1,3,10),
       (8,2,5,'2020-06-14',1,4,10)
go
 
insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (9,2,1,'2016-06-11',1,1,10),
       (9,2,3,'2017-06-12',1,2,10),
       (9,2,4,'2018-06-13',1,3,10),
       (9,2,5,'2019-06-14',1,4,10)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (10,2,1,'2016-06-11',1,1,5),
       (10,2,2,'2016-06-08',3,2,null),
       (10,2,2,'2017-06-09',4,2,null),
       (10,2,2,'2017-06-12',1,2,null),
       (10,2,2,'2017-06-18',1,3,1),
       (10,2,3,'2018-06-15',1,5,8),
       (10,2,4,'2019-06-16',1,6,6),
       (10,2,5,'2021-06-17',1,7,6)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,1,'2016-06-13',3,1,null),
       (1,3,2,'2016-06-14',3,2,10)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (1,3,1,'2018-06-10',2,1,4),
       (1,3,2,'2018-06-11',2,2,5),
       (1,3,3,'2018-06-12',2,3,6),
       (1,3,4,'2022-06-10',2,4,7),
       (1,3,5,'2022-06-10',2,5,8)
go

insert into examenes (nro_alumno, cod_carrera, cod_materia, fecha_examen, nro_libro, nro_acta, nota_examen)
values (6,3,1,'2016-06-10',2,1,10),
       (6,3,2,'2016-06-11',2,2,10),
       (6,3,3,'2019-06-12',2,3,10),
       (6,3,4,'2019-06-12',1,4,10),
       (6,3,5,'2019-06-12',1,5,10)
go

/* 
EJERCICIOS:

1. Cantidad de materias aprobadas por el alumno 'ALUMNO 1' en la carrera 'CARRERA 3'
2. Cantidad de materias no aprobadas por el alumno 'ALUMNO 1' en la carrera 'CARRERA 3'
3. Mostrar nro_alumno y nom_alumno de aquellos alumnos que no han rendido exámenes finales en 
   ninguna carrera desde el 01/01/2019.
4. Mostrar nro_alumno, nom_alumno, cod_carrera, nom_carrera y promedio de los alumnos que ingresaron
   en 2015 y tienen promedio >= 7 y han rendido más de 20 exámenes finales (no considerar los ausentes)
5. Mostrar nro_alumno y nom_alumno de aquellos alumnos de la carrera 1 que ingresaron en 2015
   y tienen aprobadas todas las materias obligatorias de dicha carrera hasta el tercer 
   cuatrimestre inclusive.
*/

/*1. Cantidad de materias aprobadas por el alumno 'ALUMNO 1' en la carrera 'CARRERA 3'*/
select count(distinct cod_materia) as aprobadasAlumno1Carrera3
	from examenes e join alumnos a on e.nro_alumno=a.nro_alumno 
					join carreras c on e.cod_carrera=c.cod_carrera
where nom_alumno='ALUMNO 1' and nom_carrera='CARRERA 3' and nota_examen>=nota_aprob_examen_final

select * from examenes
where nro_alumno=1 and cod_carrera=3 and nota_examen>=6

/*2. Cantidad de materias no aprobadas por el alumno 'ALUMNO 1' en la carrera 'CARRERA 3'*/

select count(*) as reprobadasAlumno1Carrera3
	from materias m join carreras c on m.cod_carrera=c.cod_carrera
where nom_carrera='CARRERA 3' and not exists (select *
													from examenes e
														join alumnos a on e.nro_alumno=a.nro_alumno
													where m.cod_carrera=e.cod_carrera
														and m.cod_materia=e.cod_materia
														and c.nota_aprob_examen_final<=e.nota_examen
														and	a.nom_alumno='ALUMNO 1'
														)

SELECT COUNT(*) AS cant_materias_no_aprobadas
FROM materias m
LEFT JOIN examenes e ON m.cod_carrera = e.cod_carrera
                      AND m.cod_materia = e.cod_materia
                      AND e.nro_alumno = 1
LEFT JOIN carreras c ON m.cod_carrera = c.cod_carrera
WHERE m.cod_carrera = 3
      AND e.nota_examen IS NULL;

/*3. Mostrar nro_alumno y nom_alumno de aquellos alumnos que no han rendido exámenes finales en 
   ninguna carrera desde el 01/01/2019.*/

SELECT nro_alumno, nom_alumno
FROM alumnos a
WHERE NOT EXISTS (
    SELECT *
    FROM examenes e
    WHERE e.nro_alumno = a.nro_alumno
		and e.nota_examen is not null
        AND e.fecha_examen >= '2019-01-01'
)

/*4. Mostrar nro_alumno, nom_alumno, cod_carrera, nom_carrera y promedio de los alumnos que ingresaron
   en 2015 y tienen promedio >= 7 y han rendido más de 20 exámenes finales (no considerar los ausentes)*/

select e.nro_alumno,a.nom_alumno, e.cod_carrera, c.nom_carrera, avg(e.nota_examen) as promedio
	from examenes e join matriculas m on e.nro_alumno=m.nro_alumno and e.cod_carrera=m.cod_carrera
					join alumnos a on e.nro_alumno=a.nro_alumno
					join carreras c on e.cod_carrera=c.cod_carrera
where ano_ingreso=2015
group by e.nro_alumno, a.nom_alumno, e.cod_carrera, c.nom_carrera
having avg(e.nota_examen)>=7
	and COUNT(e.nota_examen) > 4


