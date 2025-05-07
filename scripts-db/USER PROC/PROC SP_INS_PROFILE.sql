USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_INS_PROFILE')
    DROP PROCEDURE SP_INS_PROFILE;
GO

CREATE PROCEDURE SP_INS_PROFILE
    @Name NVARCHAR(255),
    @GrantsList NVARCHAR(MAX),
    @CreatedBy INT
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_INS_PROFILE
    --  Descripción: 
    --    Crea un nuevo perfil con sus grants asociados
    --    Ignora silenciosamente los grants que no existen
    --    Devuelve el ID del perfil creado como resultado
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(1000);
    DECLARE @ValidGrantsCount INT;
    DECLARE @ProfileId INT;

    BEGIN TRY
        -- Validación 1: Nombre requerido
        IF NULLIF(@Name, '') IS NULL
        BEGIN
            SET @ErrorMessage = 'El nombre del perfil es requerido.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Validación 2: Nombre duplicado
        IF EXISTS (SELECT 1 FROM [Profile] WHERE [Name] = @Name)
        BEGIN
            SET @ErrorMessage = 'El nombre del perfil ya está registrado.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Validación 3: GrantsList requerida
        IF NULLIF(@GrantsList, '') IS NULL
        BEGIN
            SET @ErrorMessage = 'Debe especificar al menos un permiso para el perfil.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Crear tabla temporal para grants válidos
        CREATE TABLE #ValidGrants (
            GrantId INT PRIMARY KEY
        );

        -- Insertar solo grants válidos (que existen en la tabla [Grant])
        INSERT INTO #ValidGrants (GrantId)
        SELECT DISTINCT CAST(Value AS INT)
        FROM STRING_SPLIT(@GrantsList, ',')
        WHERE ISNUMERIC(Value) = 1
        AND CAST(Value AS INT) IN (SELECT GrantId FROM [Grant]);

        -- Contar grants válidos
        SET @ValidGrantsCount = (SELECT COUNT(*) FROM #ValidGrants);

        -- Validación 4: Mínimo un grant válido
        IF @ValidGrantsCount = 0
        BEGIN
            SET @ErrorMessage = 'No se encontraron permisos válidos para asociar al perfil.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Iniciar transacción
        BEGIN TRANSACTION;

            -- Insertar el nuevo perfil
            INSERT INTO [Profile] ([Name], [CreatedBy], [CreatedAt])
            VALUES (@Name, @CreatedBy, GETDATE());

            -- Obtener el ID del perfil creado
            SET @ProfileId = SCOPE_IDENTITY();

            -- Insertar los grants válidos asociados
            INSERT INTO ProfileGrant (ProfileId, GrantId)
            SELECT @ProfileId, GrantId
            FROM #ValidGrants;

        COMMIT TRANSACTION;

        -- Devolver el ID del perfil creado
        SELECT @ProfileId AS ProfileId;

        -- Limpiar tabla temporal
        DROP TABLE #ValidGrants;

    END TRY
    BEGIN CATCH
        -- Revertir transacción si está activa
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Limpiar tabla temporal si existe
        IF OBJECT_ID('tempdb..#ValidGrants') IS NOT NULL
            DROP TABLE #ValidGrants;

        -- Manejo de errores
        SET @ErrorMessage = ERROR_MESSAGE();
        
        IF ERROR_NUMBER() = 50001
            THROW;
        ELSE
            THROW 50001, @ErrorMessage, 1;
    END CATCH
END;
GO