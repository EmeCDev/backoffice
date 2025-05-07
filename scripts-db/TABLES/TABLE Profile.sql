USE Backoffice;

DROP TABLE IF EXISTS [Profile];
GO
CREATE TABLE [Profile](
    [ProfileId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(100) NOT NULL UNIQUE,
    [IsActive] BIT NULL DEFAULT 1,
    [CreatedAt] DATETIME NULL DEFAULT GETDATE(),
    [CreatedBy] NVARCHAR(255) NOT NULL,
    [UpdatedAt] DATETIME NULL DEFAULT GETDATE(),
    [UpdatedBy] NVARCHAR(255) NULL
);
GO

/*--------------------------------------------------------------------------------------------
CRUD SP_SEL_PROFILE
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_SEL_PROFILE;
GO
CREATE PROC SP_SEL_PROFILE
    @ProfileId INT = NULL, 
    @Name NVARCHAR(100) = NULL, 
    @IsActive BIT = NULL
AS
BEGIN
    /********************************************************************************************
    Nombre:      SP_SEL_PROFILE
    Descripción: Selecciona registros de la tabla Profile basados en parámetros de filtro.

    Creado por:  Matias Castro Nuñez
    Fecha:       06-01-2025

    Modificaciones:
    - dd-mm-aaaa (nombre): Descripción de la modificación.

    Parámetros:
    @ProfileId INT = Identificador del perfil (opcional).
    @Name NVARCHAR(100) = Nombre del perfil (opcional).
    @IsActive BIT = Estado de actividad del perfil (opcional).

    Retorna: Todos los perfiles que coinciden con los parámetros de filtro proporcionados.
    ********************************************************************************************/

    BEGIN TRY

        /********************************************************************************************
                                    DECLARACIÓN DE VARIABLES
        ********************************************************************************************/
        
        DECLARE @ErrorMessage NVARCHAR(MAX) = NULL;

        /********************************************************************************************
                                        SELECCIÓN DE PERFILES
        ********************************************************************************************/

        SELECT 
            ProfileId,
            [Name],
            IsActive
        FROM [Profile]
        WHERE
            (@ProfileId IS NULL OR ProfileId = @ProfileId) AND
            (@Name IS NULL OR Name LIKE '%' + @Name + '%') AND
            (@IsActive IS NULL OR IsActive = @IsActive)
        ORDER BY ProfileId DESC;

    END TRY
    BEGIN CATCH
        IF @ErrorMessage IS NOT NULL
            THROW 50001, @ErrorMessage, 1;

        THROW;
    END CATCH
END
GO

/*--------------------------------------------------------------------------------------------
CRUD SP_INS_PROFILE
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_INS_PROFILE;
GO
CREATE PROC SP_INS_PROFILE
    @Name NVARCHAR(100) = NULL,
    @IsActive BIT = 1,
	@CreatedAt DATETIME = NULL,
	@CreatedBy INT = NULL
AS
BEGIN
    /********************************************************************************************
    Nombre:      SP_INS_PROFILE
    Descripción: Inserta un nuevo registro en la tabla Profile.

    Creado por:  Matias Castro Nuñez
    Fecha:       06-01-2025

    Modificaciones:
    - dd-mm-aaaa (nombre): Descripción de la modificación.

    Parámetros:
    @Name NVARCHAR(100) = Nombre del perfil.
    @IsActive BIT = Estado de actividad del perfil.
	@CreatedAt DATETIME = Fecha de creación del registro.
	@CreatedBy INT = Usuario que crea el perfil.

    Retorna: 1 en caso de exito en la creación o realiza throw error de la misma.

    ********************************************************************************************/

    BEGIN TRY

        /********************************************************************************************
                                    DECLARACIÓN DE VARIABLES
        ********************************************************************************************/
        
        DECLARE @ErrorMessage NVARCHAR(MAX) = NULL;

		SET @CreatedAt = GETDATE();

        /********************************************************************************************
                                        VALIDACIONES
        ********************************************************************************************/

		IF @Name IS NULL
		BEGIN
			SET @ErrorMessage = 'El nombre del perfil es obligatorio.';
			THROW 50001, @ErrorMessage, 1;
		END

        IF EXISTS (SELECT 1 FROM [Profile] WHERE [Name] = @Name)
		BEGIN
			SET @ErrorMessage = 'El nombre del perfil ingresado ya existe.';
			THROW 50001, @ErrorMessage, 1;
		END

		/********************************************************************************************
                                   INSERCIÓN DEL REGISTRO
        ********************************************************************************************/

		INSERT INTO [Profile]([Name], [IsActive], [CreatedAt], [CreatedBy])
		VALUES (@Name, @IsActive, @CreatedAt, @CreatedBy);

		/********************************************************************************************
							DEVOLUCIÓN DE ESTADO DE EXITO
		********************************************************************************************/

		SELECT 1 AS [Status];

    END TRY
    BEGIN CATCH
        IF @ErrorMessage IS NOT NULL
            THROW 50001, @ErrorMessage, 1;

        THROW;
    END CATCH
END
GO

/*--------------------------------------------------------------------------------------------
CRUD SP_UPD_PROFILE
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_UPD_PROFILE;
GO
CREATE PROC SP_UPD_PROFILE
    @ProfileId INT = NULL, 
    @Name NVARCHAR(100) = NULL,
    @IsActive BIT = 1,
    @UpdatedAt DATETIME = NULL,
    @UpdatedBy NVARCHAR(255) = NULL
AS
BEGIN
    /********************************************************************************************
    Nombre:      SP_UPD_PROFILE
    Descripción: Actualiza un registro en la tabla Profile.

    Creado por:  Matias Castro Nuñez
    Fecha:       06-01-2025

    Modificaciones:
    - dd-mm-aaaa (nombre): Descripción de la modificación.

    Parámetros:
    @ProfileId INT = Identificador del perfil.
    @Name NVARCHAR(100) = Nombre del perfil.
    @IsActive BIT = Estado del del perfil (0) Inactivo / (1) Activo.
    @UpdatedAt DATETIME = Fecha de actualización del registro.
    @UpdatedBy NVARCHAR(255) = Usuario que actualiza el perfil.

    Retorna: 1 en caso de éxito en la actualización o lanza error en caso de fallo.

    ********************************************************************************************/

    BEGIN TRY

        /********************************************************************************************
                                    DECLARACIÓN DE VARIABLES
        ********************************************************************************************/
        
        DECLARE @ErrorMessage NVARCHAR(MAX) = NULL;
        SET @UpdatedAt = GETDATE();

        /********************************************************************************************
                                        VALIDACIONES
        ********************************************************************************************/

        IF @ProfileId IS NULL
        BEGIN
            SET @ErrorMessage = 'El ID del perfil es obligatorio.';
            THROW 50001, @ErrorMessage, 1;
        END

        IF @Name IS NULL
        BEGIN
            SET @ErrorMessage = 'El nombre del perfil es obligatorio.';
            THROW 50001, @ErrorMessage, 1;
        END

        IF NOT EXISTS (SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId)
        BEGIN
            SET @ErrorMessage = 'El perfil especificado no existe.';
            THROW 50001, @ErrorMessage, 1;
        END

        IF EXISTS (SELECT 1 FROM [Profile] WHERE [Name] = @Name AND ProfileId <> @ProfileId)
        BEGIN
            SET @ErrorMessage = 'Ya existe otro perfil con el mismo nombre.';
            THROW 50001, @ErrorMessage, 1;
        END

        /********************************************************************************************
                                    ACTUALIZACIÓN DEL REGISTRO
        ********************************************************************************************/

        UPDATE [Profile]
        SET 
            [Name] = @Name,
            [IsActive] = @IsActive,
            [UpdatedAt] = @UpdatedAt,
            [UpdatedBy] = @UpdatedBy
        WHERE ProfileId = @ProfileId;

        /********************************************************************************************
                                DEVOLUCIÓN DE ESTADO DE ÉXITO
        ********************************************************************************************/

        SELECT 1 AS [Status];

    END TRY
    BEGIN CATCH
        IF @ErrorMessage IS NOT NULL
            THROW 50001, @ErrorMessage, 1;

        THROW;
    END CATCH
END
GO

/*--------------------------------------------------------------------------------------------
CRUD SP_DROP_PROFILE
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_DROP_PROFILE;
GO
CREATE PROC SP_DROP_PROFILE
    @ProfileId INT = NULL
AS
BEGIN
    /********************************************************************************************
    Nombre:      SP_DROP_PROFILE
    Descripción: Elimina físicamente un perfil de la tabla Profile.

    Creado por:  Matias Castro Nuñez
    Fecha:       06-01-2025

    Modificaciones:
    - dd-mm-aaaa (nombre): Descripción de la modificación.

    Parámetros:
    @ProfileId INT = Identificador del perfil a eliminar.

    Retorna: 1 en caso de éxito o lanza error si no se puede eliminar.

    ********************************************************************************************/

    BEGIN TRY

        /********************************************************************************************
                                    DECLARACIÓN DE VARIABLES
        ********************************************************************************************/

        DECLARE @ErrorMessage NVARCHAR(MAX) = NULL;

        /********************************************************************************************
                                        VALIDACIONES
        ********************************************************************************************/

        IF @ProfileId IS NULL
        BEGIN
            SET @ErrorMessage = 'El ID del perfil es obligatorio.';
            THROW 50001, @ErrorMessage, 1;
        END

        IF NOT EXISTS (SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId)
        BEGIN
            SET @ErrorMessage = 'El perfil especificado no existe.';
            THROW 50001, @ErrorMessage, 1;
        END

        /********************************************************************************************
                                    ELIMINACIÓN DEL REGISTRO
        ********************************************************************************************/

        DELETE FROM [Profile]
        WHERE ProfileId = @ProfileId;

        /********************************************************************************************
                                DEVOLUCIÓN DE ESTADO DE ÉXITO
        ********************************************************************************************/

        SELECT 1 AS [Status];

    END TRY
    BEGIN CATCH
        IF @ErrorMessage IS NOT NULL
            THROW 50001, @ErrorMessage, 1;

        THROW;
    END CATCH
END
GO
