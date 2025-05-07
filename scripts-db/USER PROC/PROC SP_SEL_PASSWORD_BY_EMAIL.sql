USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_SEL_PASSWORD_BY_EMAIL')
    DROP PROCEDURE SP_SEL_PASSWORD_BY_EMAIL;
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE SP_SEL_PASSWORD_BY_EMAIL
    @Email NVARCHAR(255)
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_SEL_PASSWORD_BY_EMAIL
    --  Descripción: Obtiene el hash de la contraseña de un usuario 
    --               basado en su correo electrónico.
    --  
    --  Parámetros de entrada:
    --    @Email (NVARCHAR 255) - Correo del usuario.
    --
    --  Retorna:
    --    - PasswordHash del usuario si existe.
    --    - NULL si el usuario no existe.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creación: 
    --    - 14-03-2024
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;

    DECLARE @PasswordHash NVARCHAR(MAX);

    -- Asignamos el valor a la variable
    SELECT TOP 1 
	@PasswordHash = PasswordHash
    FROM [User]
    WHERE Email = @Email;

    -- Si no se encuentra el usuario o no está activo, @PasswordHash será NULL
    SELECT COALESCE(@PasswordHash, CAST(NULL AS NVARCHAR(MAX))) AS PasswordHash;
END;
GO