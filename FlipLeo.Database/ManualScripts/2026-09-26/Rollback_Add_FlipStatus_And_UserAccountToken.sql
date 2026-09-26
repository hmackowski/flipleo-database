-- Rollback: removes flip status + SoldDate, makes SellPrice required again, drops UserAccountToken.
-- WARNING: unsold flips (no sell price) get SellPrice = 0 so the NOT NULL change can succeed.

USE FlipLeo;
GO

DROP TABLE IF EXISTS [dbo].[UserAccountToken];
GO

IF OBJECT_ID('dbo.FK_FlipRecord_LookupFlipStatus', 'F') IS NOT NULL
    ALTER TABLE [dbo].[FlipRecord] DROP CONSTRAINT [FK_FlipRecord_LookupFlipStatus];
IF OBJECT_ID('dbo.DF_FlipRecord_FlipStatusId', 'D') IS NOT NULL
    ALTER TABLE [dbo].[FlipRecord] DROP CONSTRAINT [DF_FlipRecord_FlipStatusId];
GO

IF COL_LENGTH('dbo.FlipRecord', 'FlipStatusId') IS NOT NULL
    ALTER TABLE [dbo].[FlipRecord] DROP COLUMN [FlipStatusId];
IF COL_LENGTH('dbo.FlipRecord', 'SoldDate') IS NOT NULL
    ALTER TABLE [dbo].[FlipRecord] DROP COLUMN [SoldDate];
GO

UPDATE [dbo].[FlipRecord] SET [SellPrice] = 0 WHERE [SellPrice] IS NULL;
ALTER TABLE [dbo].[FlipRecord] ALTER COLUMN [SellPrice] DECIMAL(10,2) NOT NULL;
GO

DROP TABLE IF EXISTS [dbo].[LookupFlipStatus];
GO
