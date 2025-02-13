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

---------------------------------------------------------------------------------------------------------

-- 1. Cantidad de materias aprobadas por el alumno 'ALUMNO 1' en la carrera 'CARRERA 3'

select cant_mat_aprobadas = COUNT(distinct cod_materia)
  from examenes e
       join carreras c
	     on e.cod_carrera = c.cod_carrera
       join alumnos a
	     on e.nro_alumno = a.nro_alumno
 where e.nota_examen >= c.nota_aprob_examen_final
   and c.nom_carrera = 'CARRERA 3'
   and a.nom_alumno  = 'ALUMNO 1'

select cant_mat_aprobadas = COUNT(*)
  from examenes e
       join carreras c
	     on e.cod_carrera = c.cod_carrera
        and c.nom_carrera = 'CARRERA 3'
       join alumnos a
	     on e.nro_alumno = a.nro_alumno
        and a.nom_alumno  = 'ALUMNO 1'
 where e.nota_examen >= c.nota_aprob_examen_final

-------------------------------------------------------------------------------------------------------------------------

-- 2. Cantidad de materias no aprobadas por el alumno 'ALUMNO 1' en la carrera 'CARRERA 3'

select COUNT(*)
  from materias m
       join carreras c
	     on m.cod_carrera = c.cod_carrera
 where c.nom_carrera = 'CARRERA 3'
   and not exists (select *
                     from examenes e
					      join alumnos a
						    on e.nro_alumno = a.nro_alumno
					where m.cod_carrera = e.cod_carrera
					  and m.cod_materia = e.cod_materia
					  and c.nota_aprob_examen_final <= e.nota_examen
					  and a.nom_alumno = 'ALUMNO 1')


select COUNT(*)
       -
	   (select COUNT(distinct cod_materia)
          from examenes e
               join carreras c1
	             on e.cod_carrera = c1.cod_carrera
               join alumnos a
	             on e.nro_alumno = a.nro_alumno
         where e.nota_examen >= c1.nota_aprob_examen_final
           and c1.nom_carrera = 'CARRERA 3'
           and a.nom_alumno  = 'ALUMNO 1') as cant_no_aprobadas
  from materias m
       join carreras c
	     on m.cod_carrera = c.cod_carrera
 where c.nom_carrera = 'CARRERA 3'

select COUNT(*)
       -
	   (select COUNT(distinct cod_materia)
          from examenes e
               join alumnos a
	             on e.nro_alumno = a.nro_alumno
         where e.nota_examen >= max(c.nota_aprob_examen_final)
		   and e.cod_carrera = max(c.cod_carrera)
           and a.nom_alumno  = 'ALUMNO 1') as cant_no_aprobadas
  from materias m
       join carreras c
	     on m.cod_carrera = c.cod_carrera
 where c.nom_carrera = 'CARRERA 3'

select COUNT(*)
       -
	   (select COUNT(distinct cod_materia)
          from examenes e
               join alumnos a
	             on e.nro_alumno = a.nro_alumno
         where e.nota_examen >= c.nota_aprob_examen_final
		   and e.cod_carrera = c.cod_carrera
           and a.nom_alumno  = 'ALUMNO 1') as cant_no_aprobadas
  from materias m
       join carreras c
	     on m.cod_carrera = c.cod_carrera
 where c.nom_carrera = 'CARRERA 3'
 group by c.cod_carrera, c.nota_aprob_examen_final

select COUNT(*), c.nota_aprob_examen_final
  from materias m
       join carreras c
	     on m.cod_carrera = c.cod_carrera
 where c.nom_carrera = 'CARRERA 3'
 group by c.cod_carrera

select COUNT(*), max(c.nota_aprob_examen_final)
  from materias m
       join carreras c
	     on m.cod_carrera = c.cod_carrera
 where c.nom_carrera = 'CARRERA 3'
 group by c.cod_carrera

select COUNT(*), c.nota_aprob_examen_final
  from materias m
       join carreras c
	     on m.cod_carrera = c.cod_carrera
 where c.nom_carrera = 'CARRERA 3'
 group by c.cod_carrera, c.nota_aprob_examen_final

--------------------------------------------------------------------------------------

-- 3. Mostrar nro_alumno y nom_alumno de aquellos alumnos que no han rendido exámenes finales en 
--    ninguna carrera desde el 01/01/2019.

