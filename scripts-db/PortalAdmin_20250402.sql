USE [DEV_PORTALGEN]
GO
/****** Object:  StoredProcedure [dbo].[SP_UPD_USER]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_UPD_USER]
GO
/****** Object:  StoredProcedure [dbo].[SP_UPD_PROFILE]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_UPD_PROFILE]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_ZK_DEVICES]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_SEL_ZK_DEVICES]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_USERS_DETAILS]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_SEL_USERS_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_USERS]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_SEL_USERS]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_USER_BY_EMAIL]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_SEL_USER_BY_EMAIL]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_PROFILES]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_SEL_PROFILES]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_PROFILE_BY_ID]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_SEL_PROFILE_BY_ID]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_PASSWORD_BY_EMAIL]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_SEL_PASSWORD_BY_EMAIL]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_GRANTS]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_SEL_GRANTS]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_GRANT_IDS_BY_PROFILE]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_SEL_GRANT_IDS_BY_PROFILE]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_EMPRESAS_ZK]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_SEL_EMPRESAS_ZK]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_COMPANY_INFO]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_SEL_COMPANY_INFO]
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_APPLICATION_LOGS]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_SEL_APPLICATION_LOGS]
GO
/****** Object:  StoredProcedure [dbo].[SP_INS_USER_IN_ZK_DEVICES]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_INS_USER_IN_ZK_DEVICES]
GO
/****** Object:  StoredProcedure [dbo].[SP_INS_USER]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_INS_USER]
GO
/****** Object:  StoredProcedure [dbo].[SP_INS_PROFILE]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_INS_PROFILE]
GO
/****** Object:  StoredProcedure [dbo].[SP_INS_APPLICATION_LOG]    Script Date: 02-04-2025 17:39:18 ******/
DROP PROCEDURE [dbo].[SP_INS_APPLICATION_LOG]
GO
ALTER TABLE [dbo].[User] DROP CONSTRAINT [FK__User__ProfileId__5E8A0973]
GO
ALTER TABLE [dbo].[ProfileGrant] DROP CONSTRAINT [FK__ProfileGr__Profi__33D4B598]
GO
ALTER TABLE [dbo].[ProfileGrant] DROP CONSTRAINT [FK__ProfileGr__Grant__34C8D9D1]
GO
ALTER TABLE [dbo].[User] DROP CONSTRAINT [DF__User__UpdatedAt__6166761E]
GO
ALTER TABLE [dbo].[User] DROP CONSTRAINT [DF__User__CreatedAt__607251E5]
GO
ALTER TABLE [dbo].[User] DROP CONSTRAINT [DF_User_IsActive]
GO
ALTER TABLE [dbo].[Profile] DROP CONSTRAINT [DF__Profile__Updated__267ABA7A]
GO
ALTER TABLE [dbo].[Profile] DROP CONSTRAINT [DF__Profile__Created__25869641]
GO
ALTER TABLE [dbo].[Profile] DROP CONSTRAINT [DF__Profile__IsActiv__24927208]
GO
/****** Object:  Table [dbo].[User]    Script Date: 02-04-2025 17:39:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND type in (N'U'))
DROP TABLE [dbo].[User]
GO
/****** Object:  Table [dbo].[ProfileGrant]    Script Date: 02-04-2025 17:39:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProfileGrant]') AND type in (N'U'))
DROP TABLE [dbo].[ProfileGrant]
GO
/****** Object:  Table [dbo].[Profile]    Script Date: 02-04-2025 17:39:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Profile]') AND type in (N'U'))
DROP TABLE [dbo].[Profile]
GO
/****** Object:  Table [dbo].[Grant]    Script Date: 02-04-2025 17:39:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Grant]') AND type in (N'U'))
DROP TABLE [dbo].[Grant]
GO
/****** Object:  Table [dbo].[Cliente_Empresa]    Script Date: 02-04-2025 17:39:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_Empresa]') AND type in (N'U'))
DROP TABLE [dbo].[Cliente_Empresa]
GO
/****** Object:  Table [dbo].[ApplicationLog]    Script Date: 02-04-2025 17:39:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ApplicationLog]') AND type in (N'U'))
DROP TABLE [dbo].[ApplicationLog]
GO
/****** Object:  Table [dbo].[ApplicationLog]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationLog](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[IpAddress] [nvarchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[ProcessName] [nvarchar](100) NOT NULL,
	[HttpMethod] [nvarchar](10) NULL,
	[Endpoint] [nvarchar](255) NULL,
	[Parameters] [nvarchar](max) NULL,
	[ResponseData] [nvarchar](max) NULL,
	[ProcessStatus] [nvarchar](50) NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[InnerError] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cliente_Empresa]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cliente_Empresa](
	[id] [int] NOT NULL,
	[servidor] [nvarchar](255) NULL,
	[bd_genhoras] [nvarchar](255) NULL,
	[nombre_empresa] [nvarchar](255) NULL,
	[rut_empresa] [int] NULL,
	[dv] [nvarchar](1) NULL,
	[tipo_cliente] [nvarchar](10) NULL,
	[URL_Chente] [nvarchar](max) NULL,
 CONSTRAINT [PK_Cliente_Empresa] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Grant]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Grant](
	[GrantId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[GrantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Profile]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Profile](
	[ProfileId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[IsActive] [bit] NULL,
	[CreatedAt] [datetime] NULL,
	[CreatedBy] [nvarchar](255) NOT NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProfileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProfileGrant]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProfileGrant](
	[ProfileGrantId] [int] IDENTITY(1,1) NOT NULL,
	[ProfileId] [int] NOT NULL,
	[GrantId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProfileGrantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ProfileId] ASC,
	[GrantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[PasswordHash] [nvarchar](255) NOT NULL,
	[ProfileId] [int] NOT NULL,
	[IsActive] [bit] NULL,
	[CreatedAt] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedAt] [datetime] NULL,
	[UpdatedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Profile] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Profile] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Profile] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[User] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[User] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[ProfileGrant]  WITH CHECK ADD FOREIGN KEY([GrantId])
REFERENCES [dbo].[Grant] ([GrantId])
GO
ALTER TABLE [dbo].[ProfileGrant]  WITH CHECK ADD FOREIGN KEY([ProfileId])
REFERENCES [dbo].[Profile] ([ProfileId])
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD FOREIGN KEY([ProfileId])
REFERENCES [dbo].[Profile] ([ProfileId])
GO
/****** Object:  StoredProcedure [dbo].[SP_INS_APPLICATION_LOG]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INS_APPLICATION_LOG]
    @UserId INT = NULL,
    @IpAddress NVARCHAR(50),
    @StartDate DATETIME,
    @ProcessName NVARCHAR(100),
    @HttpMethod NVARCHAR(10) = NULL,
    @Endpoint NVARCHAR(255) = NULL,
    @Parameters NVARCHAR(MAX) = NULL,
    @ResponseData NVARCHAR(MAX) = NULL,
    @ProcessStatus NVARCHAR(50),
    @EndDate DATETIME,
    @InnerError NVARCHAR(MAX) = NULL
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_INS_APPLICATION_LOG
    --  Descripción: Inserta un nuevo registro en la tabla ApplicationLog.
    --
    --  Parámetros de entrada:
    --    @UserId (INT) - Identificador del usuario (puede ser NULL).
    --    @IpAddress (NVARCHAR 50) - Dirección IP del usuario.
    --    @StartDate (DATETIME) - Fecha de inicio del proceso.
    --    @ProcessName (NVARCHAR 100) - Nombre del proceso ejecutado.
    --    @HttpMethod (NVARCHAR 10) - Método HTTP (puede ser NULL).
    --    @Endpoint (NVARCHAR 255) - Endpoint de la solicitud (puede ser NULL).
    --    @Parameters (NVARCHAR MAX) - Parámetros de la solicitud (puede ser NULL).
    --    @ResponseCode (INT) - Código de respuesta de la solicitud (puede ser NULL).
    --    @ResponseMessage (NVARCHAR 255) - Mensaje de respuesta (puede ser NULL).
    --    @ResponseData (NVARCHAR MAX) - Datos de la respuesta (puede ser NULL).
    --    @ProcessStatus (NVARCHAR 50) - Estado del proceso.
    --    @EndDate (DATETIME) - Fecha de fin del proceso.
    --    @InnerError (NVARCHAR MAX) - Errores internos (puede ser NULL).
    --
    --  Retorna:
    --    No retorna ningún valor, pero inserta un registro en la tabla ApplicationLog.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creación: 
    --    - 13-03-2025
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;

    INSERT INTO ApplicationLog (
        UserId,
        IpAddress,
        StartDate,
        ProcessName,
        HttpMethod,
        [Endpoint],
        [Parameters],
        ResponseData,
        [ProcessStatus],
        EndDate,
        InnerError
    )
    VALUES (
        @UserId,
        @IpAddress,
        @StartDate,
        @ProcessName,
        @HttpMethod,
        @Endpoint,
        @Parameters,
        @ResponseData,
        @ProcessStatus,
        @EndDate,
        @InnerError
    );
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_INS_PROFILE]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INS_PROFILE]
    @Name NVARCHAR(255),
    @GrantsList NVARCHAR(MAX),
    @CreatedBy INT
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_INS_PROFILE
    --  Descripción: 
    --    Crea un nuevo perfil con sus grants asociados
    --    Ignora silenciosamente los grants que no existen
    --    Devuelve el ID del perfil creado como resultado
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(1000);
    DECLARE @ValidGrantsCount INT;
    DECLARE @ProfileId INT;

    BEGIN TRY
        -- Validación 1: Nombre requerido
        IF NULLIF(@Name, '') IS NULL
        BEGIN
            SET @ErrorMessage = 'El nombre del perfil es requerido.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Validación 2: Nombre duplicado
        IF EXISTS (SELECT 1 FROM [Profile] WHERE [Name] = @Name)
        BEGIN
            SET @ErrorMessage = 'El nombre del perfil ya está registrado.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Validación 3: GrantsList requerida
        IF NULLIF(@GrantsList, '') IS NULL
        BEGIN
            SET @ErrorMessage = 'Debe especificar al menos un permiso para el perfil.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Crear tabla temporal para grants válidos
        CREATE TABLE #ValidGrants (
            GrantId INT PRIMARY KEY
        );

        -- Insertar solo grants válidos (que existen en la tabla [Grant])
        INSERT INTO #ValidGrants (GrantId)
        SELECT DISTINCT CAST(Value AS INT)
        FROM STRING_SPLIT(@GrantsList, ',')
        WHERE ISNUMERIC(Value) = 1
        AND CAST(Value AS INT) IN (SELECT GrantId FROM [Grant]);

        -- Contar grants válidos
        SET @ValidGrantsCount = (SELECT COUNT(*) FROM #ValidGrants);

        -- Validación 4: Mínimo un grant válido
        IF @ValidGrantsCount = 0
        BEGIN
            SET @ErrorMessage = 'No se encontraron permisos válidos para asociar al perfil.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Iniciar transacción
        BEGIN TRANSACTION;

            -- Insertar el nuevo perfil
            INSERT INTO [Profile] ([Name], [CreatedBy], [CreatedAt])
            VALUES (@Name, @CreatedBy, GETDATE());

            -- Obtener el ID del perfil creado
            SET @ProfileId = SCOPE_IDENTITY();

            -- Insertar los grants válidos asociados
            INSERT INTO ProfileGrant (ProfileId, GrantId)
            SELECT @ProfileId, GrantId
            FROM #ValidGrants;

        COMMIT TRANSACTION;

        -- Devolver el ID del perfil creado
        SELECT @ProfileId AS ProfileId;

        -- Limpiar tabla temporal
        DROP TABLE #ValidGrants;

    END TRY
    BEGIN CATCH
        -- Revertir transacción si está activa
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Limpiar tabla temporal si existe
        IF OBJECT_ID('tempdb..#ValidGrants') IS NOT NULL
            DROP TABLE #ValidGrants;

        -- Manejo de errores
        SET @ErrorMessage = ERROR_MESSAGE();
        
        IF ERROR_NUMBER() = 50001
            THROW;
        ELSE
            THROW 50001, @ErrorMessage, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_INS_USER]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE [dbo].[SP_INS_USER]
    @Name NVARCHAR(255),
    @Email NVARCHAR(255),
    @Password NVARCHAR(255),
    @ProfileId INT,
    @CreatedBy INT
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_INS_USER
    --  Descripción: Crea un nuevo usuario en la tabla [User].
    --
    --  Parámetros de entrada:
    --    @Name (NVARCHAR 255) - Nombre del usuario.
    --    @Email (NVARCHAR 255) - Correo electrónico del usuario.
    --    @Password (NVARCHAR 255) - Contraseña cifrada del usuario.
    --    @ProfileId (INT) - Id del perfil del usuario.
    --    @CreatedBy (INT) - Usuario que está creando al nuevo usuario.
    --
    --  Retorna:
    --    - UserId (INT) si la creación es exitosa.
    --    - Lanza un error si la creación falla, con el mensaje correspondiente.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creación: 
    --    - 17-03-2025
    ---------------------------------------------------------------*/
    
    SET NOCOUNT ON;

    DECLARE @UserId INT;
    DECLARE @ErrorMessage NVARCHAR(1000);

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM [User] WHERE Email = @Email)
        BEGIN
            SET @ErrorMessage = 'El correo electrónico ya está registrado.';
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
/****** Object:  StoredProcedure [dbo].[SP_INS_USER_IN_ZK_DEVICES]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INS_USER_IN_ZK_DEVICES]
    @ServerId INT = NULL,
    @DevicesSerialNumbers NVARCHAR(MAX),
    @uid INT = NULL,
    @Pin INT,
    @Card VARCHAR(50) = NULL,
    @password VARCHAR(50),
    @group INT = 1,
    @starttime INT = 0,
    @endtime INT = 0,
    @name VARCHAR(100),
    @privilege INT = NULL,
    @disable INT = 0,
    @verify INT = 0,
    @tz VARCHAR(50) = NULL,
    @vicecard INT = NULL
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        DECLARE @ErrorMessage NVARCHAR(1000);
        DECLARE @DatabaseName NVARCHAR(100) = 'ZK_Att_Acc';
        DECLARE @sqlCommand NVARCHAR(MAX);
        DECLARE @LinkedServer NVARCHAR(20);
        DECLARE @serieActual NVARCHAR(50);
        DECLARE @tipoEquipo NVARCHAR(20);
        DECLARE @tempTable TABLE (DeviceType NVARCHAR(20));

        -- Determinar el servidor vinculado
        SET @LinkedServer = CASE @ServerId
            WHEN 1 THEN 'BD1_LINKED'
            WHEN 2 THEN 'BD2_LINKED'
            WHEN 3 THEN 'BD3_LINKED'
            ELSE NULL
        END;

        IF @LinkedServer IS NULL
        BEGIN
            SET @ErrorMessage = 'Debe indicar un ServerId válido (1, 2 o 3).';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Manejo seguro del cursor
        BEGIN TRY
            IF CURSOR_STATUS('global', 'seriesCursor') >= 0
            BEGIN
                CLOSE seriesCursor;
                DEALLOCATE seriesCursor;
            END
        END TRY BEGIN CATCH END CATCH

        -- Crear cursor con seguridad
        DECLARE seriesCursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT LTRIM(RTRIM(value)) AS Serie
        FROM STRING_SPLIT(@DevicesSerialNumbers, ',');
        
        OPEN seriesCursor;
        FETCH NEXT FROM seriesCursor INTO @serieActual;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- 1. Obtener el tipo de equipo desde el servidor remoto
            SET @sqlCommand = 'SELECT * FROM OPENQUERY(' + @LinkedServer + ', ''SELECT DeviceType FROM ' + @DatabaseName + '.dbo.EquipoEmpresa WHERE Equipo = ''''' + REPLACE(@serieActual, '''', '''''') + ''''''')';
            
            DELETE FROM @tempTable;
            INSERT INTO @tempTable
            EXEC sp_executesql @sqlCommand;
            
            SELECT @tipoEquipo = DeviceType FROM @tempTable;

            IF @tipoEquipo IS NULL
            BEGIN
                PRINT 'No se encontró el tipo de equipo para la serie: ' + @serieActual;
            END
            ELSE
            BEGIN
                -- 2. Ejecutar el procedimiento principal según el tipo de equipo
                IF @tipoEquipo = 'acc'
                BEGIN
                    SET @sqlCommand = 'EXEC [' + @LinkedServer + '].[' + @DatabaseName + '].[dbo].[SP_INS_USER]
                        @uid = ' + ISNULL(CAST(@uid AS NVARCHAR(10)), 'NULL') + ',
                        @pin = ' + CAST(@pin AS NVARCHAR(10)) + ',
                        @cardno = ' + ISNULL('''' + REPLACE(@Card, '''', '''''') + '''', 'NULL') + ',
                        @password = ''' + REPLACE(@password, '''', '''''') + ''',
                        @group = ' + CAST(@group AS NVARCHAR(10)) + ',
                        @starttime = ' + CAST(@starttime AS NVARCHAR(10)) + ',
                        @endtime = ' + CAST(@endtime AS NVARCHAR(10)) + ',
                        @name = ''' + REPLACE(@name, '''', '''''') + ''',
                        @privilege = ' + ISNULL(CAST(@privilege AS NVARCHAR(10)), 'NULL') + ',
                        @disable = ' + CAST(@disable AS NVARCHAR(1)) + ',
                        @verify = ' + CAST(@verify AS NVARCHAR(1)) + ',
                        @equipo = ''' + REPLACE(@serieActual, '''', '''''') + '''';
                    
                    EXEC(@sqlCommand);
                END
                ELSE IF @tipoEquipo = 'att'
                BEGIN
                    SET @sqlCommand = 'EXEC [' + @LinkedServer + '].[' + @DatabaseName + '].[dbo].[SP_INS_USER_ASISTENCIA]
                        @pin = ' + CAST(@pin AS NVARCHAR(10)) + ',
                        @name = ''' + REPLACE(@name, '''', '''''') + ''',
                        @pri = ' + ISNULL(CAST(@privilege AS NVARCHAR(10)), 'NULL') + ',
                        @passwd = ''' + REPLACE(@password, '''', '''''') + ''',
                        @card = ' + ISNULL('''' + REPLACE(@Card, '''', '''''') + '''', 'NULL') + ',
                        @grp = ' + CAST(@group AS NVARCHAR(10)) + ',
                        @tz = ' + ISNULL('''' + REPLACE(@tz, '''', '''''') + '''', 'NULL') + ',
                        @verify = ' + CAST(@verify AS NVARCHAR(1)) + ',
                        @vicecard = ' + ISNULL(CAST(@vicecard AS NVARCHAR(10)), 'NULL') + ',
                        @startdatetime = ' + CAST(@starttime AS NVARCHAR(10)) + ',
                        @enddatetime = ' + CAST(@endtime AS NVARCHAR(10)) + ',
                        @equipo = ''' + REPLACE(@serieActual, '''', '''''') + '''';
                    
                    EXEC(@sqlCommand);
                END
                ELSE
                BEGIN
                    PRINT 'El tipo de equipo no es válido para la serie: ' + @serieActual;
                END

                -- 3. Ejecutar los procedimientos adicionales en el servidor remoto
                SET @sqlCommand = 'EXEC [' + @LinkedServer + '].[' + @DatabaseName + '].[dbo].[SP_INS_USUARIO_EQUIPO]
                    @EQUIPO = ''' + REPLACE(@serieActual, '''', '''''') + ''',
                    @RUT_PER = ' + CAST(@pin AS NVARCHAR(10));
                EXEC(@sqlCommand);

                SET @sqlCommand = 'EXEC [' + @LinkedServer + '].[' + @DatabaseName + '].[dbo].[SP_INS_BIOPHOTO_EQUIPO]
                    @EQUIPO = ''' + REPLACE(@serieActual, '''', '''''') + ''',
                    @RUT_PER = ' + CAST(@pin AS NVARCHAR(10));
                EXEC(@sqlCommand);

                SET @sqlCommand = 'EXEC [' + @LinkedServer + '].[' + @DatabaseName + '].[dbo].[SP_INS_HUELLA_EQUIPO]
                    @EQUIPO = ''' + REPLACE(@serieActual, '''', '''''') + ''',
                    @RUT_PER = ' + CAST(@pin AS NVARCHAR(10));
                EXEC(@sqlCommand);
            END

            FETCH NEXT FROM seriesCursor INTO @serieActual;
        END;

        CLOSE seriesCursor;
        DEALLOCATE seriesCursor;
    END TRY
    BEGIN CATCH
		IF @ErrorMessage IS NOT NULL
		BEGIN
			THROW 50001, @ErrorMessage, 1;
		END
		ELSE
		BEGIN
			THROW;
		END
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_APPLICATION_LOGS]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_SEL_APPLICATION_LOGS]
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @Email NVARCHAR(255) = NULL
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_SEL_APPLICATION_LOGS
    --  Descripción: Obtiene todos los registros de la tabla 
    --               ApplicationLog.
    --
    --  Parámetros de entrada:
    --		@InitDate DATE - Fecha de inicio para filtrar los registros
    --		@EndDate DATE - Fecha de fin para filtrar los registros
    --		@Email NVARCHAR(255) - Email del usuario para filtrar los registros
    --
    --  Retorna:
    --    - LogId, Email, StartDate, EndDate, ProcessName, 
    --      Parameters, ResponseData.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creación: 
    --    - 13-03-2025
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;

    -- Consulta con validación de fechas y parámetros
    SELECT 
        u.Email,
        al.StartDate,
        al.EndDate,
        al.ProcessName,
        al.Parameters,
        al.ResponseData
    FROM ApplicationLog al
    JOIN [User] u ON u.UserId = al.UserId
    WHERE 
        (@StartDate IS NULL OR CONVERT(DATE, al.StartDate, 23) >= @StartDate)  -- Usamos CONVERT con estilo 23
        AND (@EndDate IS NULL OR CONVERT(DATE, al.StartDate, 23) <= @EndDate) -- Usamos CONVERT con estilo 23
        AND (@Email IS NULL OR u.Email LIKE '%' + @Email + '%') 
    ORDER BY al.LogId DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_COMPANY_INFO]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_SEL_COMPANY_INFO]
	@CompanyRut INT = NULL,
	@CompanyName NVARCHAR(255) = NULL
AS
BEGIN
	/*---------------------------------------------------------------
	--  Procedimiento almacenado: SP_SEL_COMPANY_INFO
	--  Descripción: Consulta información de empresas/clientes filtrando por RUT y/o nombre.
	--
	--  Parámetros de entrada:
	--    @CompanyRut (INT) - RUT de la empresa a buscar (opcional).
	--    @CompanyName (NVARCHAR 255) - Nombre o parte del nombre de la empresa (opcional).
	--
	--  Retorna:
	--    Resultset con las columnas: id, servidor, bd_genhoras, nombre_empresa, 
	--    rut_empresa, dv, tipo_cliente, URL_Chente
	--
	--  Creado por: 
	--    - [Tu nombre aquí]
	--  Fecha Creación: 
	--    - [Fecha actual]
	---------------------------------------------------------------*/
   
	SET NOCOUNT ON;

	IF @CompanyRut = 0
	BEGIN
		SET @CompanyRut = NULL
	END
   
	DECLARE @Error_Message NVARCHAR(4000);

	BEGIN TRY
		SELECT 
			id,
			servidor,
			bd_genhoras,
			nombre_empresa,
			rut_empresa,
			dv,
			tipo_cliente,
			URL_Chente
		FROM 
			[DEV_PORTALGEN].[dbo].[Cliente_Empresa]
		WHERE 
			(@CompanyRut IS NULL OR rut_empresa = @CompanyRut)
			AND 
			(@CompanyName IS NULL OR @CompanyName = '' OR nombre_empresa LIKE '%' + @CompanyName + '%')
		ORDER BY 
			rut_empresa;
	END TRY
	BEGIN CATCH
		SET @Error_Message = ERROR_MESSAGE();
       
		IF @Error_Message IS NOT NULL
			THROW 50001, @Error_Message, 1;
		ELSE
			THROW;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_EMPRESAS_ZK]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_SEL_EMPRESAS_ZK]
    @ServerId INT = NULL,
    @CompanyName NVARCHAR(255) = NULL,
    @IsActive BIT = NULL
