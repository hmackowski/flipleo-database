-- Adds an optional image link to FlipRecord (a URL to a photo of the item).
-- Safe to run on existing data: the column is nullable.

USE FlipLeo;
GO

IF COL_LENGTH('dbo.FlipRecord', 'ImageUrl') IS NULL
BEGIN
    ALTER TABLE [dbo].[FlipRecord]
        ADD [ImageUrl] VARCHAR(1000) NULL;
END
GO
