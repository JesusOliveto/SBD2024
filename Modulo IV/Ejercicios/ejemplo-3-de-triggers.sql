alter table matriculas add egresado char(1) not null default 'N' check (egresado in ('S','N'))

-- Asegurar consistencia entre columna "egresado" en matrículas y datos de la base de datos

-- 1. Consulta de egresados
select *
  from matriculas m 
       join carreras c
	     on m.cod_carrera = c.cod_carrera
 where (select count(*)
          from materias ma 
		 where m.cod_carrera  = ma.cod_carrera
		   and ma.obligatoria = 'S')
       =
	   (select count(distinct ma1.cod_materia)
          from materias ma1 
		       join examenes e
			     on m.nro_alumno = e.nro_alumno
				and ma1.cod_carrera = e.cod_carrera
				and ma1.cod_materia = e.cod_materia
				and e.nota_examen  >= c.nota_aprobacion
		 where m.cod_carrera   = ma1.cod_carrera
		   and ma1.obligatoria = 'S')

-- 2. Determinación de triggers para asegurar consistencia en base a la consulta anterior

------------------------------------------------------------------------------------------------------
-- tabla		insert					delete					update				
------------------------------------------------------------------------------------------------------
-- matriculas	Controlar que sea 'N'	No						Verificar consistencia y corregir (cambio de columna egresado)
------------------------------------------------------------------------------------------------------
-- carreras		No						No						Propagar actualización (cambio de nota de aprobación)
------------------------------------------------------------------------------------------------------
-- materias		Propagar actualización	Propagar actualización	Propagar actualización (cambio en obligatoriedad, de carrera)
------------------------------------------------------------------------------------------------------
-- examenes		Propagar actualización	Propagar actualización	Propagar actualización (cambio de nota de examen, carrera, materia, legajo)
------------------------------------------------------------------------------------------------------

--3. Programar los triggers

create trigger ti_pa_examenes
on dbo.examenes
for insert
as
begin
   update m
      set egresado = 'S'
--   select *
     from matriculas m 
          join carreras c
	        on m.cod_carrera = c.cod_carrera
    -- restringir las matrículas a analizar 
    where m.egresado = 'N'
	  and exists (select *
	                from inserted i
					     join materias ma1
						   on i.cod_carrera   = ma1.cod_carrera
						  and i.cod_materia   = ma1.cod_materia
						  and ma1.obligatoria = 'S'
				   where m.nro_alumno   = i.nro_alumno
				     and m.cod_carrera  = i.cod_carrera
					 and i.nota_examen >= c.nota_aprobacion)
      -- analisis de las condiciones para ser egresado
	  and (select count(*)
             from materias ma 
		    where m.cod_carrera  = ma.cod_carrera
		      and ma.obligatoria = 'S')
          =
	      (select count(distinct ma1.cod_materia)
             from materias ma1 
		          join examenes e
			        on m.nro_alumno = e.nro_alumno
				   and ma1.cod_carrera = e.cod_carrera
				   and ma1.cod_materia = e.cod_materia
				   and e.nota_examen  >= c.nota_aprobacion
		    where m.cod_carrera   = ma1.cod_carrera
		      and ma1.obligatoria = 'S')
end
go

create trigger td_pa_examenes
on dbo.examenes
for delete
as
begin
   update m
      set egresado = 'N'
--   select *
     from matriculas m 
          join carreras c
	        on m.cod_carrera = c.cod_carrera
    -- restringir las matrículas a analizar 
    where m.egresado = 'S'
	  and exists (select *
	                from deleted d
					     join materias ma1
						   on d.cod_carrera   = ma1.cod_carrera
						  and d.cod_materia   = ma1.cod_materia
						  and ma1.obligatoria = 'S'
				   where m.nro_alumno   = d.nro_alumno
				     and m.cod_carrera  = d.cod_carrera
					 and d.nota_examen >= c.nota_aprobacion)
      -- analisis de las condiciones para ser egresado
	  and (select count(*)
             from materias ma 
		    where m.cod_carrera  = ma.cod_carrera
		      and ma.obligatoria = 'S')
          >
	      (select count(distinct ma1.cod_materia)
             from materias ma1 
		          join examenes e
			        on m.nro_alumno = e.nro_alumno
				   and ma1.cod_carrera = e.cod_carrera
				   and ma1.cod_materia = e.cod_materia
				   and e.nota_examen  >= c.nota_aprobacion
		    where m.cod_carrera   = ma1.cod_carrera
		      and ma1.obligatoria = 'S')
end
go

