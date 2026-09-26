# FlipLeo.Database

SQL Server schema for FlipLeo, set up the same way as `Pivotal.Database`.

## Layout

| Path | What it is |
|---|---|
| `FlipLeo.Database/dbo/Tables/` | One `CREATE TABLE` per file. **The source of truth for the schema.** |
| `FlipLeo.Database/Script.PostDeployment.sql` | Runs after every publish. Pulls in seed scripts with `:r`. |
| `FlipLeo.Database/PostDeployment/` | Seed / lookup data (`MERGE`, safe to re-run). |
| `FlipLeo.Database/ManualScripts/yyyy-MM-dd/` | One-off change scripts for an existing database, each with a `Rollback_` script. Run by hand in SSMS. |

## Tables

- `UserAccount`: people who can log in (email + hashed password)
- `LookupAuctionSite`: eBay, Goodwill, ... (seeded by post-deploy)
- `Auction`: auctions a user is watching (owned by `UserId`)
- `FlipRecord`: completed flips (owned by `UserId`, optional link to an `Auction`)
- `FlipRecordAddOn`: parts bought for a flip (owned through its `FlipRecord`)

## Making a schema change

1. Edit or add the table file in `dbo/Tables/` (keeps the project the source of truth).
2. Add `ManualScripts/<today>/<Change>.sql` that makes the same change to an existing
   database (idempotent: check `COL_LENGTH` / `OBJECT_ID` first), plus `Rollback_<Change>.sql`.
3. Run the manual script in SSMS against your local `FlipLeo` database.
4. Update the API entity + configuration in `FlipLeo.Repository` to match.

## New database from scratch

Build and publish the project (Visual Studio / SSMS **Publish**, or `dotnet build` then
SqlPackage) to an empty `FlipLeo` database. The post-deploy script seeds the lookup data.
