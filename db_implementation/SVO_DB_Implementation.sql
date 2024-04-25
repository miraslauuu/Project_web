/*
FILE STRUCTURE :
	A - Creating the database for out website
	B - Creating symmetric encryption (ensuring security of database)
	C - Drop Constarint (may help with changing the db structure)
	D - Drop procedures
	E - Drop User define table
	F - Drop and create functions
	G - Drop and create tables
	H - creating procedures for user log in 
*/

/* *********************************************************************************************************************************************** */
-- A
-- Creating the database for our website
/* *********************************************************************************************************************************************** */


IF DB_ID('SVO_DB_PROJECT_FINAL_VERSION') IS NULL
BEGIN 
	CREATE DATABASE SVO_DB_PROJECT_FINAL_VERSION
END

GO

/* *********************************************************************************************************************************************** */
-- B
-- Creating symmetric encryption (ensuring security of database)
/* *********************************************************************************************************************************************** */

/*
USE SVO_DB_PROJECT_FINAL_VERSION
CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = '7#kD9G@f2$Pq&Z!';

-- Create certificate to protect symmetric key
CREATE CERTIFICATE SVOManegementCertificate
WITH SUBJECT = 'SVOManegementCertificate',
EXPIRY_DATE = '2026-01-01';

-- Create symmetric key to encrypt data

-- tutaj bêdzie b³¹d jak spróbujecie odkodowaæ i nie macie 
-- odpowiedniego permission, w takim razie pisaæ do autora kodu


CREATE SYMMETRIC KEY SVOManagementSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE SVOManagementCertificate;

-- Open symmetric key
OPEN SYMMETRIC KEY SVOManagementSymmetricKey
DECRYPTION BY CERTIFICATE SVOManagementCertificate;
*/
GO

/* *********************************************************************************************************************************************** */
-- C
-- Drop Constarint (may help with changing the db structure)
/* *********************************************************************************************************************************************** */

--here will be dropping of foreign keys and constraints from tables

GO

/* *********************************************************************************************************************************************** */
-- D
-- Drop procedures
/* *********************************************************************************************************************************************** */

--in process

GO

/* *********************************************************************************************************************************************** */
-- E
-- Drop User define table
/* *********************************************************************************************************************************************** */

-- in process

GO

/* *********************************************************************************************************************************************** */
-- F
-- Drop and create functions
/* *********************************************************************************************************************************************** */

GO


/* *********************************************************************************************************************************************** */
-- G
-- Drop and create tables
/* *********************************************************************************************************************************************** */


-- Table Users

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Users') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 

	DROP TABLE dbo.Users
END

CREATE TABLE Users(
	UserID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
	Password BINARY(64) NOT NULL, 
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	UniversityID INT NOT NULL UNIQUE,
	UniversityIDExpired INT DEFAULT 0
)

GO

-- Table Posts


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Posts') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 

	DROP TABLE dbo.Posts
END

CREATE TABLE Posts(
	PostID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	UserID INT  NOT NULL /*CONSTRAINT UserID FOREIGN KEY (UserID)*/ REFERENCES Users(UserID),
	Title NVARCHAR(50),
	Content NVARCHAR(1000),  --dozwolona d³ugoœæ postu
	Date DATETIMEOFFSET
)

GO 

-- Table Calendars

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Calendars') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 

	DROP TABLE dbo.Calendars
END

CREATE TABLE Calendars(
	CalendarID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	UserID INT NOT NULL UNIQUE/*, CONSTRAINT UserID FOREIGN KEY (UserID)*/ REFERENCES Users(UserID),
	Type BIT        -- tutaj 0 = na mies¹c, 1 = na tydzieñ
)


GO

-- Table Events

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Events') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 

	DROP TABLE dbo.Events
END

CREATE TABLE Events(
	EventID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	UserID INT NOT NULL/*, CONSTRAINT UserID FOREIGN KEY (UserID)*/ REFERENCES Users(UserID),
	CalendarID int NOT NULL/*, FOREIGN KEY (CalendarID)*/ REFERENCES Calendars(CalendarID),
	Date DATETIMEOFFSET NOT NULL,
	Type BIT NOT NULL,     -- zajecia Type = 0, rozrywka Type = 1
	Title NVARCHAR(30) NOT NULL,
	Description NVARCHAR(100)
)

GO 

-- Table Maps

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Maps') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 

	DROP TABLE dbo.Maps
END

