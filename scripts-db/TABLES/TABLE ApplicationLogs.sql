USE Backoffice;

DROP TABLE IF EXISTS ApplicationLog;
GO
CREATE TABLE ApplicationLog (
    [LogId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [UserId] INT NULL, 
    [IpAddress] NVARCHAR(20) NOT NULL, 
    [StartDate] DATETIME NOT NULL,
    [ProcessName] NVARCHAR(255) NOT NULL, 
    [HttpMethod] NVARCHAR(10) NULL,
    [Endpoint] NVARCHAR(255) NULL,
    [Parameters] NVARCHAR(255) NULL,
    [ResponseData] NVARCHAR(MAX) NULL, 
    [ProcessStatus] NVARCHAR(50) NOT NULL, 
    [EndDate] DATETIME NOT NULL, 
    [InnerError] NVARCHAR(4000) NULL
);
GO

/*--------------------------------------------------------------------------------------------
CRUD SP_SEL_APPLICATIONLOG
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_SEL_APPLICATIONLOG;
GO
CREATE PROC SP_SEL_APPLICATIONLOG
@UserEmail NVARCHAR(255) = NULL,
@UserName NVARCHAR(255) = NULL,
@StartDate NVARCHAR(10) = NULL,
@EndDate NVARCHAR(10) = NULL,
@ProcessName NVARCHAR(255) = NULL, 
@ProcessStatus NVARCHAR(50) = NULL 
AS
BEGIN
	/********************************************************************************************
	Nombre:      SP_SEL_APPLICATIONLOG
	Descripci�n: Descripci�n breve de lo que hace este procedimiento.

	Creado por:  Matias Castro Nu�ez
	Fecha:       06-01-2025

	Modificaciones:
	- dd-mm-aaaa (nombre): Descripci�n de la modificaci�n.

	Par�metros:
	@UserId INT = Identificador numerico del usuario que realiza el proceso. 
	@StartDate DATETIME = Fecha de inicio del proceso.
	@EndDate DATETIME = Fecha de finalizaci�n del proceso. 
	@ProcessName NVARCHAR(255) = Nombre del proceso ejecutado. 
	@ProcessStatus NVARCHAR(50) = Estado del proceso. 

	Retorna: 1 en caso de �xito o lanza un error detallado. 
	********************************************************************************************/

	BEGIN TRY

		/********************************************************************************************
									DECLARACI�N DE VARIABLES
		********************************************************************************************/
		
		DECLARE @ErrorMessage NVARCHAR(MAX) = NULL,
				@ConvertedStartDate DATE = NULL,
				@ConvertedEndDate DATE = NULL;

		/********************************************************************************************
									    SELECCI�N DE LOGS
		********************************************************************************************/

		-- Convertir @StartDate a date.
		IF @StartDate IS NOT NULL
		BEGIN
			SET @ConvertedStartDate = TRY_CONVERT(DATE, @StartDate, 105); -- 'dd-MM-yyyy'
			IF @ConvertedStartDate IS NULL
			BEGIN
				SET @ErrorMessage = 'Formato de fecha inv�lido para el filtro de FechaInicio. Debe ser dd-MM-yyyy.';
				THROW 50001, @ErrorMessage, 1;
			END
		END

		-- Convertir @EndDate a date.
		IF @EndDate IS NOT NULL
		BEGIN
			SET @ConvertedEndDate = TRY_CONVERT(DATE, @EndDate, 105);
			IF @ConvertedEndDate IS NULL
			BEGIN
				SET @ErrorMessage = 'Formato de fecha inv�lido para el filtro de Fecha Fin. Debe ser dd-MM-yyyy.';
				THROW 50001, @ErrorMessage, 1;
			END
		END

		SELECT 
		al.LogId,
		ISNULL(u.[Email], 'Desconocido') AS [UserEmail],
		ISNULL(u.[Name], 'Desconocido') AS [UserName],
		al.IpAddress,
		al.StartDate,
		al.ProcessName,
		al.HttpMethod,
		al.[Endpoint],
		al.[Parameters],
		al.ResponseData,
		al.ProcessStatus,
		al.EndDate,
		al.InnerError
		FROM ApplicationLog al
		LEFT JOIN [User] u ON (u.UserId = al.UserId)
		WHERE
		(@UserEmail IS NULL OR u.Email LIKE '%' + @UserEmail + '%') AND
		(@UserName IS NULL OR u.[Name] LIKE '%' + @UserName + '%') AND
		(@StartDate IS NULL OR CONVERT(DATE, al.StartDate) >= @ConvertedStartDate) AND
		(@EndDate IS NULL OR CONVERT(DATE, al.EndDate) <= @ConvertedEndDate) AND
		(@ProcessName IS NULL OR al.ProcessName = @ProcessName) AND
		(@ProcessStatus IS NULL OR al.ProcessStatus = @ProcessStatus)
		ORDER BY LogId DESC
		;

	END TRY
	BEGIN CATCH
		IF @ErrorMessage IS NOT NULL
			THROW 50001, @ErrorMessage, 1;

		THROW;
	END CATCH
END
GO

/*--------------------------------------------------------------------------------------------
CRUD SP_INS_APPLICATIONLOG
--------------------------------------------------------------------------------------------*/

DROP PROC IF EXISTS SP_INS_APPLICATIONLOG;
GO
CREATE PROC SP_INS_APPLICATIONLOG
    @UserId INT = NULL,
    @IpAddress NVARCHAR(20),
    @StartDate DATETIME,
    @ProcessName NVARCHAR(255),
    @HttpMethod NVARCHAR(10) = NULL,
    @Endpoint NVARCHAR(255) = NULL,
    @Parameters NVARCHAR(255) = NULL,
    @ResponseData NVARCHAR(MAX) = NULL,
    @ProcessStatus NVARCHAR(50),
    @EndDate DATETIME,
    @InnerError NVARCHAR(4000) = NULL
AS
BEGIN
    /********************************************************************************************
    Nombre:      SP_INS_APPLICATIONLOG
    Descripci�n: Inserta un nuevo registro en la tabla ApplicationLog.

    Creado por:  Matias Castro Nu�ez
    Fecha:       06-01-2025

    Modificaciones:
    - dd-mm-aaaa (nombre): Descripci�n de la modificaci�n.

    Par�metros:
    @UserEmail NVARCHAR(255) = Correo del usuario que realiza el proceso (opcional).
    @UserName NVARCHAR(255) = Nombre del usuario (opcional).
    @IpAddress NVARCHAR(20) = Direcci�n IP del usuario.
    @StartDate DATETIME = Fecha de inicio del proceso.
    @ProcessName NVARCHAR(255) = Nombre del proceso.
    @HttpMethod NVARCHAR(10) = M�todo HTTP (opcional).
    @Endpoint NVARCHAR(255) = Endpoint (opcional).
    @Parameters NVARCHAR(255) = Par�metros (opcional).
    @ResponseData NVARCHAR(MAX) = Respuesta del proceso (opcional).
    @ProcessStatus NVARCHAR(50) = Estado del proceso.
    @EndDate DATETIME = Fecha de finalizaci�n del proceso.
    @InnerError NVARCHAR(4000) = Mensaje de error interno (opcional).

    Retorna: 1 en caso de �xito o lanza un error detallado.
    ********************************************************************************************/

    BEGIN TRY

		/********************************************************************************************
									 DECLARACI�N DE VARIABLES
		********************************************************************************************/

		DECLARE @ErrorMessage NVARCHAR(255) = NULL;

		/********************************************************************************************
									    INSERCI�N DEL LOG
		********************************************************************************************/

        INSERT INTO ApplicationLog
        (
            UserId,
            IpAddress,
            StartDate,
            ProcessName,
            HttpMethod,
            [Endpoint],
            [Parameters],
            ResponseData,
            ProcessStatus,
            EndDate,
            InnerError
        )
        VALUES
        (
            @UserId,
            @IpAddress,
            @StartDate,
            @ProcessName,
            @HttpMethod,
            @Endpoint,
            @Parameters,
            @ResponseData,
            @ProcessStatus,
            @EndDate,
            @InnerError
        );

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
