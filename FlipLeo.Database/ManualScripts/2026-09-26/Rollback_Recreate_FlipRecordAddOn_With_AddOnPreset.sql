-- Rollback: back to FlipRecordAddOn without AddOnPresetId, and no AddOnPreset table.
-- WARNING: deletes all flip add-ons and presets.

USE FlipLeo;
GO

DROP TABLE IF EXISTS [dbo].[FlipRecordAddOn];
DROP TABLE IF EXISTS [dbo].[AddOnPreset];
GO

CREATE TABLE [dbo].[FlipRecordAddOn]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [FlipRecordId] INT NOT NULL,
    [Name] VARCHAR(200) NOT NULL,
    [Price] DECIMAL(10,2) NOT NULL,
    [Link] VARCHAR(1000) NULL,
    [IsActive] BIT NOT NULL CONSTRAINT [DF_FlipRecordAddOn_IsActive] DEFAULT (1),
    [CreatedBy] UNIQUEIDENTIFIER NULL,
    [CreatedByUsername] VARCHAR(255) NOT NULL,
    [CreatedDate] DATETIME NOT NULL CONSTRAINT [DF_FlipRecordAddOn_CreatedDate] DEFAULT (GETDATE()),
    [UpdatedBy] UNIQUEIDENTIFIER NULL,
    [UpdatedByUsername] VARCHAR(255) NOT NULL,
    [UpdatedDate] DATETIME NOT NULL CONSTRAINT [DF_FlipRecordAddOn_UpdatedDate] DEFAULT (GETDATE()),
    CONSTRAINT [PK_FlipRecordAddOn] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [FK_FlipRecordAddOn_FlipRecord]
        FOREIGN KEY ([FlipRecordId]) REFERENCES [dbo].[FlipRecord]([Id])
);
GO

CREATE NONCLUSTERED INDEX [IX_FlipRecordAddOn_FlipRecordId] ON [dbo].[FlipRecordAddOn] ([FlipRecordId]);
GO
