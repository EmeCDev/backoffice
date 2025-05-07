USE Backoffice;

DROP TABLE IF EXISTS [User];
GO
CREATE TABLE [User](
    [UserId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(255) NOT NULL,
    [Email] NVARCHAR(255) NOT NULL UNIQUE,
    [PasswordHash] NVARCHAR(255) NOT NULL,
    [ProfileId] INT NOT NULL FOREIGN KEY REFERENCES [Profile]([ProfileId]),
    [IsActive] BIT NULL CONSTRAINT DF_User_IsActive DEFAULT ((1)),
    [CreatedAt] DATETIME NULL DEFAULT (GETDATE()),
    [CreatedBy] INT NOT NULL,
    [UpdatedAt] DATETIME NULL DEFAULT (GETDATE()),
    [UpdatedBy] INT NULL
);
GO

/*--------------------------------------------------------------------------------------------
CRUD SP_SEL_USER
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_SEL_USER;
GO
CREATE PROC SP_SEL_USER
@UserId INT = NULL,
@Name NVARCHAR(255) = NULL,
@Email NVARCHAR(255) = NULL,
@ProfileId INT = NULL,
@IsActive BIT = NULL
AS
BEGIN
	/********************************************************************************************
	Nombre:      SP_SEL_USER
	Descripción: Este procedimiento consulta un usuario de la tabla [User] dado los parametros de entrada.
	
	Creado por:  Matias Castro Nuñez
	Fecha:       06-01-2025
	
	Modificaciones:
	- 01-05-2025 (Matias Castro Nuñez): Se añadió parametros para filtrar los usuarios seleccionados.
	
	Parámetros:
	@UserId INT = Identificador numerico para el usuario para filtrar.
	@Name NVARCHAR(255) = Nombre del usuario para filtrar.
	@Email NVARCHAR(255) = Correo del usuario para filtrar.
	@ProfileId INT = Id del perfil del usuario para filtrar.
	@IsActive BIT = Estado del usuario para filtrar. (0 Inactivo, 1 Activo)
	
	Retorna: Datos del usuario o usuarios que cumplan con los criterios de busqueda 
	(UserId INT, Name NVARCHAR(255), Email NVARCHAR(255), PasswordHash NVARCHAR(255) NOT NULL,
    ProfileId INT, IsActive BIT).
	
	********************************************************************************************/

	BEGIN TRY

		/********************************************************************************************
										DECLARACIÓN DE VARIABLES
		********************************************************************************************/

		DECLARE @ErrorMessage NVARCHAR(MAX) = NULL;

		/********************************************************************************************
										  SELECCIÓN DE USUARIO
		********************************************************************************************/

		SELECT 
			[UserId],
			[Name],
			[Email],
			[ProfileId],
			[IsActive]
		FROM [User]
		WHERE
			(@UserId IS NULL OR [UserId] = @UserId) AND
			(@Name IS NULL OR [Name] LIKE '%' + @Name + '%') AND
			(@Email IS NULL OR [Email] LIKE '%' + @Email + '%') AND
			(@ProfileId IS NULL OR [ProfileId] = @ProfileId) AND
			(@IsActive IS NULL OR [IsActive] = @IsActive);
		
	END TRY
	BEGIN CATCH
		IF @ErrorMessage IS NOT NULL
			THROW 50001, @ErrorMessage, 1;

		THROW;
END CATCH
END
GO

/*--------------------------------------------------------------------------------------------
CRUD SP_INS_USER
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_INS_USER;
GO
CREATE PROC SP_INS_USER
@Name NVARCHAR(255) = NULL,
@Email NVARCHAR(255) = NULL,
@PasswordHash NVARCHAR(255) = NULL,
@ProfileId INT = NULL,
@IsActive BIT = 1,
@CreatedAt DATETIME = NULL,
@CreatedBy INT = NULL
AS
BEGIN
	/********************************************************************************************
	Nombre:      SP_INS_USER
	Descripción: Este procedimiento inserta un usuario en la tabla [User].
	
	Creado por:  Matias Castro Nuñez
	Fecha:       06-01-2025
	
	Modificaciones:
	- dd-mm-aaaa (nombre): modificacion.
	
	Parámetros:
	@Name NVARCHAR(255) = Nombre del usuario a crear.
	@Email NVARCHAR(255) = Correo del usuario a crear.
	@PasswordHash NVARCHAR(255) = Contraseña hasheada del usuario a crear.
	@ProfileId INT = Id del perfil asociado al usuario a crear.
	@IsActive BIT = Estado del usuario a actualizar. (0 Inactivo, 1 Activo).
	@CreatedAt DATETIME = Id del usuario que crea el nuevo [User].
	@CreatedBy INT = Id del usuario que crea el nuevo [User].
	
	Retorna: 1 en caso de exito en la creación o realiza throw error que ocurrio durante la misma.
	
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
	
		-- Si el nombre viene vacío.
		IF @Name IS NULL OR @Name = ''
		BEGIN
		    SET @ErrorMessage = 'El nombre del usuario es obligatorio.';
		    THROW 50001, @ErrorMessage, 1;
		END

		-- Si el correo viene vacío.
		IF @Email IS NULL OR @Email = ''
		BEGIN
		    SET @ErrorMessage = 'El correo del usuario es obligatorio.';
		    THROW 50001, @ErrorMessage, 1;
		END

		-- Si el password hash viene vacío.
		IF @PasswordHash IS NULL OR @PasswordHash = ''
		BEGIN
		    SET @ErrorMessage = 'La contraseña del usuario es obligatoria.';
		    THROW 50001, @ErrorMessage, 1;
		END
		
		-- Si el profileid viene vacío.
		IF @ProfileId IS NULL
		BEGIN
		    SET @ErrorMessage = 'El perfil del usuario es obligatorio.';
		    THROW 50001, @ErrorMessage, 1;
		END

		-- Si ya existe el correo en la tabla [User].
		IF EXISTS ( SELECT 1 FROM [User] WHERE Email = @Email )
		BEGIN
		    SET @ErrorMessage = 'El correo ingresado se encuentra asociado a otro usuario.';
			THROW 50001, @ErrorMessage, 1;
		END
		
		-- Si no existe el perfil indicado en la tabla [Profile].
		IF NOT EXISTS ( SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId )
		BEGIN
		    SET @ErrorMessage = 'El Id del perfil ingresado no existe.';
			THROW 50001, @ErrorMessage, 1;
		END

	/********************************************************************************************
								INSERCIÓN DEL REGISTRO
	********************************************************************************************/

		INSERT INTO [User]([Name], [Email], [PasswordHash], [ProfileId], [IsActive], [CreatedAt], [CreatedBy]) 
		VALUES (@Name, @Email, @PasswordHash, @ProfileId, @IsActive, @CreatedAt, @CreatedBy);

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
CRUD SP_UPD_USER
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_UPD_USER;
GO
CREATE PROC SP_UPD_USER
@UserId INT = NULL,
@Name NVARCHAR(255) = NULL,
@Email NVARCHAR(255) = NULL,
@PasswordHash NVARCHAR(255) = NULL,
@ProfileId INT = NULL,
@IsActive BIT = NULL,
@UpdatedAt DATETIME = NULL,
@UpdatedBy INT = NULL
AS
BEGIN
	/********************************************************************************************
	Nombre:      SP_UPD_USER
	Descripción: Este procedimiento actualiza un usuario en la tabla [User], si los parametros son NULL 
				 se mantienenen los datos actuales.
	
	Creado por:  Matias Castro Nuñez
	Fecha:       06-01-2025
	
	Modificaciones:
	- dd-mm-aaaa (nombre): modificacion.
	
	Parámetros:
	@UserId INT = Id del usuario a actualizar.
	@Name NVARCHAR(255) = Nombre del usuario a actualizar.
	@Email NVARCHAR(255) = Correo del usuario a actualizar.
	@PasswordHash NVARCHAR(255) = Contraseña hasheada del usuario a actualizar.
	@ProfileId INT = Id del perfil asociado al usuario a actualizar.
	@IsActive BIT = Estado del usuario a actualizar. (0 Inactivo, 1 Activo).
	@CreatedAt DATETIME = Fecha de actualización del [User].
	@CreatedBy INT = Id del usuario que actualiza el [User].
	
	Retorna: 1 en caso de exito en la creación o realiza throw error que ocurrio durante la misma.
	
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

		-- Si no se proporciona el id del usuario.
		IF @UserId IS NULL
		BEGIN
		    SET @ErrorMessage = 'Debe indicar un UserId';
			THROW 50001, @ErrorMessage, 1;
		END

		-- Si ya existe el correo en la tabla [User] y no esta asociado al mismo usuario que se quiere actualizar.
		IF EXISTS ( SELECT 1 FROM [User] WHERE Email = @Email AND UserId != @UserId)
		BEGIN
		    SET @ErrorMessage = 'El correo ingresado se encuentra asociado a otro usuario.';
			THROW 50001, @ErrorMessage, 1;
		END
		
		-- Si no existe el perfil indicado en la tabla [Profile].
		IF NOT EXISTS ( SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId )
		BEGIN
		    SET @ErrorMessage = 'El Id del perfil ingresado no existe.';
			THROW 50001, @ErrorMessage, 1;
		END

	/********************************************************************************************
								  INSERCIÓN DEL REGISTRO
	********************************************************************************************/
	
		-- En caso de que los datos sean null se mantienen los originales

		SELECT TOP 1
		@Name = ISNULL(NULLIF(@Name, ''), [Name]),
		@Email = ISNULL(NULLIF(@Email, ''), Email),
		@PasswordHash = ISNULL(NULLIF(@PasswordHash, ''), PasswordHash),
		@ProfileId = ISNULL(@ProfileId, ProfileId),
		@IsActive = ISNULL(@IsActive, IsActive)
		FROM [User]
		WHERE UserId = @UserId;

		-- Actualiza los valores

		UPDATE [User]
		SET 
		    [Name] = @Name,
		    [Email] = @Email,
		    [PasswordHash] = @PasswordHash,
		    [ProfileId] = @ProfileId,
		    [IsActive] = @IsActive,
		    [UpdatedAt] = @UpdatedAt,
		    [UpdatedBy] = @UpdatedBy
		WHERE UserId = @UserId;

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
CRUD SP_DROP_USER
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_DROP_USER;
GO
CREATE PROC SP_DROP_USER
@UserId INT = NULL
AS
BEGIN
	/********************************************************************************************
	Nombre:      SP_DROP_USER
	Descripción: Este procedimiento borra un usuario de la tabla [User].
	
	Creado por:  Matias Castro Nuñez
	Fecha:       06-01-2025
	
	Modificaciones:
	- dd-mm-aaaa (nombre): modificacion.
	
	Parámetros:
	@UserId INT = Identificador numerico del usuario para borrar.
	
	Retorna: 1 en caso de exito en el borrado o realiza throw error que ocurrio durante el mismo.
	
	********************************************************************************************/

	BEGIN TRY

		/********************************************************************************************
										DECLARACIÓN DE VARIABLES
		********************************************************************************************/

		DECLARE @ErrorMessage NVARCHAR(MAX) = NULL;

		/********************************************************************************************
										  BORRADO DEL USUARIO
		********************************************************************************************/

		-- Si no existe el registro en la tabla [User].
		IF NOT EXISTS ( SELECT 1 FROM [User] WHERE UserId = @UserId )
		BEGIN
		    SET @ErrorMessage = 'El usuario ingresado no existe.';
			THROW 50001, @ErrorMessage, 1;
		END

		DELETE FROM [User] WHERE UserId = @UserId;
		
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