------------------------------------------------------
-- Adds or updates Auction Sites in the lookup table
-- (runs after every deploy, safe to run repeatedly)
------------------------------------------------------
SET IDENTITY_INSERT [dbo].[LookupAuctionSite] ON;
MERGE [dbo].[LookupAuctionSite] AS [Target]
USING
    (
        SELECT [Id], [Name], [WebsiteUrl]
        FROM (VALUES
            (1, 'eBay', 'https://www.ebay.com'),
            (2, 'Goodwill', 'https://shopgoodwill.com')
        ) AS [Source] ([Id], [Name], [WebsiteUrl])
    ) AS [Seed]
ON ([Target].[Id] = [Seed].[Id])
WHEN MATCHED THEN
    UPDATE SET
        [Target].[Name] = [Seed].[Name],
        [Target].[WebsiteUrl] = [Seed].[WebsiteUrl]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name], [WebsiteUrl])
    VALUES ([Seed].[Id], [Seed].[Name], [Seed].[WebsiteUrl]);

GO

SET IDENTITY_INSERT [dbo].[LookupAuctionSite] OFF;
GO
