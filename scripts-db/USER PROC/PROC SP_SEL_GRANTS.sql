USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_SEL_GRANTS')
    DROP PROCEDURE SP_SEL_GRANTS;
GO

CREATE PROCEDURE SP_SEL_GRANTS
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_SEL_GRANTS
    --  Descripci�n: Obtiene todos los GrantId asignados a los perfiles.
    --
    --  Par�metros de entrada:
    --    Ning�n par�metro de entrada.
    --
    --  Retorna:
    --    - Una lista de GrantId, Name y Description de la tabla Grant.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creaci�n: 
    --    - 18-03-2025
    ---------------------------------------------------------------*/
    
    SET NOCOUNT ON;

    SELECT GrantId, [Name], [Description]
    FROM [Grant];
END;
GO
