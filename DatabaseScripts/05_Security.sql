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
    1. USER
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'User'
        AND s.name = 'Security'
    )
    BEGIN
        CREATE TABLE Security.[User]
        (
            Id INT IDENTITY(1,1) NOT NULL,
            UserName NVARCHAR(100) NOT NULL,
            PasswordHash NVARCHAR(255) NOT NULL,
            Email NVARCHAR(255) NULL,
            ImageUrl NVARCHAR(MAX) NULL,

            IsActive BIT NOT NULL 
                CONSTRAINT DF_User_IsActive DEFAULT 1,

            AuditCreateDate DATETIME2 NOT NULL 
                CONSTRAINT DF_User_CreateDate DEFAULT SYSDATETIME(),
            AuditCreatedBy INT NULL,

            AuditUpdateDate DATETIME2 NULL,
            AuditUpdatedBy INT NULL,

			CONSTRAINT PK_User
                PRIMARY KEY CLUSTERED (Id)
                WITH (
                    PAD_INDEX = OFF,
                    STATISTICS_NORECOMPUTE = OFF,
                    IGNORE_DUP_KEY = OFF,
                    ALLOW_ROW_LOCKS = ON,
                    ALLOW_PAGE_LOCKS = ON,
                    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
                ),
        );

        /* LOGIN OPTIMIZATION */
        CREATE UNIQUE INDEX UX_User_UserName
        ON Security.[User](UserName);

        CREATE INDEX IX_User_Email
        ON Security.[User](Email);
    END



    /* =========================================================
    2. USER ROLE (RBAC CORE)
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'UserRole'
        AND s.name = 'Security'
    )
    BEGIN
        CREATE TABLE Security.UserRole
        (
            Id INT IDENTITY(1,1) NOT NULL,
            UserId INT NOT NULL,
            RoleId INT NOT NULL,

            IsActive BIT NOT NULL 
                CONSTRAINT DF_UserRole_IsActive DEFAULT 1,


			CONSTRAINT PK_UserRole
                PRIMARY KEY CLUSTERED (Id)
                WITH (
                    PAD_INDEX = OFF,
                    STATISTICS_NORECOMPUTE = OFF,
                    IGNORE_DUP_KEY = OFF,
                    ALLOW_ROW_LOCKS = ON,
                    ALLOW_PAGE_LOCKS = ON,
                    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
                ),


            CONSTRAINT FK_UserRole_User
                FOREIGN KEY (UserId)
                REFERENCES Security.[User](Id),

            CONSTRAINT FK_UserRole_Role
                FOREIGN KEY (RoleId)
                REFERENCES Security.Role(Id)
        );

        /* CRITICAL INDEX (AUTH + JOIN PERFORMANCE) */
        CREATE UNIQUE INDEX UX_UserRole_User_Role
        ON Security.UserRole(UserId, RoleId);

        CREATE INDEX IX_UserRole_Role
        ON Security.UserRole(RoleId);
    END


    /* =========================================================
    3. MENU
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'Menu'
        AND s.name = 'Security'
    )
    BEGIN
        CREATE TABLE Security.Menu
        (
            Id INT IDENTITY(1,1) NOT NULL,
            Name NVARCHAR(100) NOT NULL,
            Url NVARCHAR(255) NULL,
            Icon NVARCHAR(100) NULL,
            ParentId INT NULL,

            IsActive BIT NOT NULL 
                CONSTRAINT DF_Menu_IsActive DEFAULT 1,


			CONSTRAINT PK_Menu
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
    END


    /* =========================================================
    4. MENU ROLE
    ========================================================= */
    IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE t.name = 'MenuRole'
        AND s.name = 'Security'
    )
    BEGIN
        CREATE TABLE Security.MenuRole
        (
            Id INT IDENTITY(1,1) NOT NULL,
            MenuId INT NOT NULL,
            RoleId INT NOT NULL,

            IsActive BIT NOT NULL 
                CONSTRAINT DF_MenuRole_IsActive DEFAULT 1,


			CONSTRAINT PK_MenuRole
                PRIMARY KEY CLUSTERED (Id)
                WITH (
                    PAD_INDEX = OFF,
                    STATISTICS_NORECOMPUTE = OFF,
                    IGNORE_DUP_KEY = OFF,
                    ALLOW_ROW_LOCKS = ON,
                    ALLOW_PAGE_LOCKS = ON,
                    OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
                ),


            CONSTRAINT FK_MenuRole_Menu
                FOREIGN KEY (MenuId)
                REFERENCES Security.Menu(Id),

            CONSTRAINT FK_MenuRole_Role
                FOREIGN KEY (RoleId)
                REFERENCES Security.Role(Id)
        );

        /* FOR DASHBOARD / SIDEBAR BUILDING */
        CREATE UNIQUE INDEX UX_MenuRole_Role_Menu
        ON Security.MenuRole(RoleId, MenuId);

        CREATE INDEX IX_MenuRole_Menu
        ON Security.MenuRole(MenuId);
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
	WHERE t.name IN ('User', 'UserRole', 'Menu', 'MenuRole')
	ORDER BY s.name, t.name;


    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION

    SELECT 
        ERROR_LINE() AS Linea,
        ERROR_MESSAGE() AS Error;
END CATCH;
GO
