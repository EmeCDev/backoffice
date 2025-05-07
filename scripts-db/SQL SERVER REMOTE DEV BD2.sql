USE master;
GO

-- 1. ELIMINAR EL LINKED SERVER SI EXISTE
IF EXISTS (SELECT * FROM sys.servers WHERE name = 'BD2GESTION')
BEGIN
    EXEC sp_dropserver 'BD2GESTION', 'droplogins';
    PRINT 'Linked Server eliminado.';
END
GO


 PRINT 'Creando linked server.';
-- 2. CREAR EL LINKED SERVER
EXEC sp_addlinkedserver 
    @server = 'BD2GESTION',  -- Nombre del Linked Server
    @srvproduct = '',
    @provider = 'SQLNCLI',  -- SQL Native Client
    @datasrc = '192.168.100.199'; -- IP del servidor destino
GO

-- 3. CONFIGURAR LAS CREDENCIALES DE ACCESO
-- Para autenticación SQL Server (usuario y contraseña)
EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'BD2GESTION', 
    @useself = 'FALSE', 
    @rmtuser = 'sa',  -- Usuario de BD 1
    @rmtpassword = 'Admin123.*';
GO

-- Si usas autenticación integrada de Windows, usa este en su lugar:
-- EXEC sp_addlinkedsrvlogin 
--    @rmtsrvname = 'BD1_LINKED', 
--    @useself = 'TRUE';
-- GO

-- 4. HABILITAR OPCIONES DE RPC (Opcional, para ejecución remota)
EXEC sp_serveroption 'BD2GESTION', 'rpc', 'true';
EXEC sp_serveroption 'BD2GESTION', 'rpc out', 'true';
GO


 PRINT 'Linked Server creado.';