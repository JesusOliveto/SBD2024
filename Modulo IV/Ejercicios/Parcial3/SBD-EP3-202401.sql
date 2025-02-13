-- INGENIERÍA INFORMÁTICA - SISTEMAS DE BASES DE DATOS
-- EVALUACIÓN PARCIAL Nº 3 - 25-06-2024

/* -----------------------------------------------------------------------------------------------------------------------------------
   Una institución educativa ha implementado una base de datos para sistematizar las actividades académicas. 
   Se registra la siguiente información:

   - Alumnos: Con sus datos personales
   - Carreras: Cada carrera tendrá configurada la cantidad máxima de aplazos que puede tener un alumno para cada 
     materia cursada y la cantidad de años que dura la regularidad conseguida en cada cursado
   - Matrículas: Donde se registra las carreras que cursa cada alumno y su año de ingreso a la misma
   - Materias: Donde se registra cada materia de cada carrera indicando si es obligatoria o no y si corresponde al trabajo final de la 
     carrera o no
   - Cursados: Son los cursados que ha realizado cada alumno en cada materia, indicando el año en el cual cursó la materia y su situación 
     final (regular o libre)
   - Exámenes finales: Se registra las inscripciones a exámenes finales indicando el cursado al cual corresponde el examen, el nro. de libro 
     y acta donde fue registrada la nota, y la nota obtenida (null si estuvo ausente). 
   - Los alumnos solo pueden rendir materias que hayan cursado. No se permite el examen en condición libre

   Se implementó una base de datos a través del script siguiente:
*/

drop table examenes
drop table cursados
drop table matriculas
drop table alumnos
drop table materias
drop table carreras
go

create table carreras
(
 cod_carrera		smallint		not null,
 nom_carrera		varchar(100)	not null,
 nota_aprobacion	tinyint			not null,
 cant_max_aplazos	tinyint			not null,
 años_regularidad	tinyint			not null,
 duracion_carrera	tinyint			not null,
 primary key (cod_carrera)
)
go

create table materias
(
 cod_carrera		smallint		not null,
 cod_materia		char(4)			not null,
 nom_materia		varchar(100)	not null,
 año_materia		smallint		not null,
 obligatoria		char(1)			not null,
 trabajo_final		char(1)			not null,
 primary key (cod_carrera, cod_materia),
 foreign key (cod_carrera) references carreras,
 check (obligatoria in ('S','N')),
 check (trabajo_final in ('S','N'))
)
go

create table alumnos 
(
 nro_alumno			integer			not null,
 nom_alumno			varchar(40)		not null,
 tipo_doc_alumno	varchar(3)		not null,
 nro_doc_alumno		integer			not null,
 primary key (nro_alumno)
)
go

create table matriculas
(
 nro_alumno			integer			not null, 
 cod_carrera		smallint		not null,
 año_ingreso		smallint		not null,
 primary key (nro_alumno, cod_carrera),
 foreign key (nro_alumno) references alumnos,
 foreign key (cod_carrera) references carreras
)
go

create table cursados
(
 cod_carrera		smallint		not null,
 cod_materia		char(4)			not null,
 año_cursado		smallint		not null,
 nro_alumno			integer			not null,
 regular			char(1)			not null,
 primary key (cod_carrera, cod_materia, año_cursado, nro_alumno),
 foreign key (nro_alumno, cod_carrera) references matriculas,
 foreign key (cod_carrera, cod_materia) references materias, 
 check (regular in ('S','N'))
)
go

create table examenes
(
 fecha_examen		smalldatetime	not null,
 cod_carrera		smallint		not null,
 cod_materia		char(4)			not null,
 año_cursado		smallint		not null,
 nro_alumno			integer			not null,
 nro_libro			smallint		not null,
 nro_acta			smallint		not null,
 nota_examen		tinyint			null,
 primary key (nro_alumno, cod_carrera, cod_materia, fecha_examen),
 foreign key (cod_carrera, cod_materia, año_cursado, nro_alumno) references cursados
)
go


-- CARRERAS
insert into carreras (cod_carrera, nom_carrera, nota_aprobacion, cant_max_aplazos, años_regularidad, duracion_carrera)
values (1,'CARRERA 1',4,3,2,4),
       (2,'CARRERA 2',5,2,3,5),
       (3,'CARRERA 3',4,3,2,6),
       (4,'CARRERA 4',5,2,3,4),
       (5,'CARRERA 5',4,3,2,5)
go

-- MATERIAS

