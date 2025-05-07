USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_INS_USER')
    DROP PROCEDURE SP_INS_USER;
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE SP_INS_USER
    @Name NVARCHAR(255),
    @Email NVARCHAR(255),
    @Password NVARCHAR(255),
    @ProfileId INT,
    @CreatedBy INT
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_INS_USER
    --  Descripci�n: Crea un nuevo usuario en la tabla [User].
    --
    --  Par�metros de entrada:
    --    @Name (NVARCHAR 255) - Nombre del usuario.
    --    @Email (NVARCHAR 255) - Correo electr�nico del usuario.
    --    @Password (NVARCHAR 255) - Contrase�a cifrada del usuario.
    --    @ProfileId (INT) - Id del perfil del usuario.
    --    @CreatedBy (INT) - Usuario que est� creando al nuevo usuario.
    --
    --  Retorna:
    --    - UserId (INT) si la creaci�n es exitosa.
    --    - Lanza un error si la creaci�n falla, con el mensaje correspondiente.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creaci�n: 
    --    - 17-03-2025
    ---------------------------------------------------------------*/
    
    SET NOCOUNT ON;

    DECLARE @UserId INT;
    DECLARE @ErrorMessage NVARCHAR(1000);

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM [User] WHERE Email = @Email)
        BEGIN
            SET @ErrorMessage = 'El correo electr�nico ya est� registrado.';
            THROW 50001, @ErrorMessage, 1;
        END

        IF NOT EXISTS (SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId)
        BEGIN
            SET @ErrorMessage = 'El perfil especificado no existe.';
            THROW 50001, @ErrorMessage, 1;
        END

        INSERT INTO [User] ([Name], Email, PasswordHash, ProfileId, IsActive, CreatedBy)
        VALUES (@Name, @Email, @Password, @ProfileId, 1, @CreatedBy);

        SET @UserId = SCOPE_IDENTITY();

        SELECT @UserId AS UserId;
    END TRY
    BEGIN CATCH
        SET @ErrorMessage = ERROR_MESSAGE();
        THROW 50001, @ErrorMessage, 1;
    END CATCH
END;
GO