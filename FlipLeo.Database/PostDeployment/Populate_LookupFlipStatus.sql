------------------------------------------------------
-- Adds or updates Flip Statuses in the lookup table
-- (runs after every deploy, safe to run repeatedly)
-- Ids are used by the API (FlipStatusIds), so don't renumber them.
------------------------------------------------------
SET IDENTITY_INSERT [dbo].[LookupFlipStatus] ON;
MERGE [dbo].[LookupFlipStatus] AS [Target]
USING
    (
        SELECT [Id], [Name], [SortOrder]
        FROM (VALUES
            (1, 'Bought', 1),
            (2, 'Listed', 2),
            (3, 'Sold', 3)
        ) AS [Source] ([Id], [Name], [SortOrder])
    ) AS [Seed]
ON ([Target].[Id] = [Seed].[Id])
WHEN MATCHED THEN
    UPDATE SET
        [Target].[Name] = [Seed].[Name],
        [Target].[SortOrder] = [Seed].[SortOrder]
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], [Name], [SortOrder])
    VALUES ([Seed].[Id], [Seed].[Name], [Seed].[SortOrder]);

GO

SET IDENTITY_INSERT [dbo].[LookupFlipStatus] OFF;
GO