insert into materias (cod_carrera, cod_materia, nom_materia, año_materia, obligatoria, trabajo_final)
values (1,'0101','MATERIA 1-0101',1,'S','N'),
       (1,'0102','MATERIA 1-0102',1,'S','N'),
       (1,'0201','MATERIA 1-0201',2,'S','N'),
       (1,'0202','MATERIA 1-0202',2,'N','N'),
       (1,'0301','MATERIA 1-0301',3,'S','N'),
       (1,'0302','MATERIA 1-0302',3,'S','N'),
       (1,'0401','MATERIA 1-0401',4,'S','N'),
       (1,'0402','MATERIA 1-0402',4,'S','S')
go

insert into materias (cod_carrera, cod_materia, nom_materia, año_materia, obligatoria, trabajo_final)
values (2,'0101','MATERIA 2-0101',1,'S','N'),
       (2,'0102','MATERIA 2-0102',1,'S','N'),
       (2,'0201','MATERIA 2-0201',2,'S','N'),
       (2,'0202','MATERIA 2-0202',2,'N','N'),
       (2,'0301','MATERIA 2-0301',3,'S','N'),
       (2,'0302','MATERIA 2-0302',3,'S','N'),
       (2,'0401','MATERIA 2-0401',4,'S','N'),
       (2,'0402','MATERIA 2-0402',4,'S','N'),
       (2,'0403','MATERIA 2-0403',4,'S','N'),
       (2,'0404','MATERIA 2-0404',4,'S','N'),
       (2,'0501','MATERIA 2-0501',5,'N','N'),
       (2,'0502','MATERIA 2-0502',5,'S','N'),
       (2,'0503','MATERIA 2-0503',5,'N','N'),
       (2,'0504','MATERIA 2-0504',5,'S','N')
go

insert into materias (cod_carrera, cod_materia, nom_materia, año_materia, obligatoria, trabajo_final)
values (3,'0101','MATERIA 3-0101',1,'S','N'),
       (3,'0102','MATERIA 3-0102',1,'S','N'),
       (3,'0201','MATERIA 3-0201',2,'S','N'),
       (3,'0202','MATERIA 3-0202',2,'N','N'),
       (3,'0301','MATERIA 3-0301',3,'S','N'),
       (3,'0302','MATERIA 3-0302',3,'S','N'),
       (3,'0401','MATERIA 3-0401',4,'S','N'),
       (3,'0402','MATERIA 3-0402',4,'S','N'),
       (3,'0501','MATERIA 3-0501',5,'S','N'),
       (3,'0502','MATERIA 3-0502',5,'S','N'),
       (3,'0601','MATERIA 3-0601',6,'N','N'),
       (3,'0602','MATERIA 3-0602',6,'S','N')
go

insert into materias (cod_carrera, cod_materia, nom_materia, año_materia, obligatoria, trabajo_final)
values (4,'0101','MATERIA 4-0101',1,'S','N'),
       (4,'0102','MATERIA 4-0102',1,'S','N'),
       (4,'0201','MATERIA 4-0201',2,'S','N'),
       (4,'0202','MATERIA 4-0202',2,'N','N'),
       (4,'0301','MATERIA 4-0301',3,'S','N'),
       (4,'0302','MATERIA 4-0302',3,'S','N'),
       (4,'0401','MATERIA 4-0401',4,'S','N'),
       (4,'0402','MATERIA 4-0402',4,'S','S'),
       (4,'0403','MATERIA 2-0403',4,'S','N'),
       (4,'0404','MATERIA 2-0404',4,'S','S'),
       (4,'0405','MATERIA 2-0405',5,'S','N'),
       (4,'0406','MATERIA 2-0406',5,'S','S')
go

insert into materias (cod_carrera, cod_materia, nom_materia, año_materia, obligatoria, trabajo_final)
values (5,'0101','MATERIA 5-0101',1,'S','N'),
       (5,'0102','MATERIA 5-0102',1,'S','N'),
       (5,'0201','MATERIA 5-0201',2,'S','N'),
       (5,'0202','MATERIA 5-0202',2,'N','N'),
       (5,'0301','MATERIA 5-0301',3,'S','N'),
       (5,'0302','MATERIA 5-0302',3,'S','N'),
       (5,'0401','MATERIA 5-0401',4,'S','N'),
       (5,'0402','MATERIA 5-0402',4,'S','N'),
       (5,'0501','MATERIA 5-0501',5,'N','N'),
       (5,'0502','MATERIA 5-0502',5,'S','N')
go

-- ALUMNOS

insert into alumnos (nro_alumno, nom_alumno, tipo_doc_alumno, nro_doc_alumno)
values (1,'ALUMNO 1','DNI',1),
       (2,'ALUMNO 2','DNI',2),
       (3,'ALUMNO 3','DNI',3),
       (4,'ALUMNO 4','DNI',4),
       (5,'ALUMNO 5','DNI',5),
       (6,'ALUMNO 6','DNI',6),
       (7,'ALUMNO 7','DNI',7),
       (8,'ALUMNO 8','DNI',8),
       (9,'ALUMNO 9','DNI',9),
       (10,'ALUMNO 10','DNI',10)
