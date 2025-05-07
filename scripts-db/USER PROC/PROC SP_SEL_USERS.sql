USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_SEL_USERS')
    DROP PROCEDURE SP_SEL_USERS;
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE SP_SEL_USERS
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_SEL_ALL_USERS
    --  Descripción: Obtiene todos los detalles de los usuarios,
    --               excluyendo la contraseña.
    --
    --  Parámetros de entrada: Ninguno.
    --
    --  Retorna:
    --    - UserId, Name, Email, ProfileId, IsActive, CreatedAt, 
    --      CreatedBy, UpdatedAt, UpdatedBy.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creación: 
    --    - 18-03-2025
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;

    SELECT 
        UserId,
        [Name],
        Email,
        ProfileId,
        IsActive
    FROM [User];
END;
GO