CREATE TABLE Maps(
	MapID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,  -- tutaj nie jestem pewna czy trzeba klucz, 
	                                                 -- byæ mo¿e przyda siê do widoków
)


GO

-- Table Buildings

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Buildings') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 

	DROP TABLE dbo.Buildings
END

CREATE TABLE Buildings(
	BuildingID int PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	MapID INT NOT NULL/*, CONSTRAINT MapID FOREIGN KEY (MapID)*/ REFERENCES Maps(MapID),
	City NVARCHAR(30) DEFAULT '£ódŸ',
	Street NVARCHAR(30),
	BuildingNum INT,
	PostCode NVARCHAR(10)
)


GO

-- Table Messages

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Buildings') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 

	DROP TABLE dbo.Buildings
END

CREATE TABLE Messages(
	MessageID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	SentByUserID INT NOT NULL/*, CONSTRAINT SentByUserID FOREIGN KEY (SentByUserID)*/ REFERENCES Users(UserID),  --id tego co wys³al wiadomoœæ
	SentToUserID INT NOT NULL/*, CONSTRAINT SentToUserID FOREIGN KEY (SentToUserID)*/ REFERENCES Users(UserID),  --id tego komu wys³ali 
	Date DATETIMEOFFSET,
	Content NVARCHAR(100)
)


/* *********************************************************************************************************************************************** */
-- H
-- Creating procedures for user log in
/* *********************************************************************************************************************************************** */
GO
drop procedure HashUserPassword
go
CREATE PROCEDURE HashUserPassword
	@Password NVARCHAR(255),
	@Hashed_password BINARY(64) OUTPUT
	WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON;
    SET @Hashed_password = HASHBYTES('SHA2_256', @Password);
END
GO

CREATE PROCEDURE CheckIfUserExists   -- if user exists returns 1, else 0
	@UserUniversityID int
	WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON;
	IF EXISTS (
		SELECT * FROM Users WHERE @UserUniversityID = UniversityID
		AND UniversityIDExpired = 0
	) 
	BEGIN
        RETURN 1;
    END
    ELSE
    BEGIN
        RETURN 0;
    END
END

GO
select * from Users
go
delete from users 
where users.UserID = 1
drop procedure UserRegistration
go

CREATE PROCEDURE UserRegistration
	@UserUniversityID int,
	@UserFirstName nvarchar(30),
	@UserLastName nvarchar(30),
	@UserPassword nvarchar(255),
	@Result int OUTPUT
	WITH ENCRYPTION
AS 
BEGIN
	DECLARE @UserExistsError int;
	EXEC @UserExistsError = CheckIfUserExists @UserUniversityID;
	IF @UserExistsError = 1
		BEGIN
			SET @Result = 1; --user already exists in db
		END

	--hash password
	DECLARE @UserHashedPassword BINARY(64);
	EXEC HashUserPassword @UserPassword, @UserHashedPassword OUTPUT;
	--insert values into table
	INSERT INTO Users (UniversityID, FirstName, LastName, Password)
    VALUES (@UserUniversityID, @UserFirstName, @UserLastName, @UserHashedPassword);
	
	--check is insertion was successful
	/*IF @@ROWCOUNT > 0
	BEGIN
		SET @Result = 0; --ok
	END
	ELSE 
	BEGIN*/
		SET @Result = 0; --failed
	--END

END
GO

drop procedure UserLogInValidation;

select * from users

go



CREATE PROCEDURE UserLogInValidation
    @UserUniversityID int,
    @UserPassword nvarchar(255),
    @Result int OUTPUT
AS
BEGIN
    DECLARE @UserDontExistsError int;
    EXEC @UserDontExistsError = CheckIfUserExists @UserUniversityID;
    IF @UserDontExistsError = 0
    BEGIN
        SET @Result = 1; -- user does not exist
        RETURN;
    END
    DECLARE @UserHashedPassword binary(64);
    EXEC @UserHashedPassword = HashUserPassword @UserPassword;
    IF EXISTS(
        SELECT * FROM Users WHERE UniversityID = @UserUniversityID AND Password = @UserHashedPassword
    )
    BEGIN
        SET @Result = 0; -- log in success
    END
    ELSE
    BEGIN
        SET @Result = 2; -- incorrect password
    END
END


GO

/*DECLARE @RES INT;  -- Declaration without initialization
EXEC @RES = UserLogInValidation 123, 'haslo';

PRINT CAST(@RES AS VARCHAR(10))*/