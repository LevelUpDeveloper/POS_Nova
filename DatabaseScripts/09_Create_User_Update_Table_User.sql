-- =======================================================================================================================================
-- a.       Date and time of creation:														14/05/2026
-- b.       Name of the script autor:  													    LevelUpDeveloper
-- c.       Name of the affected aplication													NovaPoS
-- d.       Name of the affected DataBase 													[POS_Nova]
-- e.       Reason:																			Create User and Update Table User
-- =======================================================================================================================================
USE [POS_Nova]
GO

SET XACT_ABORT ON;
GO

BEGIN TRY
    BEGIN TRANSACTION

	/* =========================================================
	Create User
	========================================================= */
	INSERT INTO Security.Role (Name, Description, IsActive)
	VALUES ('Admin', 'Administrator role', 1);
	
	
	INSERT INTO Security.[User]
	(UserName, PasswordHash, Email, ImageUrl, IsActive, AuditCreateDate)
	VALUES
	('admin',
	 '123456',  --Only for testing if you don´t already have hashing implemented
	 'admin@test.com',
	 NULL,
	 1,
	 GETDATE());
	
	
	INSERT INTO Security.UserRole (UserId, RoleId, IsActive)
	VALUES (1, 1, 1);
	
	
	--Verify user
	SELECT *
	FROM Security.[User] Us
	INNER JOIN Security.UserRole UR ON Us.Id = UR.UserId
	INNER JOIN Security.Role Ro ON UR.RoleId = Ro.Id
	
	


	/* =========================================================
	Update table User to add failed attempt logic and lockout
	========================================================= */
	ALTER TABLE Security.[User]
	ADD
	    FailedLoginAttempts INT NOT NULL CONSTRAINT DF_User_FailedLoginAttempts DEFAULT 0,
	    IsLocked BIT NOT NULL CONSTRAINT DF_User_IsLocked DEFAULT 0,
	    LockedUntil DATETIME NULL,
	    Role NVARCHAR(50) NOT NULL CONSTRAINT DF_User_Role DEFAULT 'User'






    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION

    SELECT 
        ERROR_LINE() AS Linea,
        ERROR_NUMBER() AS Numero,
        ERROR_MESSAGE() AS Error;
END CATCH;