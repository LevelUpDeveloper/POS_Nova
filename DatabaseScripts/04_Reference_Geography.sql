-- =======================================================================================================================================
-- a.       Date and time of creation:														22/04/2026
-- b.       Name of the script autor:  													    LevelUpDeveloper
-- c.       Name of the affected aplication													NovaPoS
-- d.       Name of the affected DataBase 													[POS_Nova]
-- e.       Reason:																			Create Reference tables
-- =======================================================================================================================================
USE POS_Nova;
GO


SET XACT_ABORT ON;
GO

BEGIN TRY
	BEGIN TRANSACTION

	/* =========================================================
	PROVINCE (depends on Department)
	========================================================= */
	IF NOT EXISTS (
		SELECT 1
		FROM sys.tables t
		INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.name = 'Province'
		AND s.name = 'Reference'
	)
	BEGIN
		CREATE TABLE Reference.Province
		(
			Id INT IDENTITY(1,1) NOT NULL,
			DepartmentId INT NOT NULL,
			Name NVARCHAR(150) NOT NULL,
			IsActive BIT NOT NULL
				CONSTRAINT DF_Province_IsActive DEFAULT 1,
			
			/* =========================
			   CONSTRAINTS
			========================= */
			CONSTRAINT PK_Province
				PRIMARY KEY CLUSTERED (Id)
				WITH (
					PAD_INDEX = OFF,
					STATISTICS_NORECOMPUTE = OFF,
					IGNORE_DUP_KEY = OFF,
					ALLOW_ROW_LOCKS = ON,
					ALLOW_PAGE_LOCKS = ON,
					OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
				),
			
			CONSTRAINT FK_Province_Department
				FOREIGN KEY (DepartmentId)
				REFERENCES Reference.Department(Id)
		);
		
		/* Unique index per Department */
		CREATE UNIQUE INDEX UX_Province_Department_Name
		ON Reference.Province(DepartmentId, Name)
		WHERE IsActive = 1;
		
		/* Index for FK */
		CREATE INDEX IX_Province_DepartmentId
		ON Reference.Province(DepartmentId);
	
	END
	
	
	
	/* =========================================================
	2. DISTRICT (depends on Province)
	========================================================= */
	IF NOT EXISTS (
		SELECT 1
		FROM sys.tables t
		INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.name = 'District'
		AND s.name = 'Reference'
	)
	BEGIN
		CREATE TABLE Reference.District
		(
			Id INT IDENTITY(1,1) NOT NULL,
			ProvinceId INT NOT NULL,
			Name NVARCHAR(150) NOT NULL,
			IsActive BIT NOT NULL
				CONSTRAINT DF_District_IsActive DEFAULT 1,
		
			/* =========================
			   CONSTRAINTS
			========================= */
			CONSTRAINT PK_District 
				PRIMARY KEY CLUSTERED (Id)
				WITH (
					PAD_INDEX = OFF,
					STATISTICS_NORECOMPUTE = OFF,
					IGNORE_DUP_KEY = OFF,
					ALLOW_ROW_LOCKS = ON,
					ALLOW_PAGE_LOCKS = ON,
					OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
				),
		
			CONSTRAINT FK_District_Province
				FOREIGN KEY (ProvinceId)
				REFERENCES Reference.Province(Id)
		);
		
		/* Unique index per Province */
		CREATE UNIQUE INDEX UX_District_Province_Name
		ON Reference.District(ProvinceId, Name)
		WHERE IsActive = 1;
		
		/* Index for FK */
		CREATE INDEX IX_District_ProvinceId
		ON Reference.District(ProvinceId);
	
	END


	/* =========================================================
	VERIFY TABLES
	========================================================= */
	SELECT 
		s.name AS SchemaName,
		t.name AS TableName,
		t.create_date,
		t.modify_date
	FROM sys.tables t
	INNER JOIN sys.schemas s 
		ON t.schema_id = s.schema_id
	WHERE t.name IN ('Province', 'District')
	ORDER BY s.name, t.name;



	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	SELECT ERROR_LINE() AS Linea,
		   ERROR_NUMBER() AS Numero,
		   ERROR_SEVERITY() AS Severity,
		   ERROR_STATE() AS ErrorState,
		   ERROR_MESSAGE() AS Error
END CATCH;
