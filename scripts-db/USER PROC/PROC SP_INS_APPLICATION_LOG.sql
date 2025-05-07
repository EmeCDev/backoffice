USE DEV_PORTALGEN;
GO
IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_INS_APPLICATION_LOG')
    DROP PROCEDURE SP_INS_APPLICATION_LOG;
GO

CREATE PROCEDURE SP_INS_APPLICATION_LOG
    @UserId INT = NULL,
    @IpAddress NVARCHAR(50),
    @StartDate DATETIME,
    @ProcessName NVARCHAR(100),
    @HttpMethod NVARCHAR(10) = NULL,
    @Endpoint NVARCHAR(255) = NULL,
    @Parameters NVARCHAR(MAX) = NULL,
    @ResponseCode INT = NULL,
    @ResponseMessage NVARCHAR(255) = NULL,
    @ResponseData NVARCHAR(MAX) = NULL,
    @ProcessStatus NVARCHAR(50),
    @EndDate DATETIME,
    @InnerError NVARCHAR(MAX) = NULL
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_INS_APPLICATION_LOG
    --  Descripción: Inserta un nuevo registro en la tabla ApplicationLog.
    --
    --  Parámetros de entrada:
    --    @UserId (INT) - Identificador del usuario (puede ser NULL).
    --    @IpAddress (NVARCHAR 50) - Dirección IP del usuario.
    --    @StartDate (DATETIME) - Fecha de inicio del proceso.
    --    @ProcessName (NVARCHAR 100) - Nombre del proceso ejecutado.
    --    @HttpMethod (NVARCHAR 10) - Método HTTP (puede ser NULL).
    --    @Endpoint (NVARCHAR 255) - Endpoint de la solicitud (puede ser NULL).
    --    @Parameters (NVARCHAR MAX) - Parámetros de la solicitud (puede ser NULL).
    --    @ResponseCode (INT) - Código de respuesta de la solicitud (puede ser NULL).
    --    @ResponseMessage (NVARCHAR 255) - Mensaje de respuesta (puede ser NULL).
    --    @ResponseData (NVARCHAR MAX) - Datos de la respuesta (puede ser NULL).
    --    @ProcessStatus (NVARCHAR 50) - Estado del proceso.
    --    @EndDate (DATETIME) - Fecha de fin del proceso.
    --    @InnerError (NVARCHAR MAX) - Errores internos (puede ser NULL).
    --
    --  Retorna:
    --    No retorna ningún valor, pero inserta un registro en la tabla ApplicationLog.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creación: 
    --    - 13-03-2025
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;

    INSERT INTO ApplicationLog (
        UserId,
        IpAddress,
        StartDate,
        ProcessName,
        HttpMethod,
        [Endpoint],
        [Parameters],
        ResponseCode,
        ResponseMessage,
        ResponseData,
        [ProcessStatus],
        EndDate,
        InnerError
    )
    VALUES (
        @UserId,
        @IpAddress,
        @StartDate,
        @ProcessName,
        @HttpMethod,
        @Endpoint,
        @Parameters,
        @ResponseCode,
        @ResponseMessage,
        @ResponseData,
        @ProcessStatus,
        @EndDate,
        @InnerError
    );
END;
GO