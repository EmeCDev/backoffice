USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_SEL_GRANT_IDS_BY_PROFILE')
    DROP PROCEDURE SP_SEL_GRANT_IDS_BY_PROFILE;
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE SP_SEL_GRANT_IDS_BY_PROFILE
    @ProfileId INT
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_SEL_GRANT_IDS_BY_PROFILE
    --  Descripción: Obtiene todos los GrantId asignados a un perfil
    --               dado su ProfileId.
    --
    --  Parámetros de entrada:
    --    @ProfileId (INT) - ID del perfil del cual se desean obtener los permisos.
    --
    --  Retorna:
    --    - Una lista de GrantId asociados al ProfileId dado.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creación: 
    --    - 17-03-2025
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;

    SELECT GrantId
    FROM [ProfileGrant]
    WHERE ProfileId = @ProfileId;
END;
GO