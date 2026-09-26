/*
Post-Deployment Script
--------------------------------------------------------------------------------------
 Runs after every publish of this project. Use it for seed/lookup data.
 Use SQLCMD syntax to include a file:   :r .\PostDeployment\myfile.sql
 Every included script must be safe to run more than once (MERGE, IF NOT EXISTS).
--------------------------------------------------------------------------------------
*/

:r .\PostDeployment\Populate_LookupAuctionSite.sql
