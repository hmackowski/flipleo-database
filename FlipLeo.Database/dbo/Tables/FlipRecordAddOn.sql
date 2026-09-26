-- Parts / add-ons actually put into a flip. Owned through the parent FlipRecord.
-- AddOnPresetId is set when the add-on was created from one of the user's presets (optional).
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
