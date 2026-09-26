-- Rollback: removes FlipRecord.ImageUrl.
-- WARNING: any saved flip image links are lost.

USE FlipLeo;
GO

IF COL_LENGTH('dbo.FlipRecord', 'ImageUrl') IS NOT NULL
BEGIN
    ALTER TABLE [dbo].[FlipRecord]
        DROP COLUMN [ImageUrl];
END
GO
