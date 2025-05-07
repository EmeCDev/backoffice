USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_UPD_PROFILE')
    DROP PROCEDURE SP_UPD_PROFILE;
GO

CREATE PROCEDURE SP_UPD_PROFILE
    @ProfileId INT,
    @Name NVARCHAR(255) = NULL,
    @GrantsList NVARCHAR(MAX) = NULL,
    @UpdatedBy INT
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_UPD_PROFILE
    --  Descripción: 
    --    Actualiza un perfil existente y sus grants asociados
    --    Ignora silenciosamente los grants que no existen
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;
    
	DECLARE @ErrorMessage NVARCHAR(1000);
    DECLARE @ValidGrantsCount INT;

	IF @ProfileId = 1
	BEGIN
		SET @ErrorMessage = 'El perfil seleccionado no puede ser modificado.';
        THROW 50001, @ErrorMessage, 1;
    END

    BEGIN TRY
        -- Verificar si el perfil existe
        IF NOT EXISTS (SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId)
        BEGIN
            SET @ErrorMessage = 'El perfil no existe.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Verificar nombre duplicado (solo si se proporciona nuevo nombre)
        IF @Name IS NOT NULL AND EXISTS (
            SELECT 1 FROM [Profile] 
            WHERE [Name] = @Name AND ProfileId <> @ProfileId
        )
        BEGIN
            SET @ErrorMessage = 'El nombre del perfil ya está registrado.';
            THROW 50001, @ErrorMessage, 1;
        END

        BEGIN TRANSACTION;

            IF @Name IS NOT NULL
            BEGIN
                UPDATE [Profile]
                SET [Name] = @Name,
                    [UpdatedBy] = @UpdatedBy,
                    [UpdatedAt] = GETDATE()
                WHERE ProfileId = @ProfileId;
            END

            IF @GrantsList IS NOT NULL
            BEGIN

                CREATE TABLE #ValidGrants (
                    GrantId INT PRIMARY KEY
                );

                INSERT INTO #ValidGrants (GrantId)
                SELECT DISTINCT CAST(Value AS INT)
                FROM STRING_SPLIT(@GrantsList, ',')
                WHERE ISNUMERIC(Value) = 1
                AND CAST(Value AS INT) IN (SELECT GrantId FROM [Grant]);

                SET @ValidGrantsCount = (SELECT COUNT(*) FROM #ValidGrants);

                IF @ValidGrantsCount > 0
                BEGIN
                    DELETE FROM ProfileGrant 
                    WHERE ProfileId = @ProfileId
                    AND GrantId NOT IN (SELECT GrantId FROM #ValidGrants);
                    
                    INSERT INTO ProfileGrant (ProfileId, GrantId)
                    SELECT @ProfileId, GrantId
                    FROM #ValidGrants
                    WHERE GrantId NOT IN (
                        SELECT GrantId FROM ProfileGrant WHERE ProfileId = @ProfileId
                    );
                END

                DROP TABLE #ValidGrants;
            END

        COMMIT TRANSACTION;

        SELECT 1 AS Success;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        IF OBJECT_ID('tempdb..#ValidGrants') IS NOT NULL
            DROP TABLE #ValidGrants;
        
        IF ERROR_NUMBER() = 50001
		BEGIN
			SET @ErrorMessage = ERROR_MESSAGE();
            THROW 50001, @ErrorMessage, 1;;
		END
        ELSE
            THROW;
    END CATCH
END;
GO