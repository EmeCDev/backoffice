USE DEV_PORTALGEN
GO
DROP PROCEDURE IF EXISTS SP_SEL_EMPRESAS_ZK
GO

CREATE PROCEDURE SP_SEL_EMPRESAS_ZK
    @ServerId INT = NULL,
    @CompanyName NVARCHAR(255) = NULL,
    @IsActive BIT = NULL
AS
BEGIN
    BEGIN TRY
        DECLARE @ErrorMessage NVARCHAR(1000) = NULL;
        DECLARE @sqlCommand NVARCHAR(MAX);

        -- Validación de ServerId al inicio
        IF @ServerId IS NULL OR @ServerId NOT IN (1, 2, 3)
        BEGIN
            SET @ErrorMessage = 'Debe indicar un ServerId válido (1, 2 o 3).';
            THROW 50001, @ErrorMessage, 1;
        END

        SET @sqlCommand = N'SELECT 
                           EmpresaID, 
                           EmpresaCliente, 
                           EmpresaNombreBD, 
                           EmpresaFechaIngreso, 
                           Activo, 
                           1 AS ServerId 
                           FROM [ZK_Att_Acc].[dbo].[Empresa] 
                           WHERE 1 = 1 ';

        -- Filtro por nombre de compañía
        IF @CompanyName IS NOT NULL
            SET @sqlCommand = @sqlCommand + N'AND EmpresaCliente LIKE ''''%' + @CompanyName + '%'''' ';

        -- Filtro por estado activo
        IF @IsActive IS NOT NULL
            SET @sqlCommand = @sqlCommand + N'AND Activo = ' + CAST(@IsActive AS NVARCHAR(1)) + ' ';

        -- Ordenamiento
        SET @sqlCommand = @sqlCommand + N'ORDER BY EmpresaCliente;';
    
        -- Ejecución según ServerId
        IF @ServerId = 1
            EXEC('SELECT * FROM OPENQUERY(BD1GESTION, ''' + @sqlCommand + ''')');
        ELSE IF @ServerId = 2
            EXEC('SELECT * FROM OPENQUERY(BD2GESTION, ''' + @sqlCommand + ''')');
        ELSE IF @ServerId = 3
            EXEC('SELECT * FROM OPENQUERY(BD3GESTION, ''' + @sqlCommand + ''')');

        PRINT(@sqlCommand);
    END TRY
    BEGIN CATCH
        IF @ErrorMessage IS NOT NULL
            THROW 50001, @ErrorMessage, 1;
        ELSE
            THROW;
    END CATCH
END;
GO

exec SP_SEL_EMPRESAS_ZK 
@ServerId = 1;