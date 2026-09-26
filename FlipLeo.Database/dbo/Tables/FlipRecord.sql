-- PartsPrice and Profit are calculated by the API, not stored:
--   PartsPrice = SUM(FlipRecordAddOn.Price)
--   Profit     = SellPrice - BuyPrice - PartsPrice
CREATE TABLE [dbo].[FlipRecord]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL, -- owner (UserAccount); add-ons inherit it
    [ItemName] VARCHAR(200) NOT NULL,
    [BuyPrice] DECIMAL(10,2) NOT NULL,
    [SellPrice] DECIMAL(10,2) NOT NULL,
    [FlipDate] DATE NOT NULL,
    [AuctionId] INT NULL, -- optional: the auction the item was bought from
    [IsActive] BIT NOT NULL CONSTRAINT [DF_FlipRecord_IsActive] DEFAULT (1),

    [CreatedBy] UNIQUEIDENTIFIER NULL,
    [CreatedByUsername] VARCHAR(255) NOT NULL,
    [CreatedDate] DATETIME NOT NULL CONSTRAINT [DF_FlipRecord_CreatedDate] DEFAULT (GETDATE()),
    [UpdatedBy] UNIQUEIDENTIFIER NULL,
    [UpdatedByUsername] VARCHAR(255) NOT NULL,
    [UpdatedDate] DATETIME NOT NULL CONSTRAINT [DF_FlipRecord_UpdatedDate] DEFAULT (GETDATE()),

    CONSTRAINT [PK_FlipRecord] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [FK_FlipRecord_UserAccount]
        FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserAccount]([Id]),
    CONSTRAINT [FK_FlipRecord_Auction]
        FOREIGN KEY ([AuctionId]) REFERENCES [dbo].[Auction]([Id])
);

GO

CREATE NONCLUSTERED INDEX [IX_FlipRecord_AuctionId] ON [dbo].[FlipRecord] ([AuctionId]);

GO

CREATE NONCLUSTERED INDEX [IX_FlipRecord_UserId] ON [dbo].[FlipRecord] ([UserId]);
