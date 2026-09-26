CREATE TABLE [dbo].[LookupFlipStatus]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Name] VARCHAR(50) NOT NULL,
    [SortOrder] INT NOT NULL,
    [IsActive] BIT NOT NULL CONSTRAINT [DF_LookupFlipStatus_IsActive] DEFAULT (1),

    CONSTRAINT [PK_LookupFlipStatus] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [UQ_LookupFlipStatus_Name] UNIQUE ([Name])
);
