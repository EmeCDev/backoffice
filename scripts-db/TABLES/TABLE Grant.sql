USE Backoffice;

DROP TABLE IF EXISTS [Grant];
GO
CREATE TABLE [Grant](
    [GrantId] INT NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(100) NOT NULL UNIQUE,
    [Description] NVARCHAR(255) NULL
);
GO

