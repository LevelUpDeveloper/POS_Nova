-- =======================================================================================================================================
-- a.       Date and time of creation:														21/04/2026
-- b.       Name of the script autor:  													    LevelUpDeveloper
-- c.       Name of the affected aplication													NovaPoS
-- d.       Name of the affected DataBase 													[POS_Nova]
-- e.       Reason:																			Create Domain tables
-- =======================================================================================================================================
USE POS_Nova;
GO


SET XACT_ABORT ON;
GO

BEGIN TRY
	BEGIN TRANSACTION

	/* =========================================================
	1. DEPARTMENTS (Base location)
	========================================================= */
	IF NOT EXISTS (
		SELECT 1
		FROM sys.tables t
		INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.name = 'Department'
		  AND s.name = 'Reference'
	)
	BEGIN
		CREATE TABLE Reference.Department
		(
			Id INT IDENTITY(1,1) NOT NULL,
			Name NVARCHAR(150) NOT NULL,
			IsActive BIT NOT NULL 
				CONSTRAINT DF_Department_IsActive DEFAULT 1,

			CONSTRAINT PK_Department 
				PRIMARY KEY CLUSTERED (Id)
				WITH (
					PAD_INDEX = OFF,
					STATISTICS_NORECOMPUTE = OFF,
					IGNORE_DUP_KEY = OFF,
					ALLOW_ROW_LOCKS = ON,
					ALLOW_PAGE_LOCKS = ON,
					OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
				)
		);

		/* Additional unique index */
		CREATE UNIQUE INDEX UX_Department_Name
		ON Reference.Department(Name)
		WHERE IsActive = 1;
	END



	/* =========================================================
	2. DOCUMENT TYPES
	========================================================= */
	IF NOT EXISTS (
		SELECT 1
		FROM sys.tables t
		INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.name = 'DocumentType'
		  AND s.name = 'Security'
	)
	BEGIN
		CREATE TABLE Security.DocumentType
		(
			Id INT IDENTITY(1,1) NOT NULL,
			Code NVARCHAR(10) NULL,
			Name NVARCHAR(255) NOT NULL,
			Abbreviation VARCHAR(10) NULL,
			IsActive BIT NOT NULL 
				CONSTRAINT DF_DocumentType_IsActive DEFAULT 1,
			
			CONSTRAINT PK_DocumentType 
				PRIMARY KEY CLUSTERED (Id)
				WITH (
					PAD_INDEX = OFF,
					STATISTICS_NORECOMPUTE = OFF,
					IGNORE_DUP_KEY = OFF,
					ALLOW_ROW_LOCKS = ON,
					ALLOW_PAGE_LOCKS = ON,
					OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
				)
		);

		CREATE UNIQUE INDEX UX_DocumentType_Name
		ON Security.DocumentType(Name)
		WHERE IsActive = 1;
	END



	/* =========================================================
	3. ROLES (RBAC)
	========================================================= */
	IF NOT EXISTS (
		SELECT 1
		FROM sys.tables t
		INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.name = 'Role'
		  AND s.name = 'Security'
	)
	BEGIN
		CREATE TABLE Security.Role
		(
			Id INT IDENTITY(1,1) NOT NULL,
			Name NVARCHAR(50) NOT NULL,
			Description NVARCHAR(50) NULL,
			IsActive BIT NOT NULL 
				CONSTRAINT DF_Role_IsActive DEFAULT 1,
			
			CONSTRAINT PK_Role 
				PRIMARY KEY CLUSTERED (Id)
				WITH (
					PAD_INDEX = OFF,
					STATISTICS_NORECOMPUTE = OFF,
					IGNORE_DUP_KEY = OFF,
					ALLOW_ROW_LOCKS = ON,
					ALLOW_PAGE_LOCKS = ON,
					OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
				)
		);

		CREATE UNIQUE INDEX UX_Role_Name
		ON Security.Role(Name)
		WHERE IsActive = 1;
	END



	/* =========================================================
	4. CATEGORIES (products)
	========================================================= */
	IF NOT EXISTS (
		SELECT 1
		FROM sys.tables t
		INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.name = 'Category'
		  AND s.name = 'Inventory'
	)
	BEGIN
		CREATE TABLE Inventory.Category
		(
			Id INT IDENTITY(1,1) NOT NULL,
			Name NVARCHAR(100) NOT NULL,
			Description NVARCHAR(255) NULL,
			IsActive BIT NOT NULL 
				CONSTRAINT DF_Category_IsActive DEFAULT 1,

			/* Audit */
			AuditCreateDate DATETIME2 NOT NULL 
				CONSTRAINT DF_Category_CreateDate DEFAULT SYSDATETIME(),

			AuditCreatedBy INT NULL,

			AuditUpdateDate DATETIME2 NULL,
			AuditUpdatedBy INT NULL,

			CONSTRAINT PK_Category 
				PRIMARY KEY CLUSTERED (Id)
				WITH (
					PAD_INDEX = OFF,
					STATISTICS_NORECOMPUTE = OFF,
					IGNORE_DUP_KEY = OFF,
					ALLOW_ROW_LOCKS = ON,
					ALLOW_PAGE_LOCKS = ON,
					OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
				)
		);

		CREATE UNIQUE INDEX UX_Category_Name
		ON Inventory.Category(Name)
		WHERE IsActive = 1;
	END


	/* =========================================================
	5. BUSINESS (CORE)
	========================================================= */
	IF NOT EXISTS (
		SELECT 1
		FROM sys.tables t
		INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.name = 'Business'
		  AND s.name = 'Core'
	)
	BEGIN
		CREATE TABLE Core.Business
		(
			Id INT IDENTITY(1,1) NOT NULL,
			Name NVARCHAR(150) NOT NULL,
			DocumentNumber NVARCHAR(20) NOT NULL,
			Address NVARCHAR(MAX) NULL,
			Phone NVARCHAR(20) NULL,
			Email NVARCHAR(255) NULL,
			IsActive BIT NOT NULL 
				CONSTRAINT DF_Business_IsActive DEFAULT 1,

				CONSTRAINT PK_Business 
				PRIMARY KEY CLUSTERED (Id)
				WITH (
					PAD_INDEX = OFF,
					STATISTICS_NORECOMPUTE = OFF,
					IGNORE_DUP_KEY = OFF,
					ALLOW_ROW_LOCKS = ON,
					ALLOW_PAGE_LOCKS = ON,
					OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
				)
		);

		CREATE UNIQUE INDEX UX_Business_Document
		ON Core.Business(DocumentNumber)
		WHERE IsActive = 1;
	END


	/* =========================================================
	6. BRANCH OFFICES (CORE)
	========================================================= */
	IF NOT EXISTS (
		SELECT 1
		FROM sys.tables t
		INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.name = 'BranchOffice'
		  AND s.name = 'Core'
	)
	BEGIN
		CREATE TABLE Core.BranchOffice
		(
			Id INT IDENTITY(1,1) NOT NULL,
			BusinessId INT NOT NULL,
			DepartmentId INT NOT NULL,
			Name NVARCHAR(150) NOT NULL,
			Address NVARCHAR(MAX) NULL,
			Phone NVARCHAR(20) NULL,
			Email NVARCHAR(255) NULL,

			IsActive BIT NOT NULL 
				CONSTRAINT DF_BranchOffice_IsActive DEFAULT 1,

	
			CONSTRAINT PK_BranchOffice 
				PRIMARY KEY CLUSTERED (Id)
				WITH (
					PAD_INDEX = OFF,
					STATISTICS_NORECOMPUTE = OFF,
					IGNORE_DUP_KEY = OFF,
					ALLOW_ROW_LOCKS = ON,
					ALLOW_PAGE_LOCKS = ON,
					OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
				),

			CONSTRAINT FK_BranchOffice_Business
				FOREIGN KEY (BusinessId)
				REFERENCES Core.Business(Id),

			CONSTRAINT FK_BranchOffice_Department
				FOREIGN KEY (DepartmentId)
				REFERENCES Reference.Department(Id)
		);

		CREATE INDEX IX_BranchOffice_BusinessId
		ON Core.BranchOffice(BusinessId);

		CREATE INDEX IX_BranchOffice_DepartmentId
		ON Core.BranchOffice(DepartmentId);
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
	WHERE t.name IN ('Department', 'DocumentType', 'Role', 'Category', 'Business', 'BranchOffice')
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