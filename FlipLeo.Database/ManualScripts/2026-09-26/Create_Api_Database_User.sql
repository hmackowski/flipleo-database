-- Run ONCE against the Azure SQL "FlipLeo" database (not master), signed in as the server admin,
-- after the first dacpac deploy. Creates the login the API uses: it can read and write data but
-- cannot change the schema or drop tables (the pipeline uses the admin login for schema changes).
--
-- 1) Replace <STRONG-PASSWORD> with a long random password (e.g. from a password manager).
-- 2) Put the matching connection string in Key Vault as secret "FlipLeoConnectionString"
--    (App Service setting ConnectionStrings__FlipLeo references it):
--    Server=tcp:flipleo-sql.database.windows.net,1433;Database=FlipLeo;User ID=flipleo_api;
--    Password=<STRONG-PASSWORD>;Encrypt=True;TrustServerCertificate=False;Connection Timeout=60;
-- Never commit the real password.

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE [name] = 'flipleo_api')
BEGIN
    CREATE USER [flipleo_api] WITH PASSWORD = '<STRONG-PASSWORD>';   -- contained database user
    PRINT 'User flipleo_api created.';
END
GO

ALTER ROLE [db_datareader] ADD MEMBER [flipleo_api];
ALTER ROLE [db_datawriter] ADD MEMBER [flipleo_api];
GO