select *
  from alumnos a
 where not exists (select *
                     from examenes e
					where a.nro_alumno = e.nro_alumno
					  and e.nota_examen is not null
					  and e.fecha_examen >= '2016-01-01')

-------------------------------------------------------------------------------------------------------------------

-- 4. Mostrar nro_alumno, nom_alumno, cod_carrera, nom_carrera y promedio de los alumnos que 
   -- ingresaron en 2015 y tienen promedio >= 7 y han rendido más de 20 exámenes finales 
   -- (no considerar los ausentes)

select e.nro_alumno, a.nom_alumno, e.cod_carrera, c.nom_carrera, AVG(e.nota_examen) promedio
  from examenes e
       join matriculas m
	     on e.nro_alumno = m.nro_alumno
		and e.cod_carrera = m.cod_carrera
	   join alumnos a
	     on e.nro_alumno = a.nro_alumno
	   join carreras c
	     on e.cod_carrera = c.cod_carrera
 where m.ano_ingreso = 2015
 group by e.nro_alumno, a.nom_alumno, e.cod_carrera, c.nom_carrera
having AVG(e.nota_examen) >= 7
   and COUNT(e.nota_examen) > 4
 order by promedio asc

select m.nro_alumno, max(a.nom_alumno), m.cod_carrera, max(c.nom_carrera), avg(e.nota_examen), count(e.nota_examen)
  from dbo.matriculas m
       join dbo.alumnos a
	     on m.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
       join dbo.examenes e
	     on m.nro_alumno = e.nro_alumno
		and m.cod_carrera = e.cod_carrera
 where m.ano_ingreso = 1995
 group by m.nro_alumno, m.cod_carrera
having avg(e.nota_examen) >= 7
   and count(e.nota_examen) > 4


-- 5. Mostrar nro_alumno y nom_alumno de aquellos alumnos de la carrera 1 que ingresaron en 1995 
--    y tienen aprobadas todas las materias obligatorias de dicha carrera hasta el tercer 
--    cuatrimestre inclusive.

select *
  from dbo.matriculas m
       join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
 where m.ano_ingreso = 2015
   and c.nom_carrera = 'CARRERA 1'
   and not exists (select *
                     from dbo.materias ma
					where m.cod_carrera    = ma.cod_carrera
					  and ma.optativa      = 'N'
					  and ma.cuat_materia <= 3
					  and not exists (select *
					                    from dbo.examenes e
									   where ma.cod_carrera = e.cod_carrera
									     and ma.cod_materia = e.cod_materia
										 and m.nro_alumno   = e.nro_alumno
										 and e.nota_examen >= c.nota_aprob_examen_final))

select a.nro_alumno, a.nom_alumno
  from dbo.matriculas m
       join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
       join dbo.alumnos a
	     on m.nro_alumno = a.nro_alumno
 where m.ano_ingreso = 2015
   and c.nom_carrera = 'CARRERA 1'
   and (select count(*)
          from dbo.materias ma
		 where m.cod_carrera    = ma.cod_carrera
		   and ma.optativa      = 'N'
		   and ma.cuat_materia <= 3) = (select COUNT(distinct e.cod_materia)
					                      from dbo.examenes e
										       join dbo.materias ma1
											     on e.cod_carrera = ma1.cod_carrera
												and e.cod_materia = ma1.cod_materia
                                                and m.cod_carrera = ma1.cod_carrera
												and ma1.optativa  = 'N'
												and ma1.cuat_materia <= 3
									     where m.nro_alumno   = e.nro_alumno
										   and e.nota_examen >= c.nota_aprob_examen_final)

-- Obtener los egresados
select a.nro_alumno, a.nom_alumno, c.cod_carrera, c.nom_carrera
  from dbo.matriculas m
       join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
       join dbo.alumnos a
	     on m.nro_alumno = a.nro_alumno
 where (select count(*)
          from dbo.materias ma
		 where m.cod_carrera    = ma.cod_carrera
		   and ma.optativa      = 'N') = (select COUNT(distinct e.cod_materia)
					                        from dbo.examenes e
										         join dbo.materias ma1
											       on e.cod_carrera = ma1.cod_carrera
												  and e.cod_materia = ma1.cod_materia
                                                  and m.cod_carrera = ma1.cod_carrera
												  and ma1.optativa  = 'N'
									      where m.nro_alumno   = e.nro_alumno
										    and e.nota_examen >= c.nota_aprob_examen_final)

