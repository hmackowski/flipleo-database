-- Rollback: removes the API's database user (the API can no longer connect until a new one is created).
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE [name] = 'flipleo_api')
    DROP USER [flipleo_api];
GO
