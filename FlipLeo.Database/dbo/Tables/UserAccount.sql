CREATE TABLE [dbo].[UserAccount]
(
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_UserAccount_Id] DEFAULT (NEWSEQUENTIALID()),
    [Email] VARCHAR(255) NOT NULL,
    [DisplayName] VARCHAR(100) NOT NULL,
    [PasswordHash] VARCHAR(500) NOT NULL, -- salted PBKDF2 hash, never the plain password
    [LastLoginDate] DATETIME NULL,
    [IsActive] BIT NOT NULL CONSTRAINT [DF_UserAccount_IsActive] DEFAULT (1),
    [CreatedDate] DATETIME NOT NULL CONSTRAINT [DF_UserAccount_CreatedDate] DEFAULT (GETUTCDATE()),
    [UpdatedDate] DATETIME NOT NULL CONSTRAINT [DF_UserAccount_UpdatedDate] DEFAULT (GETUTCDATE()),

    CONSTRAINT [PK_UserAccount] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [UQ_UserAccount_Email] UNIQUE ([Email])
);
