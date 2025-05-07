USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_SEL_PROFILES')
    DROP PROCEDURE SP_SEL_PROFILE_BY_ID;
GO

-- Crear el procedimiento almacenado para obtener todos los perfiles
CREATE PROCEDURE SP_SEL_PROFILE_BY_ID
	@ProfileId INT = NULL
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_SEL_PROFILE_BY_ID
    --  Descripción: Obtiene un registro de perfil por id.
    --
    --  Retorna:
    --    - ProfileId, Name, IsActive, CreatedAt, CreatedBy, UpdatedAt, UpdatedBy
    --
    --  Creado por: 
    --    - Matias Castro
    --  Modificado por:
    --    - [Tu Nombre]
    --  Fecha Modificación: 
    --    - [Fecha Actual]
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;

    SELECT 
        ProfileId,
        [Name],
        IsActive,
        CreatedAt,
        CreatedBy,
        UpdatedAt,
        UpdatedBy
    FROM 
        [Profile]
		
    WHERE
        ProfileId = @ProfileId;
END;
GO