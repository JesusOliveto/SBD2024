alter procedure dbo.get_prom_aus_alumnos
as
begin
   -- principio de procedimiento (1 vez) ------------------------------------------------------------------------------------------------
   declare @nro_alumno		integer,
           @cod_carrera		smallint,
		   @nota			decimal(4,2),
		   @cant_ausentes	smallint,
		   @cant_pres		smallint,
		   @suma_notas		decimal(6,2),
		   @promedio		decimal(4,2),
		   @nom_alumno		varchar(40),
		   @nom_carrera		varchar(40)

   declare @resultados table
   (
    nro_alumno			integer			not null,
	nom_alumno			varchar(40)		not null,
	nom_carrera			varchar(40)		not null,
	promedio			decimal(4,2)	null,
	cant_ausentes		smallint		not null
   )

   declare m insensitive cursor for
    select nro_alumno, cod_carrera
	  from matriculas

   open m
   fetch m into @nro_alumno, @cod_carrera
   -----------------------------------------------------------------------------------------------------------------------------------
   while @@fetch_status = 0 -- hay más matrículas?
   begin
      -- principio de tratamiento de matrícula (M veces) --------------------------------------------------------------------------------------------
      set @cant_ausentes = 0

      declare e insensitive cursor for
	   select nota_examen
		 from examenes e
		where e.nro_alumno  = @nro_alumno
		  and e.cod_carrera = @cod_carrera
      open e
      if @@cursor_rows > 0 -- tiene exámenes?
	     begin
            -- principio de tratamiento de matrícula con examenes (M.(0-1) veces) -------------------------------------------------------------------
		    set @suma_notas = 0
			set @cant_pres  = 0

			fetch e into @nota
		    while @@fetch_status = 0 -- tratamiento de exámenes de una matrícula
			begin
               -- principio de tratamiento de examen examen (M.E.(0-1) veces) -------------------------------------------------------------------------------
			   if @nota is null -- es un ausente?
			      begin
  	 	  	 	     -- tratamiento de examen ausente (M.E.(0-1).(0-1) veces) ----------------------------------------------------------------
				     set @cant_ausentes = @cant_ausentes + 1
				  end
			   else
			      begin
    	 	         -- tratamiento de examen presente (M.E.(0-1).(0-1) veces) ---------------------------------------------------------------
				     set @suma_notas = @suma_notas + @nota
					 set @cant_pres  = @cant_pres  + 1
				  end
               -- fin de tratamiento de examen (M.E.(0-1) veces) -------------------------------------------------------------------------------------
			   fetch e into @nota
			end
			-- fin de tratamiento de matrícula con examenes (M.(0-1) veces) --------------------------------------------------------------------------
			set @promedio = case when @cant_pres > 0 then @suma_notas / @cant_pres else null end
		 end
	  else
	     begin
            -- tratamiento de matrícula sin exámenes (M.(0-1) veces) ------------------------------------------------------------------
		    set @promedio = null
		 end
      -- fin de tratamiento de matrícula (M veces) ---------------------------------------------------------------------------------------------------
   	  deallocate e
	  
	  select @nom_alumno = nom_alumno
	    from alumnos 
	   where nro_alumno = @nro_alumno

	  select @nom_carrera = nom_carrera
	    from carreras
	   where cod_carrera = @cod_carrera

	  insert into @resultados (nro_alumno, nom_alumno, nom_carrera, promedio, cant_ausentes)
	  values (@nro_alumno, @nom_alumno, @nom_carrera, @promedio, @cant_ausentes)
      
	  fetch m into @nro_alumno, @cod_carrera
   end
   -- fin de procedimiento (1 vez) --------------------------------------------------------------------------------------------------------
   deallocate m

   select *
     from @resultados
	order by nom_alumno, nom_carrera
end
go

-- execute dbo.get_prom_aus_alumnos
