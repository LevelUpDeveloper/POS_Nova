-- =======================================================================================================================================
-- a.       Date and time of creation:														23/04/2026
-- b.       Name of the script autor:  													    LevelUpDeveloper
-- c.       Name of the affected aplication													NovaPoS
-- d.       Name of the affected DataBase 													[POS_Nova]
-- e.       Reason:																			Create Security tables
-- =======================================================================================================================================
USE POS_Nova;
GO


SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION

    /* =========================================================
    TAX TYPE 
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'TaxType'
        AND s.name = 'Reference'
    )
    BEGIN
        CREATE TABLE Reference.TaxType
        (
            Id INT IDENTITY(1,1) NOT NULL,
            Name NVARCHAR(100) NOT NULL,
            Rate DECIMAL(5,4) NOT NULL,
            CountryCode NVARCHAR(10) NOT NULL,
            IsActive BIT NOT NULL 
                CONSTRAINT DF_TaxType_IsActive DEFAULT 1,

            AuditCreateDate DATETIME2 NOT NULL 
                CONSTRAINT DF_TaxType_CreateDate DEFAULT SYSDATETIME(),


			CONSTRAINT PK_TaxType 
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

        -- prevent duplicate tax names per country
        CREATE UNIQUE INDEX UX_TaxType_Name_Country
        ON Reference.TaxType(Name, CountryCode);
    END


    /* =========================================================
    1. PURCHASE (HEADER)
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'Purchase'
        AND s.name = 'Purchasing'
    )
    BEGIN
        CREATE TABLE Purchasing.Purchase
        (
            Id INT IDENTITY(1,1) NOT NULL,
            ProviderId INT NOT NULL,
            UserId INT NOT NULL,

            PurchaseDate DATETIME2 NOT NULL 
                CONSTRAINT DF_Purchase_Date DEFAULT SYSDATETIME(),

            SubTotal DECIMAL(18,2) NOT NULL,

            -- snapshot of tax applied (IMPORTANT)
            TaxRate DECIMAL(5,4) NOT NULL,
            TaxAmount DECIMAL(18,2) NOT NULL,

            Total DECIMAL(18,2) NOT NULL,

            TaxTypeId INT NULL,

            IsActive BIT NOT NULL 
                CONSTRAINT DF_Purchase_IsActive DEFAULT 1,

            AuditCreateDate DATETIME2 NOT NULL 
                CONSTRAINT DF_Purchase_CreateDate DEFAULT SYSDATETIME(),

            AuditCreatedBy INT NULL,


			CONSTRAINT PK_Purchase 
				PRIMARY KEY CLUSTERED (Id)
				WITH (
				    PAD_INDEX = OFF,
				    STATISTICS_NORECOMPUTE = OFF,
				    IGNORE_DUP_KEY = OFF,
				    ALLOW_ROW_LOCKS = ON,
				    ALLOW_PAGE_LOCKS = ON,
				    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
				),


            CONSTRAINT FK_Purchase_Provider
                FOREIGN KEY (ProviderId)
                REFERENCES Purchasing.Provider(Id),

            CONSTRAINT FK_Purchase_User
                FOREIGN KEY (UserId)
                REFERENCES Security.[User](Id),

            CONSTRAINT FK_Purchase_TaxType
                FOREIGN KEY (TaxTypeId)
                REFERENCES Reference.TaxType(Id)
        );

        CREATE INDEX IX_Purchase_Provider_IsActive
        ON Purchasing.Purchase(ProviderId, IsActive);

        CREATE INDEX IX_Purchase_User_IsActive
        ON Purchasing.Purchase(UserId, IsActive);

        CREATE INDEX IX_Purchase_Date
        ON Purchasing.Purchase(PurchaseDate);

		CREATE INDEX IX_Purchase_TaxTypeId
        ON Purchasing.Purchase(TaxTypeId);

    END


    /* =========================================================
    2. SALE (HEADER)
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'Sale'
        AND s.name = 'Sales'
    )
    BEGIN
        CREATE TABLE Sales.Sale
        (
            Id INT IDENTITY(1,1) NOT NULL,
            ClientId INT NULL,
            UserId INT NOT NULL,

            SaleDate DATETIME2 NOT NULL 
                CONSTRAINT DF_Sale_Date DEFAULT SYSDATETIME(),

            SubTotal DECIMAL(18,2) NOT NULL,

            --snapshot tax 
            TaxRate DECIMAL(5,4) NOT NULL,
            TaxAmount DECIMAL(18,2) NOT NULL,

            Total DECIMAL(18,2) NOT NULL,

            TaxTypeId INT NULL,

            IsActive BIT NOT NULL 
                CONSTRAINT DF_Sale_IsActive DEFAULT 1,

            AuditCreateDate DATETIME2 NOT NULL 
                CONSTRAINT DF_Sale_CreateDate DEFAULT SYSDATETIME(),

            AuditCreatedBy INT NULL,


			CONSTRAINT PK_Sale 
			    PRIMARY KEY CLUSTERED (Id)
			    WITH (
			        PAD_INDEX = OFF,
			        STATISTICS_NORECOMPUTE = OFF,
			        IGNORE_DUP_KEY = OFF,
			        ALLOW_ROW_LOCKS = ON,
			        ALLOW_PAGE_LOCKS = ON,
			        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			    ),


            CONSTRAINT FK_Sale_Client
                FOREIGN KEY (ClientId)
                REFERENCES Sales.Client(Id),

            CONSTRAINT FK_Sale_User
                FOREIGN KEY (UserId)
                REFERENCES Security.[User](Id),

            CONSTRAINT FK_Sale_TaxType
                FOREIGN KEY (TaxTypeId)
                REFERENCES Reference.TaxType(Id)
        );

        CREATE INDEX IX_Sale_Client_IsActive
        ON Sales.Sale(ClientId, IsActive);

        CREATE INDEX IX_Sale_User_IsActive
        ON Sales.Sale(UserId, IsActive);

        CREATE INDEX IX_Sale_Date
        ON Sales.Sale(SaleDate);

		CREATE INDEX IX_Sale_TaxTypeId
        ON Sales.Sale(TaxTypeId);

    END


    /* =========================================================
    3. PURCHASE DETAIL
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'PurchaseDetail'
        AND s.name = 'Purchasing'
    )
    BEGIN
        CREATE TABLE Purchasing.PurchaseDetail
        (
            Id INT IDENTITY(1,1) NOT NULL,
            PurchaseId INT NOT NULL,
            ProductId INT NOT NULL,

            Quantity INT NOT NULL,
            UnitPrice DECIMAL(18,2) NOT NULL,
            Total DECIMAL(18,2) NOT NULL,


			CONSTRAINT PK_PurchaseDetail 
			    PRIMARY KEY CLUSTERED (Id)
			    WITH (
			        PAD_INDEX = OFF,
			        STATISTICS_NORECOMPUTE = OFF,
			        IGNORE_DUP_KEY = OFF,
			        ALLOW_ROW_LOCKS = ON,
			        ALLOW_PAGE_LOCKS = ON,
			        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			    ),


            CONSTRAINT FK_PurchaseDetail_Purchase
                FOREIGN KEY (PurchaseId)
                REFERENCES Purchasing.Purchase(Id),

            CONSTRAINT FK_PurchaseDetail_Product
                FOREIGN KEY (ProductId)
                REFERENCES Inventory.Product(Id)
        );

	
		CREATE INDEX IX_PurchaseDetail_PurchaseId
        ON Purchasing.PurchaseDetail(PurchaseId);

        CREATE INDEX IX_PurchaseDetail_ProductId
        ON Purchasing.PurchaseDetail(ProductId);


    END


    /* =========================================================
    4. SALE DETAIL
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'SaleDetail'
        AND s.name = 'Sales'
    )
    BEGIN
        CREATE TABLE Sales.SaleDetail
        (
            Id INT IDENTITY(1,1) NOT NULL,
            SaleId INT NOT NULL,
            ProductId INT NOT NULL,

            Quantity INT NOT NULL,
            UnitPrice DECIMAL(18,2) NOT NULL,

            Discount DECIMAL(18,2) NOT NULL 
                CONSTRAINT DF_SaleDetail_Discount DEFAULT 0,

            Total DECIMAL(18,2) NOT NULL,


			CONSTRAINT PK_SaleDetail 
			    PRIMARY KEY CLUSTERED (Id)
			    WITH (
			        PAD_INDEX = OFF,
			        STATISTICS_NORECOMPUTE = OFF,
			        IGNORE_DUP_KEY = OFF,
			        ALLOW_ROW_LOCKS = ON,
			        ALLOW_PAGE_LOCKS = ON,
			        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			    ),


            CONSTRAINT FK_SaleDetail_Sale
                FOREIGN KEY (SaleId)
                REFERENCES Sales.Sale(Id),

            CONSTRAINT FK_SaleDetail_Product
                FOREIGN KEY (ProductId)
                REFERENCES Inventory.Product(Id)
        );


		CREATE INDEX IX_SaleDetail_SaleId
        ON Sales.SaleDetail(SaleId);

        CREATE INDEX IX_SaleDetail_ProductId
        ON Sales.SaleDetail(ProductId);

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
	WHERE t.name IN ('TaxType', 'Purchase', 'Sale', 'PurchaseDetail', 'SaleDetail')
	ORDER BY s.name, t.name;


    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION

    SELECT 
        ERROR_LINE() AS Linea,
        ERROR_NUMBER() AS Numero,
        ERROR_MESSAGE() AS Error;
END CATCH;