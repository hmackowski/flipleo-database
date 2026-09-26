-- PartsPrice and Profit are calculated by the API, not stored:
--   PartsPrice = SUM(FlipRecordAddOn.Price)
--   Profit     = SellPrice - BuyPrice - PartsPrice (only once the flip is Sold)
CREATE TABLE [dbo].[FlipRecord]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL, -- owner (UserAccount); add-ons inherit it
    [ItemName] VARCHAR(200) NOT NULL,
    [ImageUrl] VARCHAR(1000) NULL, -- optional link to a photo of the item
    [BuyPrice] DECIMAL(10,2) NOT NULL,
    [SellPrice] DECIMAL(10,2) NULL, -- required once Sold (checked by the API)
    [FlipDate] DATE NOT NULL, -- the date the item was bought
    [FlipStatusId] INT NOT NULL CONSTRAINT [DF_FlipRecord_FlipStatusId] DEFAULT (1), -- LookupFlipStatus (1 = Bought)
    [SoldDate] DATE NULL,
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
        FOREIGN KEY ([AuctionId]) REFERENCES [dbo].[Auction]([Id]),
    CONSTRAINT [FK_FlipRecord_LookupFlipStatus]
        FOREIGN KEY ([FlipStatusId]) REFERENCES [dbo].[LookupFlipStatus]([Id])
);

GO

CREATE NONCLUSTERED INDEX [IX_FlipRecord_AuctionId] ON [dbo].[FlipRecord] ([AuctionId]);

GO

CREATE NONCLUSTERED INDEX [IX_FlipRecord_UserId] ON [dbo].[FlipRecord] ([UserId]);
