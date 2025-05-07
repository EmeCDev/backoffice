USE DEV_PORTALGEN;
GO

IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'SP_DROP_PROFILE')
    DROP PROCEDURE SP_DROP_PROFILE;
GO

CREATE PROCEDURE SP_DROP_PROFILE
    @ProfileId INT
AS
BEGIN
    SET NOCOUNT ON;
    
	DECLARE @ErrorMessage NVARCHAR(MAX);

    BEGIN TRY
        IF @ProfileId = 1
		BEGIN
			SET @ErrorMessage = 'No se puede eliminar el perfil indicado';
            THROW 50001, @ErrorMessage, 1;
        END

		IF EXISTS (SELECT 1 FROM [User] WHERE ProfileId = @ProfileId)
		BEGIN
			SET @ErrorMessage = 'No se puede eliminar el perfil porque tiene usuarios asociados';
			THROW 50001, @ErrorMessage, 1;
		END


        BEGIN TRANSACTION;
        
            DELETE FROM [ProfileGrant] 
            WHERE ProfileId = @ProfileId;
            
            DELETE FROM [Profile]
            WHERE ProfileId = @ProfileId;
            
            IF @@ROWCOUNT = 0
			BEGIN
                SET @ErrorMessage = 'El perfil especificado no existe';
				THROW 50001, @ErrorMessage, 1;
            END

        COMMIT TRANSACTION;
        
        SELECT 0 AS ResultCode, 'Perfil eliminado correctamente' AS ResultMessage;
    END TRY
    BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
        
    IF @ErrorMessage IS NOT NULL
        THROW 50001, @ErrorMessage, 1;
    
    THROW;
END CATCH;
END;
GO

exec SP_DROP_PROFILE
@ProfileID = 2005;


select * from [Profile];
select * from [User];

DECLARE @ErrorMessage NVARCHAR(MAX)
IF EXISTS (SELECT 1 FROM [User] WHERE ProfileId = 2005)
BEGIN
	SET @ErrorMessage = 'No se puede eliminar el perfil porque tiene usuarios asociados';
	THROW 50001, @ErrorMessage, 1;
END