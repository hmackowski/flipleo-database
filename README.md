# FlipLeo.Database

SQL Server schema for [Flipleo](https://flipleo.com), a profit tracker for resellers: people who buy items (often at online auctions), fix or upgrade them, and resell them. The database stores each user's tracked auctions, flips, add-ons and saved add-on presets.

It's used by the [Flipleo API](../flipleo.API). The project is set up the same way as `Pivotal.Database` (SDK-style `.sqlproj`, `Microsoft.Build.Sql`).

## Layout

| Path | What it is |
|---|---|
| `FlipLeo.Database/dbo/Tables/` | One `CREATE TABLE` per file. **The source of truth for the schema.** |
| `FlipLeo.Database/Script.PostDeployment.sql` | Runs after every publish. Pulls in seed scripts with `:r`. |
| `FlipLeo.Database/PostDeployment/` | Seed / lookup data (`MERGE`, safe to re-run). |
| `FlipLeo.Database/ManualScripts/yyyy-MM-dd/` | One-off change scripts for an existing database, each with a `Rollback_` script. Run by hand in SSMS. |

## Tables

| Table | Purpose | Owned by |
|---|---|---|
| `UserAccount` | People who can sign in (email, display name, PBKDF2 password hash) | (the owner) |
| `UserAccountToken` | One-time emailed tokens, e.g. password reset. Stores only a SHA-256 hash | `UserAccountId` |
| `Auction` | Auctions a user is watching: name, site, link, image, price, start/end, notes | `UserId` |
| `FlipRecord` | Items bought to resell: image, buy/sell price, status, bought/sold dates, optional `AuctionId` | `UserId` |
| `FlipRecordAddOn` | Parts/upgrades put into a flip (a copy of the preset's values when picked from one) | through its `FlipRecord` |
| `AddOnPreset` | The user's saved "My Add-Ons" | `UserId` |
| `LookupAuctionSite` | eBay, Goodwill, … (seeded by post-deploy) | shared |
| `LookupFlipStatus` | 1 Bought, 2 Listed, 3 Sold (seeded by post-deploy; **never renumber**, the API uses these ids) | shared |

Every business table has `IsActive` (soft delete) and the audit columns (`CreatedBy`, `CreatedByUsername`, `CreatedDate`, `UpdatedBy`, `UpdatedByUsername`, `UpdatedDate`). Parts price and profit are calculated by the API, never stored.

## Making a schema change

1. Edit or add the table file in `dbo/Tables/` (keeps the project the source of truth).
2. Add `ManualScripts/<today>/<Change>.sql` that makes the same change to an existing
   database (idempotent: check `COL_LENGTH` / `OBJECT_ID` first), plus `Rollback_<Change>.sql`.
3. Run the manual script in SSMS against your local `FlipLeo` database.
4. Update the API entity + configuration in `FlipLeo.Repository` to match.

## New database from scratch

Build and publish the project (Visual Studio / SSMS **Publish**, or `dotnet build` then
SqlPackage) to an empty `FlipLeo` database. The post-deploy script seeds the lookup data.
