-- Add-on presets: drops and recreates dbo.FlipRecordAddOn (adds AddOnPresetId, ImageUrl) and creates
-- dbo.AddOnPreset (per-user reusable add-ons with Link + ImageUrl).
-- WARNING: existing flip add-ons and presets are deleted (flips themselves are kept; their Parts become $0).
-- Safe to re-run.

USE FlipLeo;
GO

DROP TABLE IF EXISTS [dbo].[FlipRecordAddOn];   -- child first (references AddOnPreset)
DROP TABLE IF EXISTS [dbo].[AddOnPreset];
GO

CREATE TABLE [dbo].[AddOnPreset]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL, -- owner (UserAccount); presets are per user
    [Name] VARCHAR(200) NOT NULL,
    [DefaultPrice] DECIMAL(10,2) NOT NULL,
    [Link] VARCHAR(1000) NULL,          -- where to buy it
    [ImageUrl] VARCHAR(1000) NULL,      -- picture of the part
    [IsActive] BIT NOT NULL CONSTRAINT [DF_AddOnPreset_IsActive] DEFAULT (1),

    [CreatedBy] UNIQUEIDENTIFIER NULL,
    [CreatedByUsername] VARCHAR(255) NOT NULL,
    [CreatedDate] DATETIME NOT NULL CONSTRAINT [DF_AddOnPreset_CreatedDate] DEFAULT (GETDATE()),
    [UpdatedBy] UNIQUEIDENTIFIER NULL,
    [UpdatedByUsername] VARCHAR(255) NOT NULL,
    [UpdatedDate] DATETIME NOT NULL CONSTRAINT [DF_AddOnPreset_UpdatedDate] DEFAULT (GETDATE()),

    CONSTRAINT [PK_AddOnPreset] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [FK_AddOnPreset_UserAccount]
        FOREIGN KEY ([UserId]) REFERENCES [dbo].[UserAccount]([Id])
);

GO

CREATE NONCLUSTERED INDEX [IX_AddOnPreset_UserId] ON [dbo].[AddOnPreset] ([UserId]);

GO

CREATE TABLE [dbo].[FlipRecordAddOn]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [FlipRecordId] INT NOT NULL,
    [AddOnPresetId] INT NULL,
    [Name] VARCHAR(200) NOT NULL,
    [Price] DECIMAL(10,2) NOT NULL,
    [Link] VARCHAR(1000) NULL,
    [ImageUrl] VARCHAR(1000) NULL,
    [IsActive] BIT NOT NULL CONSTRAINT [DF_FlipRecordAddOn_IsActive] DEFAULT (1),

    [CreatedBy] UNIQUEIDENTIFIER NULL,
    [CreatedByUsername] VARCHAR(255) NOT NULL,
    [CreatedDate] DATETIME NOT NULL CONSTRAINT [DF_FlipRecordAddOn_CreatedDate] DEFAULT (GETDATE()),
    [UpdatedBy] UNIQUEIDENTIFIER NULL,
    [UpdatedByUsername] VARCHAR(255) NOT NULL,
    [UpdatedDate] DATETIME NOT NULL CONSTRAINT [DF_FlipRecordAddOn_UpdatedDate] DEFAULT (GETDATE()),

    CONSTRAINT [PK_FlipRecordAddOn] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [FK_FlipRecordAddOn_FlipRecord]
        FOREIGN KEY ([FlipRecordId]) REFERENCES [dbo].[FlipRecord]([Id]),
    CONSTRAINT [FK_FlipRecordAddOn_AddOnPreset]
        FOREIGN KEY ([AddOnPresetId]) REFERENCES [dbo].[AddOnPreset]([Id])
);

GO

CREATE NONCLUSTERED INDEX [IX_FlipRecordAddOn_FlipRecordId] ON [dbo].[FlipRecordAddOn] ([FlipRecordId]);

GO

CREATE NONCLUSTERED INDEX [IX_FlipRecordAddOn_AddOnPresetId] ON [dbo].[FlipRecordAddOn] ([AddOnPresetId]);

GO

SELECT 'AddOnPreset created, FlipRecordAddOn recreated' AS Result;
