-- 1) Flip status: adds dbo.LookupFlipStatus (Bought / Listed / Sold), FlipRecord.FlipStatusId + SoldDate,
--    and makes FlipRecord.SellPrice nullable (unsold items don't have one yet).
--    Existing flips all had a sell price, so they're marked Sold with SoldDate = FlipDate.
-- 2) Password reset: adds dbo.UserAccountToken.
-- Safe to re-run.

USE FlipLeo;
GO

-- ---------- LookupFlipStatus ----------
IF OBJECT_ID('dbo.LookupFlipStatus', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[LookupFlipStatus]
    (
        [Id] INT IDENTITY(1,1) NOT NULL,
        [Name] VARCHAR(50) NOT NULL,
        [SortOrder] INT NOT NULL,
        [IsActive] BIT NOT NULL CONSTRAINT [DF_LookupFlipStatus_IsActive] DEFAULT (1),

        CONSTRAINT [PK_LookupFlipStatus] PRIMARY KEY CLUSTERED ([Id]),
        CONSTRAINT [UQ_LookupFlipStatus_Name] UNIQUE ([Name])
    );
    PRINT 'dbo.LookupFlipStatus created.';
END
GO

-- Same seed as PostDeployment\Populate_LookupFlipStatus.sql
SET IDENTITY_INSERT [dbo].[LookupFlipStatus] ON;
MERGE [dbo].[LookupFlipStatus] AS [Target]
USING (VALUES (1, 'Bought', 1), (2, 'Listed', 2), (3, 'Sold', 3)) AS [Seed] ([Id], [Name], [SortOrder])
ON ([Target].[Id] = [Seed].[Id])
WHEN MATCHED THEN UPDATE SET [Target].[Name] = [Seed].[Name], [Target].[SortOrder] = [Seed].[SortOrder]
WHEN NOT MATCHED BY TARGET THEN INSERT ([Id], [Name], [SortOrder]) VALUES ([Seed].[Id], [Seed].[Name], [Seed].[SortOrder]);
SET IDENTITY_INSERT [dbo].[LookupFlipStatus] OFF;
GO

-- ---------- FlipRecord changes ----------
IF COL_LENGTH('dbo.FlipRecord', 'FlipStatusId') IS NULL
BEGIN
    -- Default 3 (Sold) fills in the existing rows; switched to 1 (Bought) below for new rows
    ALTER TABLE [dbo].[FlipRecord]
        ADD [FlipStatusId] INT NOT NULL CONSTRAINT [DF_FlipRecord_FlipStatusId] DEFAULT (3);
    PRINT 'dbo.FlipRecord.FlipStatusId added (existing flips = Sold).';
END
GO

IF COL_LENGTH('dbo.FlipRecord', 'SoldDate') IS NULL
BEGIN
    ALTER TABLE [dbo].[FlipRecord] ADD [SoldDate] DATE NULL;
    PRINT 'dbo.FlipRecord.SoldDate added.';
END
GO

-- Existing (sold) flips: sold on their flip date
UPDATE [dbo].[FlipRecord] SET [SoldDate] = [FlipDate] WHERE [FlipStatusId] = 3 AND [SoldDate] IS NULL;
GO

-- New flips default to Bought
IF EXISTS (SELECT 1 FROM sys.default_constraints WHERE [name] = 'DF_FlipRecord_FlipStatusId'
           AND [definition] <> '((1))')
BEGIN
    ALTER TABLE [dbo].[FlipRecord] DROP CONSTRAINT [DF_FlipRecord_FlipStatusId];
    ALTER TABLE [dbo].[FlipRecord] ADD CONSTRAINT [DF_FlipRecord_FlipStatusId] DEFAULT (1) FOR [FlipStatusId];
    PRINT 'DF_FlipRecord_FlipStatusId now defaults to 1 (Bought).';
END
GO

IF OBJECT_ID('dbo.FK_FlipRecord_LookupFlipStatus', 'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[FlipRecord] ADD CONSTRAINT [FK_FlipRecord_LookupFlipStatus]
        FOREIGN KEY ([FlipStatusId]) REFERENCES [dbo].[LookupFlipStatus]([Id]);
    PRINT 'FK_FlipRecord_LookupFlipStatus added.';
END
GO

-- Unsold items don't have a sell price yet
ALTER TABLE [dbo].[FlipRecord] ALTER COLUMN [SellPrice] DECIMAL(10,2) NULL;
GO

-- ---------- UserAccountToken ----------
IF OBJECT_ID('dbo.UserAccountToken', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[UserAccountToken]
    (
        [Id] INT IDENTITY(1,1) NOT NULL,
        [UserAccountId] UNIQUEIDENTIFIER NOT NULL,
        [Purpose] VARCHAR(50) NOT NULL,
        [TokenHash] VARCHAR(64) NOT NULL,
        [ExpiresDate] DATETIME NOT NULL,
        [UsedDate] DATETIME NULL,
        [CreatedDate] DATETIME NOT NULL CONSTRAINT [DF_UserAccountToken_CreatedDate] DEFAULT (GETUTCDATE()),

        CONSTRAINT [PK_UserAccountToken] PRIMARY KEY CLUSTERED ([Id]),
        CONSTRAINT [FK_UserAccountToken_UserAccount]
            FOREIGN KEY ([UserAccountId]) REFERENCES [dbo].[UserAccount]([Id]),
        CONSTRAINT [UQ_UserAccountToken_TokenHash] UNIQUE ([TokenHash])
    );

    CREATE NONCLUSTERED INDEX [IX_UserAccountToken_UserAccountId] ON [dbo].[UserAccountToken] ([UserAccountId]);
    PRINT 'dbo.UserAccountToken created.';
END
GO
