-- A user's reusable add-on (e.g. "TMR Joysticks", $12). Shown as quick buttons when logging a flip.
-- Clicking one COPIES name/price/link onto the flip's FlipRecordAddOn, so editing a preset later
-- never changes the cost history of past flips.
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