AS
BEGIN
    BEGIN TRY
        DECLARE @ErrorMessage NVARCHAR(1000) = NULL;
        DECLARE @DatabaseName NVARCHAR(100) = 'ZK_Att_Acc';
        DECLARE @sqlCommand NVARCHAR(MAX);

        -- Validación de ServerId al inicio
        IF @ServerId IS NULL OR @ServerId NOT IN (1, 2, 3)
        BEGIN
            SET @ErrorMessage = 'Debe indicar un ServerId válido (1, 2 o 3).';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Construcción de la consulta base
        SET @sqlCommand = N'SELECT 
                           EmpresaID, 
                           EmpresaCliente, 
                           EmpresaNombreBD, 
                           EmpresaFechaIngreso, 
                           Activo, 
                           1 AS ServerId 
                           FROM [' + @DatabaseName + '].[dbo].[Empresa] 
                           WHERE 1 = 1 ';

        -- Filtro por nombre de compañía
        IF @CompanyName IS NOT NULL
            SET @sqlCommand = @sqlCommand + N'AND EmpresaCliente LIKE ''%' + @CompanyName + '%'' ';

        -- Filtro por estado activo
        IF @IsActive IS NOT NULL
            SET @sqlCommand = @sqlCommand + N'AND Activo = ' + CAST(@IsActive AS NVARCHAR(1)) + ' ';

        -- Ordenamiento
        SET @sqlCommand = @sqlCommand + N'ORDER BY EmpresaID;';
    
        -- Ejecución según ServerId
        IF @ServerId = 1
            EXEC('SELECT * FROM OPENQUERY(BD1_LINKED, ''' + @sqlCommand + ''')');
        ELSE IF @ServerId = 2
            EXEC('SELECT * FROM OPENQUERY(BD2_LINKED, ''' + @sqlCommand + ''')');
        ELSE IF @ServerId = 3
            EXEC('SELECT * FROM OPENQUERY(BD3_LINKED, ''' + @sqlCommand + ''')');

        -- Depuración (opcional)
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
/****** Object:  StoredProcedure [dbo].[SP_SEL_GRANT_IDS_BY_PROFILE]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE [dbo].[SP_SEL_GRANT_IDS_BY_PROFILE]
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

    -- Selección de los GrantId para el ProfileId proporcionado
    SELECT GrantId
    FROM [ProfileGrant]
    WHERE ProfileId = @ProfileId;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_GRANTS]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE [dbo].[SP_SEL_GRANTS]
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

    -- Selección de los GrantId para el ProfileId proporcionado
    SELECT GrantId, [Name], [Description]
    FROM [Grant];
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_PASSWORD_BY_EMAIL]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE [dbo].[SP_SEL_PASSWORD_BY_EMAIL]
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
/****** Object:  StoredProcedure [dbo].[SP_SEL_PROFILE_BY_ID]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Crear el procedimiento almacenado para obtener todos los perfiles
CREATE PROCEDURE [dbo].[SP_SEL_PROFILE_BY_ID]
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
/****** Object:  StoredProcedure [dbo].[SP_SEL_PROFILES]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Crear el procedimiento almacenado para obtener todos los perfiles
CREATE PROCEDURE [dbo].[SP_SEL_PROFILES]
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_SEL_PROFILE
    --  Descripción: Obtiene todos los registros de la tabla [Profile]
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
    ORDER BY 
        ProfileId;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_SEL_USER_BY_EMAIL]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE [dbo].[SP_SEL_USER_BY_EMAIL]
    @Email NVARCHAR(255)
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_SEL_USER_BY_EMAIL
    --  Descripción: Obtiene los detalles de un usuario basado en su
    --               correo electrónico.
    --
    --  Parámetros de entrada:
    --    @Email (NVARCHAR 255) - Correo del usuario.
    --
    --  Retorna:
    --    - UserId, Name, Email, ProfileId, IsActive si el usuario 
    --      existe y está activo.
    --    - No retorna nada si el usuario no existe o está inactivo.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creación: 
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
/****** Object:  StoredProcedure [dbo].[SP_SEL_USERS]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE [dbo].[SP_SEL_USERS]
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
/****** Object:  StoredProcedure [dbo].[SP_SEL_USERS_DETAILS]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Crear el procedimiento almacenado con parámetros de filtro
CREATE PROCEDURE [dbo].[SP_SEL_USERS_DETAILS]
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
/****** Object:  StoredProcedure [dbo].[SP_SEL_ZK_DEVICES]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SEL_ZK_DEVICES]
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
                         'FROM [' + @Bd + '].[dbo].[EquipoEmpresa] ee ' + 
                         'LEFT JOIN [ZK_Att_Acc].[dbo].[EquipoGenHoras] eg ON ee.Equipo = eg.Equipo ' + 
                         'LEFT JOIN [ZK_Att_Acc].[dbo].[Empresa] e ON eg.EmpresaID = e.EmpresaID ' + 
                         'WHERE 1 = 1 ';

        IF @CompanyId IS NOT NULL
            SET @sqlCommand = @sqlCommand + N'AND e.EmpresaID = ' + CAST(@CompanyId AS NVARCHAR(10)) + ' ';

        IF @SerialNumber IS NOT NULL
			SET @sqlCommand = @sqlCommand + N'AND ee.Equipo LIKE ''''''%' + @SerialNumber + '%'''''' ';


        IF @StartDate IS NOT NULL AND @EndDate IS NOT NULL AND (@EndDate IS NULL AND @StartDate IS NULL)
            SET @sqlCommand = @sqlCommand + 
                N'AND CAST(ee.FechaConexion AS DATE) BETWEEN ''''' + CONVERT(NVARCHAR(10), @StartDate, 120) +
				''''' AND ''''' + CONVERT(NVARCHAR(10), DATEADD(DAY, 1, @EndDate), 120) + ''''' ';

        SET @sqlCommand = @sqlCommand + N'ORDER BY e.EmpresaID, ee.FechaConexion;';

        IF @ServerId = 1
		BEGIN
            EXEC('SELECT * FROM OPENQUERY(BD1_LINKED, ''' + @sqlCommand + ''')');
		END
        ELSE IF @ServerId = 2
		BEGIN
            EXEC('SELECT * FROM OPENQUERY(BD1_LINKED, ''' + @sqlCommand + ''')');
		END
        ELSE IF @ServerId = 3
		BEGIN
            EXEC('SELECT * FROM OPENQUERY(BD3_LINKED, ''' + @sqlCommand + ''')');
		END
		ELSE
		BEGIN
			SET @ErrorMessage = 'Debe indicar un ServerId valido.';
            THROW 50001, @ErrorMessage, 1;
		END

    END TRY
    BEGIN CATCH
        SET @ErrorMessage = ERROR_MESSAGE();
        THROW 50001, @ErrorMessage, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_UPD_PROFILE]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_UPD_PROFILE]
    @ProfileId INT,
    @Name NVARCHAR(255) = NULL,
    @GrantsList NVARCHAR(MAX) = NULL,
    @UpdatedBy INT
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_UPD_PROFILE
    --  Descripción: 
    --    Actualiza un perfil existente y sus grants asociados
    --    Ignora silenciosamente los grants que no existen
    ---------------------------------------------------------------*/
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(1000);
    DECLARE @ValidGrantsCount INT;

    BEGIN TRY
        -- Verificar si el perfil existe
        IF NOT EXISTS (SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId)
        BEGIN
            SET @ErrorMessage = 'El perfil no existe.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Verificar nombre duplicado (solo si se proporciona nuevo nombre)
        IF @Name IS NOT NULL AND EXISTS (
            SELECT 1 FROM [Profile] 
            WHERE [Name] = @Name AND ProfileId <> @ProfileId
        )
        BEGIN
            SET @ErrorMessage = 'El nombre del perfil ya está registrado.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Iniciar transacción
        BEGIN TRANSACTION;

            -- Actualizar nombre del perfil (si se proporciona)
            IF @Name IS NOT NULL
            BEGIN
                UPDATE [Profile]
                SET [Name] = @Name,
                    [UpdatedBy] = @UpdatedBy,
                    [UpdatedAt] = GETDATE()
                WHERE ProfileId = @ProfileId;
            END

            -- Procesar lista de grants (si se proporciona)
            IF @GrantsList IS NOT NULL
            BEGIN
                -- Crear tabla temporal para grants válidos
                CREATE TABLE #ValidGrants (
                    GrantId INT PRIMARY KEY
                );

                -- Insertar solo grants válidos (que existen en la tabla [Grant])
                INSERT INTO #ValidGrants (GrantId)
                SELECT DISTINCT CAST(Value AS INT)
                FROM STRING_SPLIT(@GrantsList, ',')
                WHERE ISNUMERIC(Value) = 1
                AND CAST(Value AS INT) IN (SELECT GrantId FROM [Grant]);

                -- Contar grants válidos
                SET @ValidGrantsCount = (SELECT COUNT(*) FROM #ValidGrants);

                -- Solo procesar si hay grants válidos
                IF @ValidGrantsCount > 0
                BEGIN
                    -- Eliminar grants que no están en la nueva lista
                    DELETE FROM ProfileGrant 
                    WHERE ProfileId = @ProfileId
                    AND GrantId NOT IN (SELECT GrantId FROM #ValidGrants);
                    
                    -- Insertar nuevos grants (que no estaban previamente)
                    INSERT INTO ProfileGrant (ProfileId, GrantId)
                    SELECT @ProfileId, GrantId
                    FROM #ValidGrants
                    WHERE GrantId NOT IN (
                        SELECT GrantId FROM ProfileGrant WHERE ProfileId = @ProfileId
                    );
                END

                -- Eliminar tabla temporal
                DROP TABLE #ValidGrants;
            END

        COMMIT TRANSACTION;

        -- Devolver éxito
        SELECT 1 AS Success;

    END TRY
    BEGIN CATCH
        -- Revertir transacción si está activa
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Limpiar tabla temporal si existe
        IF OBJECT_ID('tempdb..#ValidGrants') IS NOT NULL
            DROP TABLE #ValidGrants;

        -- Manejo de errores
        SET @ErrorMessage = ERROR_MESSAGE();
        
        IF ERROR_NUMBER() = 50001
            THROW;
        ELSE
            THROW 50001, @ErrorMessage, 1;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_UPD_USER]    Script Date: 02-04-2025 17:39:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Crear el procedimiento almacenado
CREATE PROCEDURE [dbo].[SP_UPD_USER]
    @UserId INT,
    @Name NVARCHAR(255) = NULL,
    @Email NVARCHAR(255) = NULL,
    @Password NVARCHAR(255) = NULL,
    @ProfileId INT = NULL,
    @IsActive BIT = NULL,
    @UpdatedBy INT
AS
BEGIN
    /*---------------------------------------------------------------
    --  Procedimiento almacenado: SP_UPD_USER
    --  Descripción: Actualiza un usuario en la tabla [User] solo con los valores enviados.
    --
    --  Parámetros de entrada:
    --    @UserId (INT) - Id del usuario a actualizar.
    --    @Name (NVARCHAR 255) - Nuevo nombre del usuario (Opcional).
    --    @Email (NVARCHAR 255) - Nuevo correo electrónico del usuario (Opcional).
    --    @Password (NVARCHAR 255) - Nueva contraseña cifrada del usuario (Opcional).
    --    @ProfileId (INT) - Nuevo Id del perfil del usuario (Opcional).
    --    @IsActive (BIT) - Nuevo estado del usuario (Opcional).
    --    @UpdatedBy (INT) - Usuario que está actualizando al usuario.
    --
    --  Retorna:
    --    - Todos los datos del usuario actualizado.
    --    - Lanza un error si la actualización falla, con el mensaje correspondiente.
    --
    --  Creado por: 
    --    - Matias Castro
    --  Fecha Creación: 
    --    - 17-03-2025
    ---------------------------------------------------------------*/

    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(1000);

    BEGIN TRY
        -- Verificar si el usuario existe
        IF NOT EXISTS (SELECT 1 FROM [User] WHERE UserId = @UserId)
        BEGIN
            SET @ErrorMessage = 'El usuario no existe.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Verificar si el correo electrónico ya está registrado (en otro usuario)
        IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM [User] WHERE Email = @Email AND UserId <> @UserId)
        BEGIN
            SET @ErrorMessage = 'El correo electrónico ya está registrado en otro usuario.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Verificar si el perfil especificado existe
        IF @ProfileId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM [Profile] WHERE ProfileId = @ProfileId)
        BEGIN
            SET @ErrorMessage = 'El perfil especificado no existe.';
            THROW 50001, @ErrorMessage, 1;
        END

        -- Actualizar solo los valores enviados
        UPDATE [User]
        SET 
            Name = COALESCE(@Name, Name), 
            Email = COALESCE(@Email, Email), 
            PasswordHash = COALESCE(@Password, PasswordHash), 
            ProfileId = COALESCE(@ProfileId, ProfileId),
            IsActive = COALESCE(@IsActive, IsActive),
            UpdatedBy = @UpdatedBy,
            UpdatedAt = GETDATE()
        WHERE UserId = @UserId;

        -- Retornar todos los datos del usuario actualizado
        SELECT UserId, Name, Email, PasswordHash, ProfileId, IsActive
        FROM [User]
        WHERE UserId = @UserId;
    END TRY
    BEGIN CATCH
        SET @ErrorMessage = ERROR_MESSAGE();
        THROW 50001, @ErrorMessage, 1;
    END CATCH
END;
GO
