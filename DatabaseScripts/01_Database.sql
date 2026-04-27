-- =======================================================================================================================================
-- a.       Date and time of creation:														21/04/2026
-- b.       Name of the script autor:  													    LevelUpDeveloper
-- c.       Name of the affected aplication													NovaPoS
-- d.       Name of the affected DataBase 													[POS_Nova]
-- e.       Reason:																			A new Database is created for the NovaPoS application
-- =======================================================================================================================================


--1. DB Creation / Start--------------
IF DB_ID('POS_Nova') IS NULL
BEGIN
	CREATE DATABASE POS_Nova
	--DROP DATABASE POS_Nova
END
GO
--1. DB Creation / End--------------



--2. DB Configurations / Start
USE POS_Nova
GO

ALTER DATABASE POS_Nova SET ANSI_NULLS ON;
GO

ALTER DATABASE POS_Nova SET QUOTED_IDENTIFIER ON;
GO
--2. DB Configurations / End



--3. Recovery Settings / Start
ALTER DATABASE POS_Nova SET RECOVERY FULL;
GO
--3. Recovery Settings / End


--4. Data file configuration / Start
ALTER DATABASE POS_Nova
MODIFY FILE (
    NAME = POS_Nova,
    SIZE = 512MB,
    FILEGROWTH = 128MB
)
--4. Data file configuration / End


--5. Log configuration / Start
ALTER DATABASE POS_Nova
MODIFY FILE (
    NAME = POS_Nova_log,
    SIZE = 256MB,
    FILEGROWTH = 64MB
)
--5. Log configuration / End
