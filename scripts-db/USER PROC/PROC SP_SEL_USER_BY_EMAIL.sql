USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_SEL_USER_BY_EMAIL')
    DROP PROCEDURE SP_SEL_USER_BY_EMAIL;
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE SP_SEL_USER_BY_EMAIL
    @Email NVARCHAR(255)
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_SEL_USER_BY_EMAIL
    --  Descripci�n: Obtiene los detalles de un usuario basado en su
    --               correo electr�nico.
    --
    --  Par�metros de entrada:
    --    @Email (NVARCHAR 255) - Correo del usuario.
    --
    --  Retorna:
    --    - UserId, Name, Email, ProfileId, IsActive si el usuario 
    --      existe y est� activo.
    --    - No retorna nada si el usuario no existe o est� inactivo.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creaci�n: 
    --    - 17-03-2025
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;

    SELECT 
        UserId,
        Name,
        Email,
        ProfileId,
        IsActive
    FROM [User]
    WHERE Email = @Email;
END;
GO