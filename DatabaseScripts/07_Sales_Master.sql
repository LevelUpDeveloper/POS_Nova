-- =======================================================================================================================================
-- a. Date and time of creation:                                              24/04/2026
-- b. Script author:                                                          LevelUpDeveloper
-- c. Application:                                                            NovaPoS
-- d. Database:                                                               POS_Nova
-- e. Reason:                                                                 Create Sales Master Data (Client)
-- =======================================================================================================================================
USE POS_Nova;
GO


SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION

    /* =========================================================
    1. CLIENTS (Sales Master Data)
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'Client'
        AND s.name = 'Sales'
    )
    BEGIN
        CREATE TABLE Sales.Client
        (
            Id INT IDENTITY(1,1) NOT NULL,
            Name NVARCHAR(150) NOT NULL,
            DocumentTypeId INT NOT NULL,
            DocumentNumber NVARCHAR(20) NULL,
            Address NVARCHAR(MAX) NULL,
            Phone NVARCHAR(20) NULL,
            Email NVARCHAR(255) NULL,

            IsActive BIT NOT NULL 
                CONSTRAINT DF_Client_IsActive DEFAULT 1,

            /* Audit */
            AuditCreateDate DATETIME2 NOT NULL 
                CONSTRAINT DF_Client_CreateDate DEFAULT SYSDATETIME(),
            AuditCreatedBy INT NULL,

            AuditUpdateDate DATETIME2 NULL,
            AuditUpdatedBy INT NULL,

            AuditDeleteDate DATETIME2 NULL,
            AuditDeletedBy INT NULL,

            CONSTRAINT PK_Client 
                PRIMARY KEY CLUSTERED (Id)
                WITH (
                    PAD_INDEX = OFF,
                    STATISTICS_NORECOMPUTE = OFF,
                    IGNORE_DUP_KEY = OFF,
                    ALLOW_ROW_LOCKS = ON,
                    ALLOW_PAGE_LOCKS = ON,
                    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
                ),

            CONSTRAINT FK_Client_DocumentType
                FOREIGN KEY (DocumentTypeId)
                REFERENCES Security.DocumentType(Id)
        );

        /* =========================================================
           INDEXES
        ========================================================= */

        -- Evita duplicados de documentos activos
        CREATE UNIQUE INDEX UX_Client_Document
        ON Sales.Client(DocumentTypeId, DocumentNumber)
        WHERE IsActive = 1 AND DocumentNumber IS NOT NULL;

        -- Búsqueda por nombre
        CREATE INDEX IX_Client_Name
        ON Sales.Client(Name);

        -- FK performance
        CREATE INDEX IX_Client_DocumentType_IsActive
        ON Sales.Client(DocumentTypeId, IsActive);

        -- Búsqueda común por estado
        CREATE INDEX IX_Client_IsActive
        ON Sales.Client(IsActive);
    END


    /* =========================================================
    VALIDATION RESULT
    ========================================================= */
    SELECT 
        s.name AS SchemaName,
        t.name AS TableName,
        t.create_date,
        t.modify_date
    FROM sys.tables t
    INNER JOIN sys.schemas s 
        ON t.schema_id = s.schema_id
    WHERE t.name = 'Client'
    AND s.name = 'Sales';


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