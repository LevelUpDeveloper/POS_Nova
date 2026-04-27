-- =======================================================================================================================================
-- a.       Date and time of creation:														23/04/2026
-- b.       Name of the script autor:  													    LevelUpDeveloper
-- c.       Name of the affected aplication													NovaPoS
-- d.       Name of the affected DataBase 													[POS_Nova]
-- e.       Reason:																			Create Inventory tables
-- =======================================================================================================================================
USE POS_Nova;
GO


SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION

    /* =========================================================
    1. PROVIDERS
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'Provider'
        AND s.name = 'Purchasing'
    )
    BEGIN
        CREATE TABLE Purchasing.Provider
        (
            Id INT IDENTITY(1,1) NOT NULL,
            Name NVARCHAR(255) NOT NULL,
            Email NVARCHAR(255) NOT NULL,
            DocumentTypeId INT NOT NULL,
            DocumentNumber NVARCHAR(20) NOT NULL,
            Address NVARCHAR(MAX) NULL,
            Phone NVARCHAR(20) NOT NULL,

            IsActive BIT NOT NULL 
                CONSTRAINT DF_Provider_IsActive DEFAULT 1,

            AuditCreateDate DATETIME2 NOT NULL 
                CONSTRAINT DF_Provider_CreateDate DEFAULT SYSDATETIME(),
            AuditCreatedBy INT NULL,
            AuditUpdateDate DATETIME2 NULL,
            AuditUpdatedBy INT NULL,

            CONSTRAINT PK_Provider 
                PRIMARY KEY CLUSTERED (Id)
                WITH (
                    PAD_INDEX = OFF,
                    STATISTICS_NORECOMPUTE = OFF,
                    IGNORE_DUP_KEY = OFF,
                    ALLOW_ROW_LOCKS = ON,
                    ALLOW_PAGE_LOCKS = ON,
                    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
                ),

            CONSTRAINT FK_Provider_DocumentType
                FOREIGN KEY (DocumentTypeId)
                REFERENCES Security.DocumentType(Id)
        );

        CREATE UNIQUE INDEX UX_Provider_Document
        ON Purchasing.Provider(DocumentTypeId, DocumentNumber)
        WHERE IsActive = 1;

        CREATE INDEX IX_Provider_DocumentType_IsActive
        ON Purchasing.Provider(DocumentTypeId, IsActive);
    END



    /* =========================================================
    2. PRODUCTS
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'Product'
        AND s.name = 'Inventory'
    )
    BEGIN
        CREATE TABLE Inventory.Product
        (
            Id INT IDENTITY(1,1) NOT NULL,
            Code NVARCHAR(100) NULL,
            Name NVARCHAR(150) NOT NULL,
            Description NVARCHAR(255) NULL,

            CategoryId INT NOT NULL,
            ProviderId INT NOT NULL,

            Stock INT NOT NULL 
                CONSTRAINT DF_Product_Stock DEFAULT 0,

            SellPrice DECIMAL(18,2) NOT NULL,
            Image NVARCHAR(MAX) NULL,

            IsActive BIT NOT NULL 
                CONSTRAINT DF_Product_IsActive DEFAULT 1,

            AuditCreateDate DATETIME2 NOT NULL 
                CONSTRAINT DF_Product_CreateDate DEFAULT SYSDATETIME(),
            AuditCreatedBy INT NULL,
            AuditUpdateDate DATETIME2 NULL,
            AuditUpdatedBy INT NULL,

            CONSTRAINT PK_Product 
                PRIMARY KEY CLUSTERED (Id)
                WITH (
                    PAD_INDEX = OFF,
                    STATISTICS_NORECOMPUTE = OFF,
                    IGNORE_DUP_KEY = OFF,
                    ALLOW_ROW_LOCKS = ON,
                    ALLOW_PAGE_LOCKS = ON,
                    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
                ),

            CONSTRAINT FK_Product_Category
                FOREIGN KEY (CategoryId)
                REFERENCES Inventory.Category(Id),

            CONSTRAINT FK_Product_Provider
                FOREIGN KEY (ProviderId)
                REFERENCES Purchasing.Provider(Id)
        );

        CREATE UNIQUE INDEX UX_Product_Code
        ON Inventory.Product(Code)
        WHERE IsActive = 1 AND Code IS NOT NULL;

        CREATE INDEX IX_Product_Category_IsActive
        ON Inventory.Product(CategoryId, IsActive);

        CREATE INDEX IX_Product_Provider_IsActive
        ON Inventory.Product(ProviderId, IsActive);
    END



    /* =========================================================
    3. STOCK MOVEMENT
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'StockMovement'
        AND s.name = 'Inventory'
    )
    BEGIN
        CREATE TABLE Inventory.StockMovement
        (
            Id INT IDENTITY(1,1) NOT NULL,
            ProductId INT NOT NULL,

            MovementType NVARCHAR(20) NOT NULL,
            Quantity INT NOT NULL,
            Reference NVARCHAR(100) NULL,

            CreatedAt DATETIME2 NOT NULL 
                CONSTRAINT DF_StockMovement_Date DEFAULT SYSDATETIME(),

            CONSTRAINT PK_StockMovement
                PRIMARY KEY CLUSTERED (Id)
                WITH (
                    PAD_INDEX = OFF,
                    STATISTICS_NORECOMPUTE = OFF,
                    IGNORE_DUP_KEY = OFF,
                    ALLOW_ROW_LOCKS = ON,
                    ALLOW_PAGE_LOCKS = ON,
                    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
                ),

            CONSTRAINT FK_StockMovement_Product
                FOREIGN KEY (ProductId)
                REFERENCES Inventory.Product(Id)
        );

        CREATE INDEX IX_StockMovement_Product_Date
        ON Inventory.StockMovement(ProductId, CreatedAt);

        CREATE INDEX IX_StockMovement_Type
        ON Inventory.StockMovement(MovementType);
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
	WHERE t.name IN ('Provider', 'Product', 'StockMovement')
	ORDER BY s.name, t.name;



    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    SELECT ERROR_LINE() Linea,
           ERROR_NUMBER() AS Numero,
           ERROR_MESSAGE() AS Error
END CATCH;