create trigger tu_pa_examenes
on dbo.examenes
for update
as
begin
/*
   if @@rowcount > 1
      begin
	     raiserror ('No se puede modificar más de examen', 16, 1)
		 rollback
		 return
	  end
*/	  
   if update(nro_alumno) or update(cod_carrera) or update(cod_materia) or update(fecha_examen)
      begin
	     raiserror ('No se puede modificar el alumno, la carrera o la materia de un examen', 16, 1)
		 rollback
		 return
	  end

   update m
      set egresado = case when m.egresado = 'S'
	                       and (select count(*)
								  from materias ma 
								 where m.cod_carrera  = ma.cod_carrera
								   and ma.obligatoria = 'S')
								>
								(select count(distinct ma1.cod_materia)
								   from materias ma1 
								        join examenes e
								          on m.nro_alumno = e.nro_alumno
								         and ma1.cod_carrera = e.cod_carrera
								         and ma1.cod_materia = e.cod_materia
								         and e.nota_examen  >= c.nota_aprobacion
								  where m.cod_carrera   = ma1.cod_carrera
								    and ma1.obligatoria = 'S')
						  then 'N'
						  when m.egresado = 'N'
	                       and (select count(*)
								  from materias ma 
								 where m.cod_carrera  = ma.cod_carrera
								   and ma.obligatoria = 'S')
								=
								(select count(distinct ma1.cod_materia)
								   from materias ma1 
								        join examenes e
								          on m.nro_alumno = e.nro_alumno
								         and ma1.cod_carrera = e.cod_carrera
								         and ma1.cod_materia = e.cod_materia
								         and e.nota_examen  >= c.nota_aprobacion
								  where m.cod_carrera   = ma1.cod_carrera
								    and ma1.obligatoria = 'S')
						  then 'S'
						  else m.egresado
                     end						  
     from matriculas m 
          join carreras c
	        on m.cod_carrera = c.cod_carrera
    -- restringir las matrículas a analizar 
    where exists (select *
	                from inserted i
					     join deleted d
						   on i.nro_alumno   = d.nro_alumno
						  and i.cod_carrera  = d.cod_carrera
						  and i.cod_materia  = d.cod_materia
						  and i.fecha_examen = d.fecha_examen
						  and isnull(i.nota_examen,-1) != isnull(d.nota_examen,-1)
					     join materias ma1
						   on i.cod_carrera   = ma1.cod_carrera
						  and i.cod_materia   = ma1.cod_materia
						  and ma1.obligatoria = 'S'
				   where m.nro_alumno   = i.nro_alumno
				     and m.cod_carrera  = i.cod_carrera)
end
go

create trigger ti_pa_matriculas
on dbo.matriculas
for insert
as
begin
   if exists (select *
                from inserted i
			   where i.egresado = 'S')
      begin
	     raiserror('Una nueva matrícula no puede ser insertada con el estado egresado', 16, 1)
		 rollback
		 return
	  end

end
go

create trigger tu_pa_matriculas
on dbo.matriculas
for update
as
begin
   if not update(egresado)
      begin 
	     return
	  end

   if update(nro_alumno) or update(cod_carrera)
      begin
	     raiserror('No se pueden modificar el alumno ni la carrera', 16, 1)
		 rollback
		 return
	  end

   if exists (select *
                from inserted i
				     join deleted d
					   on i.nro_alumno  = d.nro_alumno
					  and i.cod_carrera = d.cod_carrera
					  and i.egresado    = 'S'
					  and d.egresado    = 'N'
                     join carreras c
	                   on i.cod_carrera = c.cod_carrera
               where (select count(*)
					    from materias ma 
					   where i.cod_carrera  = ma.cod_carrera
					     and ma.obligatoria = 'S')
					 >
					(select count(distinct ma1.cod_materia)
					   from materias ma1 
					        join examenes e
					          on i.nro_alumno = e.nro_alumno
					         and ma1.cod_carrera = e.cod_carrera
					         and ma1.cod_materia = e.cod_materia
					         and e.nota_examen  >= c.nota_aprobacion
					  where i.cod_carrera   = ma1.cod_carrera
					    and ma1.obligatoria = 'S'))
      begin
	     raiserror('Este alumno no cumple con las condiciones de egreso', 16, 1)
		 rollback
		 return
	  end

   if exists (select *
                from inserted i
				     join deleted d
					   on i.nro_alumno  = d.nro_alumno
					  and i.cod_carrera = d.cod_carrera
					  and i.egresado    = 'N'
					  and d.egresado    = 'S'
                     join carreras c
	                   on i.cod_carrera = c.cod_carrera
               where (select count(*)
					    from materias ma 
					   where i.cod_carrera  = ma.cod_carrera
					     and ma.obligatoria = 'S')
					 =
					(select count(distinct ma1.cod_materia)
					   from materias ma1 
					        join examenes e
					          on i.nro_alumno = e.nro_alumno
					         and ma1.cod_carrera = e.cod_carrera
					         and ma1.cod_materia = e.cod_materia
					         and e.nota_examen  >= c.nota_aprobacion
					  where i.cod_carrera   = ma1.cod_carrera
					    and ma1.obligatoria = 'S'))
      begin
	     raiserror('Este alumno cumple con las condiciones de egreso y por lo tanto debiera ser considerado un egresado', 16, 1)
		 rollback
		 return
	  end
end
go

