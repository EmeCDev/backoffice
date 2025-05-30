USE DEV_PORTALGEN
GO
DROP PROCEDURE IF EXISTS SP_SEL_ZK_DEVICES
GO

USE DEV_PORTALGEN
GO
CREATE PROCEDURE SP_SEL_ZK_DEVICES
    @ServerId INT = NULL,
    @CompanyId INT = NULL,
    @SerialNumber NVARCHAR(50) = NULL,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
    BEGIN TRY
		DECLARE @Bd NVARCHAR(255) = 'ZK_Att_Acc';
        DECLARE @ErrorMessage NVARCHAR(1000);
        DECLARE @sqlCommand NVARCHAR(MAX);
        DECLARE @MaxSearchDays INT = 7;

        IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL
        BEGIN
            DECLARE @DateDiff INT;
            SET @DateDiff = DATEDIFF(DAY, @StartDate, @EndDate);
            
            IF @DateDiff > @MaxSearchDays AND (@EndDate IS NULL AND @StartDate IS NULL)
            BEGIN
                SET @ErrorMessage = 'El rango de fechas no puede ser mayor a ' + CAST(@MaxSearchDays AS VARCHAR(5)) + ' días.';
                THROW 50001, @ErrorMessage, 1;
            END
        END

        SET @sqlCommand = N'SELECT ' + 
                         'ee.Equipo as SerialNumber, ' + 
                         'ee.DeviceType as Type, ' + 
                         'ee.PushVer as PushVersion, ' +
                         'ee.FechaConexion as LastConnection, ' + 
                         CAST(@ServerId AS NVARCHAR(10)) + ' as ServerId, ' +
                         'e.EmpresaID as CompanyId, ' + 
                         'e.EmpresaCliente as CompanyName, ' +
                         'e.EmpresaNombreBD as CompanyDatabase ' +
                         'FROM [ZK_Att_Acc].[dbo].[EquipoEmpresa] ee ' + 
                         'LEFT JOIN [ZK_Att_Acc].[dbo].[EquipoGenHoras] eg ON ee.Equipo = eg.Equipo ' + 
                         'LEFT JOIN [ZK_Att_Acc].[dbo].[Empresa] e ON eg.EmpresaID = e.EmpresaID ' + 
                         'WHERE 1 = 1 ';

        IF @CompanyId IS NOT NULL
            SET @sqlCommand = @sqlCommand + N'AND e.EmpresaID = ' + CAST(@CompanyId AS NVARCHAR(10)) + ' ';

        IF @SerialNumber IS NOT NULL
			SET @sqlCommand = @sqlCommand + N'AND ee.Equipo LIKE ''''%' + @SerialNumber + '%'''' ';


        IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL
            SET @sqlCommand = @sqlCommand + 
                N'AND CAST(ee.FechaConexion AS DATE) BETWEEN ''''' + CONVERT(NVARCHAR(10), @StartDate, 120) +
				''''' AND ''''' + CONVERT(NVARCHAR(10), DATEADD(DAY, 1, @EndDate), 120) + ''''' ';

        SET @sqlCommand = @sqlCommand + N'ORDER BY e.EmpresaID, ee.FechaConexion;';

        IF @ServerId = 1
		BEGIN
            EXEC('SELECT * FROM OPENQUERY(BD1GESTION, ''' + @sqlCommand + ''')');
		END
        ELSE IF @ServerId = 2
		BEGIN
            EXEC('SELECT * FROM OPENQUERY(BD2GESTION, ''' + @sqlCommand + ''')');
		END
        ELSE IF @ServerId = 3
		BEGIN
            EXEC('SELECT * FROM OPENQUERY(BD3GESTION, ''' + @sqlCommand + ''')');
		END
		ELSE
		BEGIN
			SET @ErrorMessage = 'Debe indicar un ServerId valido.';
            THROW 50001, @ErrorMessage, 1;
		END

    END TRY
    BEGIN CATCH
    
    IF @ErrorMessage IS NOT NULL
	BEGIN
	    SET @ErrorMessage = ERROR_MESSAGE();
        THROW 50001, @ErrorMessage, 1;
	END
    ELSE
        THROW;
END CATCH
END;
GO

EXEC SP_SEL_ZK_DEVICES
@ServerId = 1,
@CompanyId = 6,
@SerialNumber = '11111111111111';