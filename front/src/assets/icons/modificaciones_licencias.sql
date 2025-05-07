--licencia actual
SELECT [dbo].[fnDesencriptador]((select glosa_param from parametro_sca where origen_param='FECHA_EXPIRACION'))
select *  from parametro_sca where origen_param='FECHA_EXPIRACION'
SELECT [dbo].[fnDesencriptador]((select glosa_param from parametro_sca where origen_param='TRABAJADORES'))
select *  from parametro_sca where origen_param='TRABAJADORES'

----




/***cambiar fecha de acuerdo al cliente  **/

declare @cant int
declare @cantAct int
declare @fechaVencimiento datetime
set language spanish

set @fechaVencimiento=convert(datetime,'11-11-2030',103)  --->>  NUEVA FECHA
--set @fechaVencimiento=DATEADD (year , 2 , getdate() )

select @cantAct=count(id_emp) from parametro_sca where origen_param = 'FECHA_EXPIRACION'

if @cantAct>0
begin
   select  @cant=id_param from parametro_sca where origen_param = 'FECHA_EXPIRACION'
   
   select dbo.fnEncriptador('5588588', convert(varchar(8),@fechaVencimiento,112))
   update parametro_sca set glosa_param=dbo.fnEncriptador('5588588', convert(varchar(8),@fechaVencimiento,112)) where id_param=@cant
end

SELECT [dbo].[fnDesencriptador]((select glosa_param from parametro_sca where origen_param='FECHA_EXPIRACION'))

go




/***cambiar fecha de acuerdo al cliente  **/

declare @cant int
declare @cantAct int
declare @fechaVencimiento datetime
declare @nuevaCantidad int=101  -->cambiar cantidad
set language spanish


select @cantAct=count(id_emp) from parametro_sca where origen_param = 'TRABAJADORES'

if @cantAct>0
begin
   select  @cant=id_param from parametro_sca where origen_param = 'TRABAJADORES'
   
   
   update parametro_sca set glosa_param=dbo.fnEncriptador('5588588', convert(varchar,@nuevaCantidad)) where id_param=@cant
end

SELECT [dbo].[fnDesencriptador]((select glosa_param from parametro_sca where origen_param='TRABAJADORES'))

go
