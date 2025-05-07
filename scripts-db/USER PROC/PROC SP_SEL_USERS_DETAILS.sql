USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_SEL_USERS_DETAILS')
    DROP PROCEDURE SP_SEL_USERS_DETAILS;
GO

-- Crear el procedimiento almacenado con parámetros de filtro
CREATE PROCEDURE SP_SEL_USERS_DETAILS
    @Name NVARCHAR(100) = NULL,
    @Email NVARCHAR(100) = NULL,
    @IsActive BIT = NULL
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_SEL_USERS_DETAILS
    --  Descripción: Obtiene detalles de usuarios con filtros opcionales
    --               por nombre (LIKE), email (LIKE) y estado activo.
    --               Si todos los parámetros son NULL, retorna todos los usuarios.
    --
    --  Parámetros de entrada:
    --    - @Name: Parte del nombre a buscar (NULL para todos)
    --    - @Email: Parte del email a buscar (NULL para todos)
    --    - @IsActive: Estado activo (NULL para ambos estados)
    --
    --  Retorna:
    --    - UserId, Name, Email, Profile.Name, IsActive
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
        u.UserId,
        u.[Name],
        u.Email,
        p.[Name] AS ProfileName,
        u.IsActive,
		u.ProfileId
    FROM 
        [User] u
        JOIN [Profile] p ON p.ProfileId = u.ProfileId
    WHERE 
        (@Name IS NULL OR u.[Name] LIKE '%' + @Name + '%')
        AND (@Email IS NULL OR u.Email LIKE '%' + @Email + '%')
        AND (@IsActive IS NULL OR u.IsActive = @IsActive)
    ORDER BY 
        U.UserId;
END;
GO