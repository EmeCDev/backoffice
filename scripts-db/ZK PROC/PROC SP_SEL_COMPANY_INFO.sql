USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_SEL_COMPANY_INFO')
	DROP PROCEDURE SP_SEL_COMPANY_INFO;
GO

CREATE PROCEDURE SP_SEL_COMPANY_INFO
	@CompanyRut INT = NULL,
	@CompanyName NVARCHAR(255) = NULL
AS
BEGIN
	/*---------------------------------------------------------------
	--  Procedimiento almacenado: SP_SEL_COMPANY_INFO
	--  Descripción: Consulta información de empresas/clientes filtrando por RUT y/o nombre.
	--
	--  Parámetros de entrada:
	--    @CompanyRut (INT) - RUT de la empresa a buscar (opcional).
	--    @CompanyName (NVARCHAR 255) - Nombre o parte del nombre de la empresa (opcional).
	--
	--  Retorna:
	--    Resultset con las columnas: id, servidor, bd_genhoras, nombre_empresa, 
	--    rut_empresa, dv, tipo_cliente, URL_Chente
	--
	--  Creado por: 
	--    - [Tu nombre aquí]
	--  Fecha Creación: 
	--    - [Fecha actual]
	---------------------------------------------------------------*/
   
	SET NOCOUNT ON;

	IF @CompanyRut = 0
	BEGIN
		SET @CompanyRut = NULL
	END
   
	DECLARE @Error_Message NVARCHAR(4000);

	BEGIN TRY
		SELECT 
			id,
			servidor,
			bd_genhoras,
			nombre_empresa,
			rut_empresa,
			dv,
			tipo_cliente,
			URL_Cliente
		FROM 
			[DEV_PORTALGEN].[dbo].[Cliente_Empresa]
		WHERE 
			(@CompanyRut IS NULL OR rut_empresa = @CompanyRut)
			AND 
			(@CompanyName IS NULL OR @CompanyName = '' OR nombre_empresa LIKE '%' + @CompanyName + '%')
		ORDER BY 
			rut_empresa;
	END TRY
	BEGIN CATCH
		SET @Error_Message = ERROR_MESSAGE();
       
		IF @Error_Message IS NOT NULL
			THROW 50001, @Error_Message, 1;
		ELSE
			THROW;
	END CATCH
END
GO