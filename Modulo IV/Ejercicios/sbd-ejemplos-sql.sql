use sbd
go

drop table dbo.empleados
drop table dbo.departamentos

create table dbo.departamentos
(
 nro_depto			tinyint		not null	identity(10,10),
 nom_depto			varchar(40)	not null,
 constraint PK__departamentos__END primary key (nro_depto),
 constraint UK__departamentos__1__END unique (nom_depto)
)

create table dbo.empleados 
(
 nro_emp			smallint		not null,
 nom_emp			varchar(40)		not null,
 fecha_ingreso		date			not null,
 cargo				varchar(20)		not null,
 salario			decimal(12,2)	not null,
 nro_depto			tinyint			not null,
 porc_comision		decimal(4,2)	null,
 constraint PK__empleados__END 
            primary key (nro_emp),
 constraint FK__empleados__departamentos__1__END 
            foreign key (nro_depto) references dbo.departamentos,
 constraint CK__empleados_salario__END 
            check(salario > 0.00),
 constraint CK__empleados__cargo_comision__END
            check(cargo = 'VENDEDOR' and porc_comision > 0.00 or
                  cargo != 'VENDEDOR' and porc_comision is null)
)

select *
  from sys.objects 
 where type = 'U'
   and name in ('departamentos','empleados')
   and schema_id = 1

select *
  from sys.columns
 where object_id in (801437929,849438100)

insert into dbo.departamentos (nom_depto)
values ('CONTABILIDAD'),
       ('VENTAS'),
	   ('SISTEMAS'),
	   ('COMPRAS')

select nro_depto, nom_depto
  from dbo.departamentos

insert into dbo.empleados (nro_emp, nom_emp, fecha_ingreso, cargo, salario, nro_depto, porc_comision)
values (1, 'GIMENEZ', '2001-01-01', 'ADMINISTRATIVO', 1500.00, 10,  NULL),
       (2, 'PEREZ',   '2010-05-02', 'VENDEDOR',       2000.00, 20, 15.00),
       (3, 'GOMEZ',   '2020-07-02', 'GERENTE',        1000.00, 30, NULL),
       (4, 'SALINAS', '2014-11-12', 'VENDEDOR',       2100.00, 20,  5.00),
       (5, 'MENENDEZ','2021-01-31', 'ANALISTA',       3000.00, 30, NULL),
       (6, 'ARREGUI', '2013-03-01', 'ADMINISTRATIVO', 2500.00, 10, NULL),
       (7, 'JUAREZ',  '2013-03-01', 'ADMINISTRATIVO', 2500.00, 10, NULL)

select *
  from dbo.empleados

select *
  from dbo.departamentos, dbo.empleados
 where departamentos.nro_depto = empleados.nro_depto

select e.*, d.nom_depto
  from dbo.departamentos d, dbo.empleados e
 where d.nro_depto = e.nro_depto

select e.*, d.nom_depto
  from dbo.departamentos d
       join dbo.empleados e
         on d.nro_depto = e.nro_depto

select *
--delete d 
  from dbo.departamentos d
 where not exists (select *
                     from dbo.empleados e
					where d.nro_depto = e.nro_depto)

select *
--delete d 
  from dbo.departamentos d
 where (select count(*)
          from dbo.empleados e
		 where d.nro_depto = e.nro_depto) = 0


update e
   set salario = salario * 1.20
--select *
  from dbo.departamentos d
       join dbo.empleados e
		 on d.nro_depto = e.nro_depto
		and d.nom_depto = 'VENTAS'

select *
  from dbo.departamentos d
       left join dbo.empleados e
		 on d.nro_depto = e.nro_depto
 where e.cargo = 'VENDEDOR'

select *
  from dbo.departamentos d
       left join dbo.empleados e
		 on d.nro_depto = e.nro_depto
        and e.cargo = 'VENDEDOR'

select d.nro_depto, d.nom_depto, count(iif(e.nro_emp is not null, 1, null)) cant_emp
  from dbo.departamentos d
       left join dbo.empleados e
	     on d.nro_depto = e.nro_depto
 group by d.nro_depto, d.nom_depto
--having count(*) > 2
 order by count(*) desc, d.nom_depto

 select d.nro_depto, d.nom_depto, count(case when e.nro_emp is not null then 1 else null end) cant_emp
  from dbo.departamentos d
       left join dbo.empleados e
	     on d.nro_depto = e.nro_depto
 group by d.nro_depto, d.nom_depto
--having count(*) > 2
 order by count(*) desc, d.nom_depto
