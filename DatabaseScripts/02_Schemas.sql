-- =======================================================================================================================================
-- a.       Date and time of creation:														21/04/2026
-- b.       Name of the script autor:  													    LevelUpDeveloper
-- c.       Name of the affected aplication													NovaPoS
-- d.       Name of the affected DataBase 													[POS_Nova]
-- e.       Reason:																			Schemas are created by domain
-- =======================================================================================================================================
USE POS_Nova;
GO


BEGIN TRY
	BEGIN TRANSACTION


	/* =========================================================
	1. SECURITY (authentication and authorization)
	   ========================================================= */
	IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Security')
	EXEC('CREATE SCHEMA Security');
	
	
	/* =========================================================
	2. SALES (billing and customer module)
	========================================================= */
	IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Sales')
	EXEC('CREATE SCHEMA Sales');
	
	
	/* =========================================================
	3. PURCHASES (suppliers and acquisitions)
	========================================================= */
	IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Purchasing')
	EXEC('CREATE SCHEMA Purchasing');
	
	
	/* =========================================================
	4. Inventory (products, categories, stock)
	========================================================= */
	IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Inventory')
	EXEC('CREATE SCHEMA Inventory');
	
	
	/* =========================================================
	5. REFERENCE (location: countries, regions, etc.)
	========================================================= */
	IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Reference')
	EXEC('CREATE SCHEMA Reference');
	
	
	/* =========================================================
	6. CORE (company, branches, base configuration)
	========================================================= */
	IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Core')
	EXEC('CREATE SCHEMA Core');
	
	
	--DROP SCHEMA Security;

	SELECT name, schema_id
	FROM sys.schemas
	ORDER BY schema_id;


	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	SELECT ERROR_LINE() Linea
		,ERROR_NUMBER() AS Numero
		,ERROR_SEVERITY() AS Severity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_MESSAGE() AS Error
END CATCH