go

-- MATRICULAS
insert into matriculas (nro_alumno, cod_carrera, año_ingreso)
values (1,1,1996),
       (2,1,1998),
       (3,2,1995),
       (4,2,1997),
       (5,3,1999),
       (6,3,1996),
       (7,4,2000),
       (8,4,1998),
       (9,5,2000),
       (10,5,2001)
go

-- CURSADOS

insert into cursados (cod_carrera, cod_materia, año_cursado, nro_alumno, regular)
values (1,'0101',1996,1,'S'),
       (1,'0102',1996,1,'S'),
       (1,'0201',1997,1,'S'),
       (1,'0301',1998,1,'S'),
       (1,'0302',1998,1,'S'),
       (1,'0401',1999,1,'S')
go

insert into cursados (cod_carrera, cod_materia, año_cursado, nro_alumno, regular)
values (1,'0101',1998,2,'S'),
       (1,'0102',1998,2,'N'),
       (1,'0102',1999,2,'S'),
       (1,'0201',1999,2,'S'),
       (1,'0301',2000,2,'S'),
       (1,'0302',2000,2,'S'),
       (1,'0401',2001,2,'S')
go

insert into cursados (cod_carrera, cod_materia, año_cursado, nro_alumno, regular)
values (2,'0101',1995,3,'S'),
       (2,'0102',1995,3,'S'),
       (2,'0201',1996,3,'S'),
       (2,'0202',1996,3,'S')
go

insert into cursados (cod_carrera, cod_materia, año_cursado, nro_alumno, regular)
values (2,'0101',1997,4,'S'),
       (2,'0102',1997,4,'S'),
       (2,'0201',1998,4,'S'),
       (2,'0202',1998,4,'S'),
       (2,'0301',1999,4,'S'),
       (2,'0302',1999,4,'S'),
       (2,'0403',2000,4,'S'),
       (2,'0404',2000,4,'N'),
       (2,'0404',2001,4,'S'),
       (2,'0503',2001,4,'S')
go

insert into cursados (cod_carrera, cod_materia, año_cursado, nro_alumno, regular)
values (3,'0101',1999,5,'S'),
       (3,'0102',1999,5,'S'),
       (3,'0201',2000,5,'S'),
       (3,'0202',2000,5,'S'),
       (3,'0301',2001,5,'S'),
       (3,'0302',2001,5,'S')
go

insert into cursados (cod_carrera, cod_materia, año_cursado, nro_alumno, regular)
values (3,'0101',1996,6,'S'),
       (3,'0102',1997,6,'S'),
       (3,'0201',1998,6,'S'),
       (3,'0202',1999,6,'S'),
       (3,'0301',2000,6,'S'),
       (3,'0302',2001,6,'S')
go

insert into cursados (cod_carrera, cod_materia, año_cursado, nro_alumno, regular)
values (4,'0101',2000,7,'S'),
       (4,'0102',2000,7,'S'),
       (4,'0201',2001,7,'S'),
       (4,'0202',2001,7,'S')
go

insert into cursados (cod_carrera, cod_materia, año_cursado, nro_alumno, regular)
values (4,'0101',1998,8,'S'),
       (4,'0102',1998,8,'S'),
       (4,'0201',1999,8,'S'),
       (4,'0301',2000,8,'S'),
       (4,'0302',2000,8,'S'),
       (4,'0405',2001,8,'S')
go

insert into cursados (cod_carrera, cod_materia, año_cursado, nro_alumno, regular)
values (5,'0101',2000,9,'S'),
       (5,'0102',2000,9,'S'),
       (5,'0201',2001,9,'S')
go

insert into cursados (cod_carrera, cod_materia, año_cursado, nro_alumno, regular)
values (5,'0101',2001,10,'N'),
       (5,'0102',2001,10,'N')
go

