-- User accounts + per-user data: creates dbo.UserAccount and adds an owner column
-- (UserId) to Auction and FlipRecord. FlipRecordAddOn is owned through its FlipRecord.
-- Deletes existing auctions/flips/add-ons first (they were test data with no owner),
-- because UserId is NOT NULL. Safe to re-run.

IF OBJECT_ID('dbo.UserAccount', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[UserAccount]
    (
        [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_UserAccount_Id] DEFAULT (NEWSEQUENTIALID()),
        [Email] VARCHAR(255) NOT NULL,
        [DisplayName] VARCHAR(100) NOT NULL,
        [PasswordHash] VARCHAR(500) NOT NULL,
        [LastLoginDate] DATETIME NULL,
        [IsActive] BIT NOT NULL CONSTRAINT [DF_UserAccount_IsActive] DEFAULT (1),
        [CreatedDate] DATETIME NOT NULL CONSTRAINT [DF_UserAccount_CreatedDate] DEFAULT (GETUTCDATE()),
        [UpdatedDate] DATETIME NOT NULL CONSTRAINT [DF_UserAccount_UpdatedDate] DEFAULT (GETUTCDATE()),

        CONSTRAINT [PK_UserAccount] PRIMARY KEY CLUSTERED ([Id]),
        CONSTRAINT [UQ_UserAccount_Email] UNIQUE ([Email])
    );

    PRINT 'dbo.UserAccount created.';
END
ELSE
    PRINT 'dbo.UserAccount already exists.';
GO

-- Auction.UserId
IF COL_LENGTH('dbo.Auction', 'UserId') IS NULL
BEGIN
    DELETE FROM [dbo].[FlipRecordAddOn];
    DELETE FROM [dbo].[FlipRecord];
    DELETE FROM [dbo].[Auction];
    PRINT 'Existing test auctions/flips/add-ons deleted.';

    ALTER TABLE [dbo].[Auction] ADD [UserId] UNIQUEIDENTIFIER NOT NULL;
    PRINT 'dbo.Auction.UserId added.';
END
ELSE
    PRINT 'dbo.Auction.UserId already exists.';
GO

IF OBJECT_ID('dbo.FK_Auction_UserAccount', 'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[Auction] ADD CONSTRAINT [FK_Auction_UserAccount]
        FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserAccount]([Id]);
    PRINT 'FK_Auction_UserAccount added.';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Auction_UserId' AND object_id = OBJECT_ID('dbo.Auction'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_Auction_UserId] ON [dbo].[Auction] ([UserId]);
    PRINT 'IX_Auction_UserId added.';
END
GO

-- FlipRecord.UserId
IF COL_LENGTH('dbo.FlipRecord', 'UserId') IS NULL
BEGIN
    DELETE FROM [dbo].[FlipRecordAddOn];
    DELETE FROM [dbo].[FlipRecord];

    ALTER TABLE [dbo].[FlipRecord] ADD [UserId] UNIQUEIDENTIFIER NOT NULL;
    PRINT 'dbo.FlipRecord.UserId added.';
END
ELSE
    PRINT 'dbo.FlipRecord.UserId already exists.';
GO

IF OBJECT_ID('dbo.FK_FlipRecord_UserAccount', 'F') IS NULL
BEGIN
    ALTER TABLE [dbo].[FlipRecord] ADD CONSTRAINT [FK_FlipRecord_UserAccount]
        FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserAccount]([Id]);
    PRINT 'FK_FlipRecord_UserAccount added.';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FlipRecord_UserId' AND object_id = OBJECT_ID('dbo.FlipRecord'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_FlipRecord_UserId] ON [dbo].[FlipRecord] ([UserId]);
    PRINT 'IX_FlipRecord_UserId added.';
END
GO
