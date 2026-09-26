CREATE TABLE [dbo].[Auction]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL, -- owner (UserAccount)
    [Name] VARCHAR(200) NOT NULL,
    [AuctionSiteId] INT NOT NULL,
    [Link] VARCHAR(1000) NOT NULL,
    [ImageUrl] VARCHAR(1000) NULL,
    [CurrentPrice] DECIMAL(10,2) NOT NULL,
    [StartTime] DATETIME NOT NULL,
    [EndTime] DATETIME NOT NULL,
    [Notes] VARCHAR(1000) NULL,
    [IsActive] BIT NOT NULL CONSTRAINT [DF_Auction_IsActive] DEFAULT (1),

    [CreatedBy] UNIQUEIDENTIFIER NULL,
    [CreatedByUsername] VARCHAR(255) NOT NULL,
    [CreatedDate] DATETIME NOT NULL CONSTRAINT [DF_Auction_CreatedDate] DEFAULT (GETDATE()),
    [UpdatedBy] UNIQUEIDENTIFIER NULL,
    [UpdatedByUsername] VARCHAR(255) NOT NULL,
    [UpdatedDate] DATETIME NOT NULL CONSTRAINT [DF_Auction_UpdatedDate] DEFAULT (GETDATE()),

    CONSTRAINT [PK_Auction] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [FK_Auction_UserAccount]
        FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserAccount]([Id]),
    CONSTRAINT [FK_Auction_LookupAuctionSite]
        FOREIGN KEY ([AuctionSiteId]) REFERENCES [dbo].[LookupAuctionSite]([Id]),
    CONSTRAINT [CK_Auction_EndTime] CHECK ([EndTime] >= [StartTime])
);

GO

CREATE NONCLUSTERED INDEX [IX_Auction_AuctionSiteId] ON [dbo].[Auction] ([AuctionSiteId]);

GO

CREATE NONCLUSTERED INDEX [IX_Auction_UserId] ON [dbo].[Auction] ([UserId]);