-- EXAMENES
insert into examenes (fecha_examen, cod_carrera, cod_materia, año_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1996-12-20',1,'0101',1996,1,1,1,5),
       ('1996-12-27',1,'0102',1996,1,1,2,4),
       ('1997-12-15',1,'0201',1997,1,2,1,3),
       ('1998-02-15',1,'0201',1997,1,2,2,7),
       ('1998-12-17',1,'0301',1998,1,3,1,6),
       ('1998-12-28',1,'0302',1998,1,3,2,8),
       ('1999-11-18',1,'0401',1999,1,4,2,2),
       ('1999-12-10',1,'0401',1999,1,4,1,null)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, año_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1998-12-20',1,'0101',1998,2,1,1,5),
       ('1999-12-07',1,'0102',1999,2,1,2,4),
       ('1999-12-15',1,'0201',1999,2,2,1,3),
       ('2000-02-15',1,'0201',1999,2,2,2,7),
       ('2000-12-17',1,'0301',2000,2,3,1,null),
       ('2000-12-28',1,'0302',2000,2,3,2,3)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, año_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1995-12-20',2,'0101',1995,3,1,1,4),
       ('1995-12-29',2,'0102',1995,3,1,2,2),
       ('1996-02-20',2,'0102',1995,3,1,3,1)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, año_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1997-12-02',2,'0101',1997,4,1,1,5),
       ('1998-02-02',2,'0101',1997,4,1,3,null),
       ('1997-12-10',2,'0102',1997,4,1,2,7),
       ('1998-12-12',2,'0201',1998,4,1,1,8),
       ('1998-12-22',2,'0202',1998,4,1,2,9),
       ('1999-12-04',2,'0301',1999,4,1,1,10),
       ('1999-12-05',2,'0302',1999,4,1,2,7),
       ('2000-12-11',2,'0403',2000,4,1,1,8),
       ('2001-12-12',2,'0404',2000,4,1,1,3),
       ('2001-12-18',2,'0404',2000,4,1,3,8)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, año_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1999-12-13',3,'0101',1999,5,1,1,5),
       ('1999-12-16',3,'0102',1999,5,1,2,7),
       ('2000-12-11',3,'0201',2000,5,1,1,8),
       ('2000-12-22',3,'0202',2000,5,1,2,10),
       ('2001-12-12',3,'0301',2001,5,1,1,9),
       ('2001-12-23',3,'0302',2001,5,1,2,10)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, año_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1996-12-10',3,'0101',1996,6,1,1,6),
       ('1997-12-11',3,'0102',1997,6,1,1,7),
       ('1998-12-13',3,'0201',1998,6,1,1,8),
       ('1999-12-12',3,'0202',1999,6,1,1,2),
       ('2000-12-13',3,'0301',2000,6,1,1,1),
       ('2001-02-13',3,'0301',2000,6,1,1,2),
       ('2001-07-13',3,'0301',2000,6,1,1,2),
       ('2001-12-12',3,'0302',2001,6,1,1,7)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, año_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('2000-12-15',4,'0101',2000,7,1,1,7),
       ('2000-12-20',4,'0102',2000,7,1,2,6),
       ('2001-12-13',4,'0201',2001,7,1,1,6),
       ('2001-12-19',4,'0202',2001,7,1,2,7)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, año_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('1998-12-10',4,'0101',1998,8,1,1,6),
       ('1998-12-12',4,'0102',1998,8,1,2,10),
       ('1999-12-13',4,'0201',1999,8,1,1,10),
       ('2000-12-14',4,'0301',2000,8,1,1,9),
       ('2000-12-21',4,'0302',2000,8,1,2,7),
       ('2001-12-12',4,'0405',2001,8,1,1,1),
       ('2001-12-22',4,'0405',2001,8,1,2,8)
go

insert into examenes (fecha_examen, cod_carrera, cod_materia, año_cursado, nro_alumno, nro_libro, nro_acta, nota_examen)
values ('2000-12-15',5,'0101',2000,9,1,1,10),
       ('2000-12-27',5,'0102',2000,9,1,2,9),
       ('2001-12-12',5,'0201',2001,9,1,1,8)
go

/*

1. Programar todos los triggers necesarios para asegurar la siguiente regla de integridad: (50)

   "Un alumno no puede inscribirse al examen de una materia para un cursado que ya tiene 
   la cantidad máxima de aplazos"

2. Programar un procedimiento almacenado que reciba como argumento el identificador de una materia y 
   la fecha de examen, y muestre los alumnos que pueden rendirla en esa fecha (50)

   Un alumno puede rendir una materia en una fecha determinada si:

   a. Está regular en la misma, lo que implica:
     - Tiene un registro en cursado con regular = 'S'
     - Para ese registro tiene menos aplazos que la cantidad máxima definida para la carrera
     - Esa regularidad no está vencida (el año de cursado + años de regularidad definidos para la carrera 
	   es mayor al año de la fecha de examen)
   
   b. La materia no está aprobada

   Mostrar: Nro. de alumno, apellido y nombres, y el año de cursado en estado regular
   ------------------------------------------------------------
	nro. alumno		apellido y nombres			año cursado
   ------------------------------------------------------------
     xxxxx			xxxxxxxxxxxxxxxxxxxxxxxxx		xxxx
     xxxxx			xxxxxxxxxxxxxxxxxxxxxxxxx		xxxx
     xxxxx			xxxxxxxxxxxxxxxxxxxxxxxxx		xxxx
     xxxxx			xxxxxxxxxxxxxxxxxxxxxxxxx		xxxx

*/

