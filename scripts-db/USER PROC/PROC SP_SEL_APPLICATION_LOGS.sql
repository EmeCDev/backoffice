USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_SEL_APPLICATION_LOGS')
    DROP PROCEDURE SP_SEL_APPLICATION_LOGS;
GO

CREATE PROCEDURE SP_SEL_APPLICATION_LOGS
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @Email NVARCHAR(255) = NULL
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_SEL_APPLICATION_LOGS
    --  Descripción: Obtiene todos los registros de la tabla 
    --               ApplicationLog.
    --
    --  Parámetros de entrada:
    --		@InitDate DATE - Fecha de inicio para filtrar los registros
    --		@EndDate DATE - Fecha de fin para filtrar los registros
    --		@Email NVARCHAR(255) - Email del usuario para filtrar los registros
    --
    --  Retorna:
    --    - LogId, Email, StartDate, EndDate, ProcessName, 
    --      Parameters, ResponseData.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creación: 
    --    - 13-03-2025
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;

    -- Consulta con validación de fechas y parámetros
    SELECT 
        u.Email,
        al.StartDate,
        al.EndDate,
        al.ProcessName,
        al.Parameters,
        al.ResponseData
    FROM ApplicationLog al
    JOIN [User] u ON u.UserId = al.UserId
    WHERE 
        (@StartDate IS NULL OR CONVERT(DATE, al.StartDate, 23) >= @StartDate)  -- Usamos CONVERT con estilo 23
        AND (@EndDate IS NULL OR CONVERT(DATE, al.StartDate, 23) <= @EndDate) -- Usamos CONVERT con estilo 23
        AND (@Email IS NULL OR u.Email LIKE '%' + @Email + '%') 
    ORDER BY al.LogId DESC;
END;