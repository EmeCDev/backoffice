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
    --  Descripción: Obtiene todos los GrantId asignados a los perfiles.
    --
    --  Parámetros de entrada:
    --    Ningún parámetro de entrada.
    --
    --  Retorna:
    --    - Una lista de GrantId, Name y Description de la tabla Grant.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creación: 
    --    - 18-03-2025
    ---------------------------------------------------------------*/
    
    SET NOCOUNT ON;

    SELECT GrantId, [Name], [Description]
    FROM [Grant];
END;
GO
