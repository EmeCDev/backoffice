USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_UPD_PROFILE')
    DROP PROCEDURE SP_UPD_PROFILE;
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE SP_UPD_PROFILE
    @ProfileId INT,
    @Name NVARCHAR(255) = NULL,
    @GrantsList NVARCHAR(255) = NULL,
    @UpdatedBy INT
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_UPD_PROFILE
    --  Descripción:
    --
    --  Parámetros de entrada:
    --  Retorna:
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creación: 
    --    - 17-03-2025
    ---------------------------------------------------------------*/

    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(1000);
    DECLARE @Grant INT;

    BEGIN TRY

		IF NOT EXISTS (SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId)
        BEGIN
            SET @ErrorMessage = 'El perfil no existe.';
            THROW 50001, @ErrorMessage, 1;
        END

        IF NOT EXISTS (SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId)
        BEGIN
            SET @ErrorMessage = 'El perfil no existe.';
            THROW 50001, @ErrorMessage, 1;
        END

        IF @Name IS NOT NULL AND EXISTS (SELECT 1 FROM [Profile] WHERE [Name] = @Name AND ProfileId <> @ProfileId)
        BEGIN
            SET @ErrorMessage = 'El nombre del perfil ya está registrado.';
            THROW 50001, @ErrorMessage, 1;
        END

        UPDATE [Profile]
        SET [Name] = @Name
        WHERE ProfileId = @ProfileId;

        DELETE FROM ProfileGrant WHERE ProfileId = @ProfileId;

        SELECT Value
        INTO #Grants
        FROM STRING_SPLIT(@GrantsList, ',');

		SELECT * FROM #Grants;

        DECLARE cursor_grants CURSOR FOR 
            SELECT Value FROM #Grants;

        OPEN cursor_grants;
        FETCH NEXT FROM cursor_grants INTO @Grant;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Insertar los nuevos grants
            INSERT INTO ProfileGrant(ProfileId, GrantId) 
            VALUES(@ProfileId, @Grant);

            FETCH NEXT FROM cursor_grants INTO @Grant;
        END

        -- Limpiar el cursor
        CLOSE cursor_grants;
        DEALLOCATE cursor_grants;

        -- Eliminar la tabla temporal
        DROP TABLE #Grants;

    END TRY
    BEGIN CATCH
        -- Manejo de errores
        SET @ErrorMessage = ERROR_MESSAGE();
        THROW 50001, @ErrorMessage, 1;
    END CATCH
END;
GO

-- Ejemplo de consulta para probar el procedimiento
USE DEV_PORTALGEN;
GO
SELECT * FROM [Profile];

SELECT * FROM [ProfileGrant];

EXEC SP_UPD_PROFILE
@ProfileId = 1,
@Name = 'ACCESO PARCIAL',
@GrantsList = '100,200,300,400',
@UpdatedBy = 1;