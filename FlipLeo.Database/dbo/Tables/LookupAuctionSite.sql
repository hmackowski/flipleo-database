CREATE TABLE [dbo].[LookupAuctionSite]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Name] VARCHAR(50) NOT NULL,
    [WebsiteUrl] VARCHAR(1000) NULL,
    [IsActive] BIT NOT NULL CONSTRAINT [DF_LookupAuctionSite_IsActive] DEFAULT (1),

    CONSTRAINT [PK_LookupAuctionSite] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [UQ_LookupAuctionSite_Name] UNIQUE ([Name])
);
