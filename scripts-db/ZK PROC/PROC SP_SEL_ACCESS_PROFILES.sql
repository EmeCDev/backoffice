USE DEV_PORTALGEN;
GO

DROP PROC IF EXISTS SP_SEL_ACCESS_PROFILES;
GO

CREATE PROCEDURE SP_SEL_ACCESS_PROFILES
    @Server INT = NULL,
    @Database NVARCHAR(128) = NULL
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

    BEGIN TRY
        DECLARE @DbExists INT, @TableExists INT;
        DECLARE @CheckDbCommand NVARCHAR(MAX), @CheckTableCommand NVARCHAR(MAX);

        -- 1. Verificar si la base de datos existe en el servidor vinculado
        SET @CheckDbCommand = '
        IF EXISTS (
            SELECT 1
            FROM [' + @LinkedServer + '].master.sys.databases
            WHERE name = @DbName
        )
            SET @DbFlag = 1;
        ELSE
            SET @DbFlag = 0;
        ';

        EXEC sp_executesql 
            @CheckDbCommand,
            N'@DbName NVARCHAR(128), @DbFlag INT OUTPUT',
            @DbName = @Database,
            @DbFlag = @DbExists OUTPUT;

        IF @DbExists = 0
        BEGIN
            SET @ErrorMessage = 'El cliente no existe en el servidor indicado.';
            THROW 50001, @ErrorMessage, 1;
        END;

        -- 2. Verificar si la tabla PERFIL_ACC existe dentro de esa base de datos
        SET @CheckTableCommand = '
        IF EXISTS (
            SELECT 1
            FROM [' + @LinkedServer + '].[' + @Database + '].sys.tables t
            JOIN [' + @LinkedServer + '].[' + @Database + '].sys.schemas s ON t.schema_id = s.schema_id
            WHERE t.name = ''PERFIL_ACC'' AND s.name = ''dbo''
        )
            SET @TableFlag = 1;
        ELSE
            SET @TableFlag = 0;
        ';

        EXEC sp_executesql 
            @CheckTableCommand,
            N'@TableFlag INT OUTPUT',
            @TableFlag = @TableExists OUTPUT;

        IF @TableExists = 0
        BEGIN
            SET @ErrorMessage = 'El cliente seleccionado no tiene perfiles de acceso.';
            THROW 50001, @ErrorMessage, 1;
        END;

        -- 3. Ejecutar la consulta si todo está OK
        DECLARE @SqlCommand NVARCHAR(MAX);
        SET @SqlCommand = '
        SELECT id_perf, descripcion_perf
        FROM [' + @LinkedServer + '].[' + @Database + '].dbo.PERFIL_ACC WITH (NOLOCK);';

        EXEC sp_executesql @SqlCommand;

    END TRY
    BEGIN CATCH
        IF @ErrorMessage IS NOT NULL
            THROW 50001, @ErrorMessage, 1;

        THROW;
    END CATCH
END;
GO

	EXEC SP_SEL_ACCESS_PROFILES
	@Server = 3,
	@Database = 'genera_oficial';