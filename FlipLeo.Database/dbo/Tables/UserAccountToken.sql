-- One-time tokens emailed to a user (password reset now; email confirmation later).
-- Only a SHA-256 hash of the token is stored, so a database leak can't be used to reset passwords.
CREATE TABLE [dbo].[UserAccountToken]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserAccountId] UNIQUEIDENTIFIER NOT NULL,
    [Purpose] VARCHAR(50) NOT NULL, -- e.g. 'PasswordReset'
    [TokenHash] VARCHAR(64) NOT NULL, -- hex SHA-256 of the token in the emailed link
    [ExpiresDate] DATETIME NOT NULL,
    [UsedDate] DATETIME NULL,
    [CreatedDate] DATETIME NOT NULL CONSTRAINT [DF_UserAccountToken_CreatedDate] DEFAULT (GETUTCDATE()),

    CONSTRAINT [PK_UserAccountToken] PRIMARY KEY CLUSTERED ([Id]),
    CONSTRAINT [FK_UserAccountToken_UserAccount]
        FOREIGN KEY ([UserAccountId]) REFERENCES [dbo].[UserAccount]([Id]),
    CONSTRAINT [UQ_UserAccountToken_TokenHash] UNIQUE ([TokenHash])
);

GO

CREATE NONCLUSTERED INDEX [IX_UserAccountToken_UserAccountId] ON [dbo].[UserAccountToken] ([UserAccountId]);