select *
  from dbo.matriculas m
       join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
 where not exists (select *
                     from dbo.materias ma
					where c.cod_carrera    = ma.cod_carrera
					  and ma.optativa      = 'N'
					  and not exists (select *
					                    from dbo.examenes e
									   where ma.cod_carrera = e.cod_carrera
									     and ma.cod_materia = e.cod_materia
										 and m.nro_alumno   = e.nro_alumno
										 and e.nota_examen >= c.nota_aprob_examen_final))

-- vistas
create or alter view dbo.v_egresados (nro_alumno, cod_carrera)
as
select m.nro_alumno, m.cod_carrera
  from dbo.matriculas m
       join dbo.carreras c
	     on m.cod_carrera = c.cod_carrera
 where (select count(*)
          from dbo.materias ma
		 where m.cod_carrera    = ma.cod_carrera
		   and ma.optativa      = 'N') = (select COUNT(distinct e.cod_materia)
					                        from dbo.examenes e
										         join dbo.materias ma1
											       on e.cod_carrera = ma1.cod_carrera
												  and e.cod_materia = ma1.cod_materia
                                                  and m.cod_carrera = ma1.cod_carrera
												  and ma1.optativa  = 'N'
									      where m.nro_alumno   = e.nro_alumno
										    and e.nota_examen >= c.nota_aprob_examen_final);

select e.nro_alumno, a.nom_alumno, e.cod_carrera, c.nom_carrera
  from dbo.v_egresados e
       join dbo.alumnos a
	     on e.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera
 where c.nom_carrera = 'CARRERA 1'


-- vistas actualizables
create or alter view dbo.v_matriculas (nro_alumno, cod_carrera, ano_ingreso, numero_alumno, tipo_doc_alumno, nro_doc_alumno, nom_alumno)
as
select m.nro_alumno, m.cod_carrera, m.ano_ingreso, a.nro_alumno, a.tipo_doc_alumno, a.nro_doc_alumno, a.nom_alumno
  from dbo.matriculas m
       join dbo.alumnos a
	     on m.nro_alumno = a.nro_alumno


select * from dbo.v_matriculas

-- insert
insert into dbo.v_matriculas (nro_alumno, cod_carrera, ano_ingreso)
values (3, 3, 1990)
insert into dbo.v_matriculas (numero_alumno, tipo_doc_alumno, nro_doc_alumno, nom_alumno)
values (11, 'DNI', 11111111, 'ALUMNO 11')

-- update
update m
   set ano_ingreso = 1991
--select *  
  from dbo.v_matriculas m
 where m.nro_alumno = 1
   and m.cod_carrera = 1

select * from matriculas
select * from alumnos


-- funciones
create function dbo.fn_egresados 
(
 @cod_carrera	smallint = null
)
returns table
as
return (select m.nro_alumno, m.cod_carrera
          from dbo.matriculas m
               join dbo.carreras c
	             on m.cod_carrera = c.cod_carrera
         where (
	            @cod_carrera = m.cod_carrera
	   		    or
	   		    @cod_carrera is null
	   	       )
	       and (select count(*)
                  from dbo.materias ma
        	 	 where m.cod_carrera    = ma.cod_carrera
        		   and ma.optativa      = 'N') = (select COUNT(distinct e.cod_materia)
        					                        from dbo.examenes e
        										         join dbo.materias ma1
        											       on e.cod_carrera = ma1.cod_carrera
        												  and e.cod_materia = ma1.cod_materia
                                                         and m.cod_carrera = ma1.cod_carrera
        												  and ma1.optativa  = 'N'
        									      where m.nro_alumno   = e.nro_alumno
        										    and e.nota_examen >= c.nota_aprob_examen_final));

select a.nro_alumno, a.nom_alumno, c.cod_carrera, c.nom_carrera
  from dbo.fn_egresados (1) e
       join dbo.alumnos a
	     on e.nro_alumno = a.nro_alumno
	   join dbo.carreras c
	     on e.cod_carrera = c.cod_carrera

select a.nro_alumno, a.nom_alumno, c.cod_carrera, c.nom_carrera
  from dbo.carreras c
	   join dbo.fn_egresados (null) e
	     on e.cod_carrera = c.cod_carrera
       join dbo.alumnos a
	     on e.nro_alumno = a.nro_alumno

