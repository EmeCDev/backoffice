USE Backoffice;

DROP TABLE IF EXISTS [ProfileGrant];
GO
CREATE TABLE [ProfileGrant](
    [ProfileGrantId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [ProfileId] INT NOT NULL FOREIGN KEY REFERENCES [Profile]([ProfileId]),
    [GrantId] INT NOT NULL FOREIGN KEY REFERENCES [Grant]([GrantId]),
    CONSTRAINT UQ_ProfileGrant_ProfileId_GrantId UNIQUE ([ProfileId], [GrantId]),
);
GO

/*--------------------------------------------------------------------------------------------
CRUD SP_SEL_PROFILEGRANT
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_SEL_PROFILEGRANT;
GO
CREATE PROC SP_SEL_PROFILEGRANT
@ProfileId INT = NULL
AS
BEGIN
	/********************************************************************************************
	Nombre:      SP_SEL_PROFILEGRANT
	Descripci�n: Este procedimiento consulta los [Grant] asociados a un [Profile].
	
	Creado por:  Matias Castro Nu�ez
	Fecha:       06-01-2025
	
	Modificaciones:
	- dd-mm-aaaa (nombre): modificacion.
	
	Par�metros:
	@UserId INT = Identificador numerico para filtrar los [Profile].
	
	Retorna: Lista de [Grant] asociados al [Profile].
	
	********************************************************************************************/

	BEGIN TRY

		/********************************************************************************************
										DECLARACI�N DE VARIABLES
		********************************************************************************************/

		DECLARE @ErrorMessage NVARCHAR(MAX) = NULL;

		/********************************************************************************************
										SELECCI�N DE PROFILEGRANTS
		********************************************************************************************/

		SELECT 
			[ProfileGrantId],
			[ProfileId],
			[GrantId]
		FROM [ProfileGrant]
		WHERE
			(@ProfileId IS NULL OR [ProfileId] = @ProfileId);
		
	END TRY
	BEGIN CATCH
		IF @ErrorMessage IS NOT NULL
			THROW 50001, @ErrorMessage, 1;

		THROW;
END CATCH
END
GO

/*--------------------------------------------------------------------------------------------
CRUD SP_INS_PROFILEGRANT
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_INS_PROFILEGRANT;
GO
CREATE PROC SP_INS_PROFILEGRANT
@ProfileId INT = NULL,
@GrantList NVARCHAR(MAX)
AS
BEGIN
	/********************************************************************************************
	Nombre:      SP_INS_PROFILEGRANT
	Descripci�n: Este procedimiento inserta una lista de [Grant] asociados a un [Profile].
	
	Creado por:  Matias Castro Nu�ez
	Fecha:       06-01-2025
	
	Modificaciones:
	- dd-mm-aaaa (nombre): modificacion.
	
	Par�metros:
	@UserId INT = Identificador numerico del [Profile] a insertar.
	@UserId NVARCHAR(MAX) = Lista de [GrantId] separado por comas.
	
	Retorna: 1 en caso de exito en la inserci�n o realiza un throw error de la misma. 
	
	********************************************************************************************/

	BEGIN TRY

		/********************************************************************************************
										DECLARACI�N DE VARIABLES
		********************************************************************************************/

		DECLARE @ErrorMessage NVARCHAR(MAX) = NULL;

		/********************************************************************************************
									   INSERCI�N DE PROFILEGRANTS
		********************************************************************************************/

		-- Verificar si el perfil existe en la tabla [Profile]
		IF NOT EXISTS (SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId)
		BEGIN
		    SET @ErrorMessage = 'El Id del perfil ingresado no existe.';
			THROW 50001, @ErrorMessage, 1;
		END

		-- Verificar si GrantList no es null o vacio.
		IF @GrantList IS NULL OR @GrantList = ''
		BEGIN
			SET @ErrorMessage = 'Debe indicar una lista de permisos para el perfil.';
			THROW 50001, @ErrorMessage, 1;
		END

		-- Convertir la lista de permisos (GrantList) a una tabla temporal
		CREATE TABLE #GrantList (GrantId INT);

		-- Insertar los GrantIds desde el par�metro @GrantList (separados por comas)
		INSERT INTO #GrantList (GrantId)
		SELECT value
		FROM STRING_SPLIT(@GrantList, ',') 
		WHERE ISNUMERIC(value) = 1;

		-- Verificar si existe al menos un Grant
		IF NOT EXISTS (SELECT 1 FROM [Grant])
		BEGIN
		    SET @ErrorMessage = 'Debe indicar al menos un permiso para el perfil.';
			THROW 50001, @ErrorMessage, 1;
		END
		
		-- Verificar si todos los GrantId en GrantList existen en la tabla [Grant]
		IF EXISTS (
		    SELECT 1
		    FROM #GrantList GL
		    LEFT JOIN [Grant] G ON GL.GrantId = G.GrantId
		    WHERE G.GrantId IS NULL
		)
		BEGIN
		    SET @ErrorMessage = 'Uno o m�s permisos no son validos.';
			THROW 50001, @ErrorMessage, 1;
		END

		-- Insertar los GrantId v�lidos en la tabla ProfileGrant asociados al ProfileId
		INSERT INTO ProfileGrant (ProfileId, GrantId)
		SELECT @ProfileId, GrantId
		FROM #GrantList;

		/********************************************************************************************
							DEVOLUCI�N DE ESTADO DE EXITO
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
CRUD SP_UPD_PROFILEGRANT
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_UPD_PROFILEGRANT;
GO
CREATE PROC SP_UPD_PROFILEGRANT
@ProfileId INT = NULL,
@GrantList NVARCHAR(MAX)
AS
BEGIN
	/********************************************************************************************
	Nombre:      SP_UPD_PROFILEGRANT
	Descripci�n: Este procedimiento actualiza los permisos ([Grant]) asociados a un [Profile].

	Creado por:  Matias Castro Nu�ez
	Fecha:       06-01-2025

	Modificaciones:
	- dd-mm-aaaa (nombre): modificacion.

	Par�metros:
	@ProfileId INT = Identificador numerico del [Profile] a actualizar.
	@GrantList NVARCHAR(MAX) = Lista de [GrantId] separados por comas.

	Retorna: 1 en caso de �xito en la actualizaci�n o realiza un throw error de la misma. 
	********************************************************************************************/

	BEGIN TRY

		/********************************************************************************************
										DECLARACI�N DE VARIABLES
		********************************************************************************************/

		DECLARE @ErrorMessage NVARCHAR(MAX) = NULL;

		/********************************************************************************************
									   ACTUALIZACI�N DE PROFILEGRANTS
		********************************************************************************************/

		-- Verificar si el perfil existe en la tabla [Profile]
		IF NOT EXISTS (SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId)
		BEGIN
		    SET @ErrorMessage = 'El Id del perfil ingresado no existe.';
			THROW 50001, @ErrorMessage, 1;
		END

		-- Convertir la lista de permisos (GrantList) a una tabla temporal
		CREATE TABLE #GrantList (GrantId INT);

		-- Insertar los GrantId desde el par�metro @GrantList (separados por comas)
		INSERT INTO #GrantList (GrantId)
		SELECT value
		FROM STRING_SPLIT(@GrantList, ',');

		-- Verificar si todos los GrantId en GrantList existen en la tabla [Grant]
		IF EXISTS (
		    SELECT 1
		    FROM #GrantList GL
		    LEFT JOIN [Grant] G ON GL.GrantId = G.GrantId
		    WHERE G.GrantId IS NULL
		)
		BEGIN
		    SET @ErrorMessage = 'Uno o m�s permisos no son v�lidos.';
			THROW 50001, @ErrorMessage, 1;
		END

		-- Borrar los permisos existentes para este perfil antes de agregar los nuevos
		DELETE FROM ProfileGrant WHERE ProfileId = @ProfileId;

		-- Insertar los GrantId v�lidos en la tabla ProfileGrant asociados al ProfileId
		INSERT INTO ProfileGrant (ProfileId, GrantId)
		SELECT @ProfileId, GrantId
		FROM #GrantList
		WHERE NOT EXISTS (
		    SELECT 1
		    FROM ProfileGrant PG
		    WHERE PG.ProfileId = @ProfileId AND PG.GrantId = #GrantList.GrantId
		);

		DROP TABLE IF EXISTS #GrantList;

		/********************************************************************************************
							DEVOLUCI�N DE ESTADO DE EXITO
		********************************************************************************************/

		SELECT 1 AS [Status];

	END TRY
	BEGIN CATCH
		
		DROP TABLE IF EXISTS #GrantList;

		IF @ErrorMessage IS NOT NULL
			THROW 50001, @ErrorMessage, 1;

		THROW;
	END CATCH
END
GO

/*--------------------------------------------------------------------------------------------
CRUD SP_DROP_PROFILEGRANT
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_DROP_PROFILEGRANT;
GO
CREATE PROC SP_DROP_PROFILEGRANT
@ProfileId INT
AS
BEGIN
	/********************************************************************************************
	Nombre:      SP_DROP_PROFILEGRANT
	Descripci�n: Este procedimiento elimina los permisos asociados a un perfil espec�fico.

	Creado por:  Matias Castro Nu�ez
	Fecha:       06-01-2025

	Modificaciones:
	- dd-mm-aaaa (nombre): modificacion.

	Par�metros:
	@ProfileId INT = Identificador numerico del perfil que se va a eliminar.

	Retorna: 1 en caso de �xito en la eliminaci�n o realiza un throw error de la misma. 
	********************************************************************************************/

	BEGIN TRY

		/********************************************************************************************
										DECLARACI�N DE VARIABLES
		********************************************************************************************/

		DECLARE @ErrorMessage NVARCHAR(MAX) = NULL;

		/********************************************************************************************
									   ELIMINACI�N DE PROFILEGRANTS
		********************************************************************************************/

		-- Verificar si el perfil existe en la tabla [Profile]
		IF NOT EXISTS (SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId)
		BEGIN
		    SET @ErrorMessage = 'El Id del perfil ingresado no existe.';
			THROW 50001, @ErrorMessage, 1;
		END

		-- Eliminar los permisos asociados a este perfil en la tabla ProfileGrant
		DELETE FROM ProfileGrant WHERE ProfileId = @ProfileId;

		/********************************************************************************************
							DEVOLUCI�N DE ESTADO DE EXITO
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