USE Backoffice
GO

DROP PROC IF EXISTS SP_UPD_CLIENT_LICENSE;
GO

CREATE PROC SP_UPD_CLIENT_LICENSE
    @Server INT = NULL,
    @Database NVARCHAR(128) = NULL,
    @NewExpirationDate NVARCHAR(10) = NULL,
    @NewWorkersCount INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(200) = NULL;
    DECLARE @LinkedServer NVARCHAR(128) = NULL;

    SET @LinkedServer = CASE
                            WHEN @Server = 1 THEN 'BD1GESTION'
                            WHEN @Server = 2 THEN 'BD2GESTION'
                            WHEN @Server = 3 THEN 'BD3GESTION'
                            ELSE NULL
                        END;

    IF @LinkedServer IS NULL
    BEGIN
        SET @ErrorMessage = 'Debe indicar un servidor válido (1, 2 o 3).';
        THROW 50001, @ErrorMessage, 1;
    END;

    IF @Database IS NULL 
    BEGIN 
        SET @ErrorMessage = 'Debe indicar una base de datos válida.';
        THROW 50001, @ErrorMessage, 1;
    END;

    IF @NewExpirationDate IS NULL AND @NewWorkersCount IS NULL
    BEGIN
        SET @ErrorMessage = 'Debe proporcionar al menos un valor para la fecha de expiración o la cantidad de trabajadores.';
        THROW 50001, @ErrorMessage, 1;
    END;

	DECLARE @SqlCommand NVARCHAR(MAX);

    BEGIN TRY
        IF @NewExpirationDate IS NOT NULL
        BEGIN
            DECLARE @EncryptedDate NVARCHAR(MAX) = [DEV_PORTALGEN].[DBO].[fnEncriptador]('5588588',@NewExpirationDate);


            SET @SqlCommand = N'
                UPDATE ' + QUOTENAME(@LinkedServer) + '.' + QUOTENAME(@Database) + '.dbo.PARAMETRO_SCA
                SET GLOSA_PARAM = ''' + @EncryptedDate + '''
                WHERE ORIGEN_PARAM = ''FECHA_EXPIRACION'';';

            EXEC sp_executesql @SqlCommand;
        END

        IF @NewWorkersCount IS NOT NULL
        BEGIN
            DECLARE @EncryptedWorkers NVARCHAR(MAX) = [DEV_PORTALGEN].[DBO].[fnEncriptador]('5588588',CAST(@NewWorkersCount AS NVARCHAR));

            SET @SqlCommand = N'
                UPDATE ' + QUOTENAME(@LinkedServer) + '.' + QUOTENAME(@Database) + '.dbo.PARAMETRO_SCA
                SET GLOSA_PARAM = ''' + @EncryptedWorkers + '''
                WHERE ORIGEN_PARAM = ''TRABAJADORES'';';

            EXEC sp_executesql @SqlCommand;
        END

		EXEC SP_SEL_CLIENT_LICENSE
			@Server = @Server,
			@Database = @Database;

    END TRY
    BEGIN CATCH
        IF @ErrorMessage IS NOT NULL
            THROW 50001, @ErrorMessage, 1;

        THROW;
    END CATCH
END;
GO

EXEC SP_UPD_CLIENT_LICENSE
@Server = 1,
@Database  = 'GENERA_OFICIAL',
@NewExpirationDate = '20250423',
@NewWorkersCount = 500;