select *
  from dbo.fn_egresados (null)
select *
  from dbo.fn_egresados (default)

create function dbo.fn_egresados_v2 
(
 @cod_carrera	smallint = null
)
returns @egresados table
        (
		 nro_alumno		integer		not null,
		 cod_carrera	smallint	not null
        )
as
begin
        insert into @egresados (nro_alumno, cod_carrera)
        select m.nro_alumno, m.cod_carrera
          from dbo.matriculas m
               join dbo.carreras c
	             on m.cod_carrera = c.cod_carrera
         where (
	            @cod_carrera = m.cod_carrera
	   		    or
	   		    @cod_carrera is null
	   	       )
	       and (select count(*)
                  from dbo.materias ma
        	 	 where m.cod_carrera    = ma.cod_carrera
        		   and ma.optativa      = 'N') = (select COUNT(distinct e.cod_materia)
        					                        from dbo.examenes e
        										         join dbo.materias ma1
        											       on e.cod_carrera = ma1.cod_carrera
        												  and e.cod_materia = ma1.cod_materia
                                                         and m.cod_carrera = ma1.cod_carrera
        												  and ma1.optativa  = 'N'
        									      where m.nro_alumno   = e.nro_alumno
        										    and e.nota_examen >= c.nota_aprob_examen_final)
return 
end

select a.nro_alumno, a.nom_alumno, c.cod_carrera, c.nom_carrera
  from dbo.carreras c
	   join dbo.fn_egresados_v2 (null) e
	     on e.cod_carrera = c.cod_carrera
       join dbo.alumnos a
	     on e.nro_alumno = a.nro_alumno

create function dbo.fn_es_egresado 
(
 @nro_alumno	integer,
 @cod_carrera	smallint
)
returns char(1)
as
begin
   declare @egresado char(1)

   if exists (select *
                from dbo.matriculas m
                     join dbo.carreras c
	                   on m.cod_carrera = c.cod_carrera
               where m.nro_alumno  = @nro_alumno
			     and m.cod_carrera = @cod_carrera
	             and (select count(*)
                        from dbo.materias ma
        	 	       where m.cod_carrera    = ma.cod_carrera
        		         and ma.optativa      = 'N') = (select COUNT(distinct e.cod_materia)
        				       	                          from dbo.examenes e
        				       						           join dbo.materias ma1
        				       							         on e.cod_carrera = ma1.cod_carrera
        				       								    and e.cod_materia = ma1.cod_materia
                                                                and m.cod_carrera = ma1.cod_carrera
        				       								    and ma1.optativa  = 'N'
        				       					         where m.nro_alumno   = e.nro_alumno
        				       						       and e.nota_examen >= c.nota_aprob_examen_final))
      begin
	     set @egresado = 'S'
	  end
   else
      begin
	     set @egresado = 'N'
	  end

return @egresado

end

select m.nro_alumno, m.cod_carrera, dbo.fn_es_egresado (m.nro_alumno, m.cod_carrera)
  from dbo.matriculas m
 where dbo.fn_es_egresado(m.nro_alumno, m.cod_carrera) = 'S'

alter table matriculas 
add egresado as dbo.fn_es_egresado(nro_alumno, cod_carrera)

select *
from matriculas
where egresado = 'S'

select *
from matriculas

select top 2 with ties m.nro_alumno, m.cod_carrera, AVG(e.nota_examen) promedio
--select m.nro_alumno, m.cod_carrera, AVG(e.nota_examen) promedio
  from matriculas m
       join examenes e 
	     on m.nro_alumno = e.nro_alumno
		and m.cod_carrera = e.cod_carrera
 where m.egresado = 'S'
 group by m.nro_alumno, m.cod_carrera
 order by promedio desc

select top 50 percent with ties m.nro_alumno, m.cod_carrera, AVG(e.nota_examen) promedio
--select m.nro_alumno, m.cod_carrera, AVG(e.nota_examen) promedio
  from matriculas m
       join examenes e 
	     on m.nro_alumno = e.nro_alumno
		and m.cod_carrera = e.cod_carrera
 where m.egresado = 'S'
 group by m.nro_alumno, m.cod_carrera
 order by promedio desc

