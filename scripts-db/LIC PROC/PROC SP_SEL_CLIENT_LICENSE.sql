USE Backoffice
GO

DROP PROC IF EXISTS SP_SEL_CLIENT_LICENSE;
GO

CREATE PROCEDURE SP_SEL_CLIENT_LICENSE
    @Server INT = NULL,
    @Database NVARCHAR(128) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(200) = NULL;
    DECLARE @LinkedServer NVARCHAR(128) = NULL;
    DECLARE @ExpirationDate NVARCHAR(MAX);
    DECLARE @WorkersCount NVARCHAR(MAX);

    SET @LinkedServer = CASE
                            WHEN @Server = 1 THEN 'BD1GESTION'
                            WHEN @Server = 2 THEN 'BD2GESTION'
                            WHEN @Server = 3 THEN 'BD3GESTION'
                            ELSE NULL
                        END;

    IF @LinkedServer IS NULL
    BEGIN
        SET @ErrorMessage = 'Debe indicar un servidor valido (1, 2 o 3).';
        THROW 50001, @ErrorMessage, 1;
    END;

    IF @Database IS NULL 
    BEGIN 
        SET @ErrorMessage = 'Debe indicar una base de datos valida.';
        THROW 50001, @ErrorMessage, 1;
    END;

    BEGIN TRY
        DECLARE @SqlCommand NVARCHAR(MAX);
        DECLARE @ParmDefinition NVARCHAR(500);

        SET @SqlCommand = N'
			SELECT 
            @DateOut = (SELECT TOP 1 GLOSA_PARAM FROM ' + @LinkedServer + '.' + @Database + '.dbo.PARAMETRO_SCA WITH (NOLOCK) WHERE ORIGEN_PARAM = ''FECHA_EXPIRACION''),
            @CountOUT = (SELECT TOP 1 GLOSA_PARAM FROM ' + @LinkedServer + '.' + @Database + '.dbo.PARAMETRO_SCA WITH (NOLOCK) WHERE ORIGEN_PARAM = ''TRABAJADORES'')';

        SET @ParmDefinition = N'@DateOut NVARCHAR(MAX) OUTPUT, @CountOut NVARCHAR(MAX) OUTPUT';

        EXEC sp_executesql @SqlCommand, @ParmDefinition, 
                          @DateOut = @ExpirationDate OUTPUT,
                          @CountOUT = @WorkersCount OUTPUT;

		SET @ExpirationDate = [DEV_PORTALGEN].[DBO].[fnDesencriptador](@ExpirationDate);

		SET @ExpirationDate = 
				SUBSTRING(@ExpirationDate, 7, 2) + '-' + -- Día
				SUBSTRING(@ExpirationDate, 5, 2) + '-' + -- Mes
				SUBSTRING(@ExpirationDate, 1, 4);        -- Año

		SET @WorkersCount = [DEV_PORTALGEN].[DBO].[fnDesencriptador](@WorkersCount);
			
        SELECT 
            @ExpirationDate AS ExpirationDate,
            @WorkersCount AS WorkersCount;

    END TRY
    BEGIN CATCH
        IF @ErrorMessage IS NOT NULL
            THROW 50001, @ErrorMessage, 1;

        THROW;
    END CATCH
END;
GO

EXEC SP_SEL_CLIENT_LICENSE
@Server = 3,
@Database  = 'GENERA_OFICIAL';