-- Rollback for Add_UserAccount_And_Data_Ownership.sql
-- Removes UserId from Auction and FlipRecord, then drops dbo.UserAccount.
-- WARNING: all user accounts are lost. Existing auctions/flips stay but lose their owner.
-- Safe to re-run.

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_FlipRecord_UserId' AND object_id = OBJECT_ID('dbo.FlipRecord'))
    DROP INDEX [IX_FlipRecord_UserId] ON [dbo].[FlipRecord];
IF OBJECT_ID('dbo.FK_FlipRecord_UserAccount', 'F') IS NOT NULL
    ALTER TABLE [dbo].[FlipRecord] DROP CONSTRAINT [FK_FlipRecord_UserAccount];
IF COL_LENGTH('dbo.FlipRecord', 'UserId') IS NOT NULL
    ALTER TABLE [dbo].[FlipRecord] DROP COLUMN [UserId];
PRINT 'dbo.FlipRecord.UserId removed.';
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Auction_UserId' AND object_id = OBJECT_ID('dbo.Auction'))
    DROP INDEX [IX_Auction_UserId] ON [dbo].[Auction];
IF OBJECT_ID('dbo.FK_Auction_UserAccount', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Auction] DROP CONSTRAINT [FK_Auction_UserAccount];
IF COL_LENGTH('dbo.Auction', 'UserId') IS NOT NULL
    ALTER TABLE [dbo].[Auction] DROP COLUMN [UserId];
PRINT 'dbo.Auction.UserId removed.';
GO

IF OBJECT_ID('dbo.UserAccount', 'U') IS NOT NULL
    DROP TABLE [dbo].[UserAccount];
PRINT 'dbo.UserAccount dropped.';
GO
