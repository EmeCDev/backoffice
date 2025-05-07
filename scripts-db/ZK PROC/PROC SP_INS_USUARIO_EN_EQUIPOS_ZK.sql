USE DEV_PORTALGEN;
GO

DROP PROCEDURE IF EXISTS SP_INS_USUARIO_EN_EQUIPOS_ZK;
GO

CREATE PROCEDURE SP_INS_USUARIO_EN_EQUIPOS_ZK
    @ServerId INT = NULL,
    @DevicesSerialNumbers NVARCHAR(MAX),
    @uid INT = NULL,
    @Pin INT,
    @Card VARCHAR(50) = NULL,
    @password VARCHAR(50),
    @group INT = 1,
    @starttime INT = 0,
    @endtime INT = 0,
    @name VARCHAR(100),
    @privilege INT = NULL,
    @disable INT = 0,
    @verify INT = 0,
    @tz VARCHAR(50) = NULL,
    @vicecard INT = NULL
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        DECLARE @ErrorMessage NVARCHAR(1000);
        DECLARE @DatabaseName NVARCHAR(100) = 'ZK_Att_Acc';
        DECLARE @sqlCommand NVARCHAR(MAX);
        DECLARE @LinkedServer NVARCHAR(20);
        DECLARE @serieActual NVARCHAR(50);
        DECLARE @tipoEquipo NVARCHAR(20);
        DECLARE @tempTable TABLE (DeviceType NVARCHAR(20));

        -- Determinar el servidor vinculado
        SET @LinkedServer = CASE @ServerId
            WHEN 1 THEN 'BD1GESTION'
            WHEN 2 THEN 'BD2GESTION'
            WHEN 3 THEN 'BD3GESTION'
            ELSE NULL
        END;

        IF @LinkedServer IS NULL
        BEGIN
            SET @ErrorMessage = 'Debe indicar un ServerId válido (1, 2 o 3).';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Manejo seguro del cursor
        BEGIN TRY
            IF CURSOR_STATUS('global', 'seriesCursor') >= 0
            BEGIN
                CLOSE seriesCursor;
                DEALLOCATE seriesCursor;
            END
        END TRY BEGIN CATCH END CATCH

        -- Crear cursor con seguridad
        DECLARE seriesCursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT LTRIM(RTRIM(value)) AS Serie
        FROM STRING_SPLIT(@DevicesSerialNumbers, ',');
        
        OPEN seriesCursor;
        FETCH NEXT FROM seriesCursor INTO @serieActual;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- 1. Obtener el tipo de equipo desde el servidor remoto
            SET @sqlCommand = 'SELECT * FROM OPENQUERY(' + @LinkedServer + ', ''SELECT DeviceType FROM ' + @DatabaseName + '.dbo.EquipoEmpresa WHERE Equipo = ''''' + REPLACE(@serieActual, '''', '''''') + ''''''')';
            
            DELETE FROM @tempTable;
            INSERT INTO @tempTable
            EXEC sp_executesql @sqlCommand;
            
            SELECT @tipoEquipo = DeviceType FROM @tempTable;

            IF @tipoEquipo IS NULL
            BEGIN
                PRINT 'No se encontró el tipo de equipo para la serie: ' + @serieActual;
            END
            ELSE
            BEGIN
                -- 2. Ejecutar el procedimiento principal según el tipo de equipo
                IF @tipoEquipo = 'acc'
                BEGIN
                    SET @sqlCommand = 'EXEC [' + @LinkedServer + '].[' + @DatabaseName + '].[dbo].[SP_INS_USER]
                        @uid = ' + ISNULL(CAST(@uid AS NVARCHAR(10)), 'NULL') + ',
                        @pin = ' + CAST(@pin AS NVARCHAR(10)) + ',
                        @cardno = ' + ISNULL('''' + REPLACE(@Card, '''', '''''') + '''', 'NULL') + ',
                        @password = ''' + REPLACE(@password, '''', '''''') + ''',
                        @group = ' + CAST(@group AS NVARCHAR(10)) + ',
                        @starttime = ' + CAST(@starttime AS NVARCHAR(10)) + ',
                        @endtime = ' + CAST(@endtime AS NVARCHAR(10)) + ',
                        @name = ''' + REPLACE(@name, '''', '''''') + ''',
                        @privilege = ' + ISNULL(CAST(@privilege AS NVARCHAR(10)), 'NULL') + ',
                        @disable = ' + CAST(@disable AS NVARCHAR(1)) + ',
                        @verify = ' + CAST(@verify AS NVARCHAR(1)) + ',
                        @equipo = ''' + REPLACE(@serieActual, '''', '''''') + '''';
                    
                    EXEC(@sqlCommand);
                END
                ELSE IF @tipoEquipo = 'att'
                BEGIN
                    SET @sqlCommand = 'EXEC [' + @LinkedServer + '].[' + @DatabaseName + '].[dbo].[SP_INS_USER_ASISTENCIA]
                        @pin = ' + CAST(@pin AS NVARCHAR(10)) + ',
                        @name = ''' + REPLACE(@name, '''', '''''') + ''',
                        @pri = ' + ISNULL(CAST(@privilege AS NVARCHAR(10)), 'NULL') + ',
                        @passwd = ''' + REPLACE(@password, '''', '''''') + ''',
                        @card = ' + ISNULL('''' + REPLACE(@Card, '''', '''''') + '''', 'NULL') + ',
                        @grp = ' + CAST(@group AS NVARCHAR(10)) + ',
                        @tz = ' + ISNULL('''' + REPLACE(@tz, '''', '''''') + '''', 'NULL') + ',
                        @verify = ' + CAST(@verify AS NVARCHAR(1)) + ',
                        @vicecard = ' + ISNULL(CAST(@vicecard AS NVARCHAR(10)), 'NULL') + ',
                        @startdatetime = ' + CAST(@starttime AS NVARCHAR(10)) + ',
                        @enddatetime = ' + CAST(@endtime AS NVARCHAR(10)) + ',
                        @equipo = ''' + REPLACE(@serieActual, '''', '''''') + '''';
                    
                    EXEC(@sqlCommand);
                END
                ELSE
                BEGIN
                    PRINT 'El tipo de equipo no es válido para la serie: ' + @serieActual;
                END

                -- 3. Ejecutar los procedimientos adicionales en el servidor remoto
                SET @sqlCommand = 'EXEC [' + @LinkedServer + '].[' + @DatabaseName + '].[dbo].[SP_INS_USUARIO_EQUIPO]
                    @EQUIPO = ''' + REPLACE(@serieActual, '''', '''''') + ''',
                    @RUT_PER = ' + CAST(@pin AS NVARCHAR(10));
                EXEC(@sqlCommand);

                SET @sqlCommand = 'EXEC [' + @LinkedServer + '].[' + @DatabaseName + '].[dbo].[SP_INS_BIOPHOTO_EQUIPO]
                    @EQUIPO = ''' + REPLACE(@serieActual, '''', '''''') + ''',
                    @RUT_PER = ' + CAST(@pin AS NVARCHAR(10));
                EXEC(@sqlCommand);

                SET @sqlCommand = 'EXEC [' + @LinkedServer + '].[' + @DatabaseName + '].[dbo].[SP_INS_HUELLA_EQUIPO]
                    @EQUIPO = ''' + REPLACE(@serieActual, '''', '''''') + ''',
                    @RUT_PER = ' + CAST(@pin AS NVARCHAR(10));
                EXEC(@sqlCommand);
            END

            FETCH NEXT FROM seriesCursor INTO @serieActual;
        END;

        CLOSE seriesCursor;
        DEALLOCATE seriesCursor;
    END TRY
    BEGIN CATCH
		IF @ErrorMessage IS NOT NULL
		BEGIN
			THROW 50001, @ErrorMessage, 1;
		END
		ELSE
		BEGIN
			THROW;
		END
    END CATCH
END;
GO