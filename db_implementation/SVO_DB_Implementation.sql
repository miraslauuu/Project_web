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


USE SVO_DB_PROJECT_FINAL_VERSION
/*CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = '7#kD9G@f2$Pq&Z!';

-- Create certificate to protect symmetric key
CREATE CERTIFICATE SVOManegementCertificate
WITH SUBJECT = 'SVOManegementCertificate',
EXPIRY_DATE = '2026-01-01';

-- Create symmetric key to encrypt data

-- tutaj bEdzie błąd jak spróbujecie odkodować i nie macie 
-- odpowiedniego permission, w takim razie pisać do autora kodu


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

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Users') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 
	CREATE TABLE Users(
	UserID INT PRIMARY KEY IDENTITY (1,1) NOT NULL,
	Password BINARY(64) NOT NULL, 
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	UniversityID INT NOT NULL UNIQUE,
	UniversityIDExpired INT DEFAULT 0
)
END


GO

-- Table Posts

DROP TABLE Posts
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Posts') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 
	CREATE TABLE Posts(
	PostID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	UserID INT  NOT NULL, FOREIGN KEY (UserID) REFERENCES Users(UserID),
	Title VARCHAR(50),
	Content VARCHAR(1000),  --dozwolona długość postu
	Date DATETIMEOFFSET
)
END
GO 

-- Table Calendars

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Calendars') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 
	CREATE TABLE Calendars(
	CalendarID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	UserID INT NOT NULL UNIQUE, FOREIGN KEY (UserID) REFERENCES Users(UserID),
	Type BIT        -- tutaj 0 = na mies�c, 1 = na tydzień
)
END



GO

-- Table Events

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Events') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 
	CREATE TABLE Events(
	EventID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	UserID INT NOT NULL, FOREIGN KEY (UserID) REFERENCES Users(UserID),
	CalendarID int NOT NULL, FOREIGN KEY (CalendarID) REFERENCES Calendars(CalendarID),
	Date DATETIMEOFFSET NOT NULL,
	Type BIT NOT NULL,     -- zajecia Type = 0, rozrywka Type = 1
	Title VARCHAR(30) NOT NULL,
	Description VARCHAR(100)
)
END


GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Coordinates') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 
	CREATE TABLE Coordinates(
	ID int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
    Name NVARCHAR(255),
    Latitude FLOAT,
    Longitude FLOAT
)

END


INSERT INTO Coordinates VALUES ('A2', 51.754669, 19.452695), 
								('A3', 51.75468, 19.453577), 
								('A4', 51.7545, 19.454544), 
								('A5', 51.75423, 19.45483), 
								('A6', 51.754108, 19.454196), 
								('A8', 51.753614, 19.452959), 
								('A9', 51.753597, 19.453082), 
								('A10', 51.75257, 19.453196), 
								('A11', 51.753116, 19.453483), 
								('A12 a', 51.753687, 19.453945), 
								('A12 b', 51.752851, 19.454834), 
								('A13', 51.752481, 19.45377), 
								('A14', 51.753212, 19.455113), 
								('A15', 51.752937, 19.455075), 
								('A16', 51.755036, 19.451494), 
								('A17', 51.755009, 19.450656), 
								('A18', 51.754803, 19.451423), 
								('A19', 51.753747, 19.451902), 
								('A20', 51.753531, 19.451461), 
								('A21', 51.753069, 19.451734), 
								('A22', 51.752511, 19.45255), 
								('A23', 51.75234, 19.452647), 
								('A24', 51.754553, 19.450705), 
								('A26', 51.754145, 19.450323), 
								('A27', 51.753737, 19.45099), 
								('A28', 51.753629, 19.450985), 
								('A30', 51.752577, 19.451327), 
								('A32', 51.753506, 19.449718), 
								('A33', 51.753323, 19.450505), 
								('A34', 51.754416, 19.449899), 
								('A36', 51.753961, 19.454723), 
								('B1', 51.748797, 19.455334), 
								('B2', 51.748906, 19.454685), 
								('B3', 51.748671, 19.453061), 
								('B4', 51.748133, 19.455868), 
								('B5', 51.748069, 19.455428), 
								('B6', 51.747735, 19.453142), 
								('B7', 51.747632, 19.451906), 
								('B8', 51.747603, 19.450868), 
								('B9 Lodex', 51.747309, 19.453784), 
								('B10', 51.747382, 19.455377), 
								('B11', 51.747425, 19.455973), 
								('B12', 51.747181, 19.455575), 
								('B13', 51.746783, 19.45431), 
								('B14', 51.746707, 19.454391), 
								('B15', 51.746437, 19.455355), 
								('B16', 51.746455, 19.453052), 
								('B17', 51.745997, 19.454624), 
								('B18', 51.745983, 19.455649), 
								('B19', 51.747168, 19.4559), 
								('B20', 51.745869, 19.456747), 
								('B21', 51.745633, 19.455619), 
								('B22', 51.745648, 19.454898), 
								('B24', 51.745401, 19.451272), 
								('B25', 51.745396, 19.451289), 
								('B28 Zatoka Sportu', 51.74664, 19.451037), 
								('B29', 51.744728, 19.454056), 
								('C1', 51.744482, 19.448613), 
								('C2', 51.744647, 19.449503), 
								('C3 Akwarium', 51.745421, 19.45001), 
								('C4', 51.745505, 19.449157), 
								('C5', 51.746036, 19.45004), 
								('C6', 51.745744, 19.449039), 
								('C7', 51.745737, 19.448819), 
								('C9', 51.751612, 19.447967), 
								('C11', 51.74662, 19.450225), 
								('C12', 51.747296, 19.45012), 
								('C13', 51.748247, 19.449918), 
								('C14', 51.748698, 19.449894), 
								('C15', 51.74893, 19.449644), 
								('C16', 51.779092, 19.494197), 
								('C17', 51.745471, 19.450016), 
								('C18', 51.744949, 19.449761), 
								('D1', 51.749544, 19.461072), 
								('D3', 51.749302, 19.461474), 
								('D4', 51.749308, 19.46134), 
								('D5', 51.749122, 19.461029), 
								('E1', 51.746865, 19.45969);


GO

INSERT INTO Coordinates( Name, Latitude, Longitude) VALUES('Library', 51.745641, 19.454742)
SELECT * FROM Coordinates
DROP TABLE Coordinates

-- Table Messages

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE ID = OBJECT_ID(N'dbo.Messages') AND OBJECTPROPERTY(ID, N'IsTable') = 1)
BEGIN 
	CREATE TABLE Messages(
	MessageID INT PRIMARY KEY IDENTITY (1, 1) NOT NULL,
	SentByUserID INT NOT NULL, FOREIGN KEY (SentByUserID) REFERENCES Users(UserID),  --id tego co wysłal wiadomość
	SentToUserID INT NOT NULL, FOREIGN KEY (SentToUserID) REFERENCES Users(UserID),  --id tego komu wysłali 
	Date DATETIMEOFFSET,
	Content VARCHAR(100)
)
END



/* *********************************************************************************************************************************************** */
-- H
-- Creating procedures for user log in
/* *********************************************************************************************************************************************** */
GO
--drop procedure HashUserPassword
go

-- procedure to check if user input is secure
CREATE OR ALTER PROCEDURE CheckInput
	@Input VARCHAR(255),
	@Result INT OUTPUT
AS
BEGIN

SET @Result = 0;

    -- Check for common SQL injection patterns
    IF @Input LIKE '%--%' OR      -- Inline comment
       @Input LIKE '%/*%' OR      -- Block comment start
       @Input LIKE '%*/%' OR      -- Block comment end
       @Input LIKE '%''%' OR      -- Single quote
       @Input LIKE '%"%' OR       -- Double quote
       @Input LIKE '%xp_%' OR     -- Extended procedure
       @Input LIKE '%sp_%' OR     -- System stored procedure
       @Input LIKE '%select%' OR  -- SQL keywords (basic)
       @Input LIKE '%insert%' OR
       @Input LIKE '%update%' OR
       @Input LIKE '%delete%' OR
       @Input LIKE '%drop%' OR
       @Input LIKE '%alter%' OR
       @Input LIKE '%exec%' OR
       @Input LIKE '%union%'      -- SQL keywords (advanced)
    BEGIN
        SET @Result = 1;
    END
END
 

GO
CREATE OR ALTER PROCEDURE HashUserPassword
	@Password NVARCHAR(255),
	@Hashed_password BINARY(64) OUTPUT
	WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON;
    SET @Hashed_password = HASHBYTES('SHA2_256', @Password);
END

GO

CREATE OR ALTER PROCEDURE CheckIfUserExists   -- if user exists returns 1, else 0
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


CREATE OR ALTER PROCEDURE UserRegistration
	@UserUniversityID int,
	@UserFirstName nvarchar(30),
	@UserLastName nvarchar(30),
	@UserPassword nvarchar(255),
	@Result int OUTPUT
AS 
BEGIN
	DECLARE @SafeInput INT
	EXEC CheckInput @UserFirstName, @SafeInput OUTPUT
	IF @SafeInput = 1
	BEGIN
		SET @Result = 2
		RETURN
	END
	EXEC CheckInput @UserLastName, @SafeInput OUTPUT
	IF @SafeInput = 1
	BEGIN
		SET @Result = 2
		RETURN
	END

	DECLARE @UserExistsError INT;
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
	IF @@ROWCOUNT > 0
	BEGIN
		SET @Result = 0; --ok
	END
	ELSE 
	BEGIN
		SET @Result = 2; --failed
	END

END
GO

CREATE OR ALTER PROCEDURE UserLogInValidation
    @UserUniversityID int,
    @UserPassword nvarchar(255),
    @Result int OUTPUT
	WITH ENCRYPTION
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
    EXEC HashUserPassword @UserPassword, @UserHashedPassword OUTPUT;
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

CREATE OR ALTER PROCEDURE GetCoordinates
    @Name NVARCHAR(255),
    @Latitude FLOAT OUTPUT,
    @Longitude FLOAT OUTPUT
AS
BEGIN
	
	DECLARE @SafeInput INT
	EXEC CheckInput @Name, @SafeInput OUTPUT
	IF @SafeInput = 1
	BEGIN
		SET @Latitude = 0
		SET @Longitude = 0
		RETURN
	END

    IF EXISTS (SELECT Latitude, Longitude FROM Coordinates WHERE Name = @Name)
    BEGIN
        PRINT 'Coordinates found'
        SELECT @Latitude = Latitude, @Longitude = Longitude FROM Coordinates WHERE Name = @Name
        PRINT 'Latitude: ' + CAST(@Latitude AS NVARCHAR(50))
        PRINT 'Longitude: ' + CAST(@Longitude AS NVARCHAR(50))
    END
    ELSE
    BEGIN
        PRINT 'Coordinates not found'
        SET @Latitude = 0
        SET @Longitude = 0
    END
END




/*DECLARE @Lat FLOAT, @Lng FLOAT;
EXEC GetCoordinates @Name='Library', @Latitude=@Lat OUTPUT, @Longitude=@Lng OUTPUT;
PRINT 'Latitude: ' + CAST(@Lat AS NVARCHAR(50))
PRINT 'Longitude: ' + CAST(@Lng AS NVARCHAR(50))


SELECT * FROM Coordinates

DECLARE @LAN AS FLOAT = 1, @LON AS FLOAT = 1
EXEC GetCoordinates 'Library', @LAN, @LON
PRINT @LAN 
PRINT @LON*/

GO 

CREATE OR ALTER PROCEDURE AddPost
    @UserID INT,
    @Title NVARCHAR(50),
    @Content NVARCHAR(1000),
    @Date DATETIMEOFFSET,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for SQL injection in Title and Content
    DECLARE @SafeInput INT;
    EXEC CheckInput @Title, @SafeInput OUTPUT;
    IF @SafeInput = 1
    BEGIN
        SET @Result = 2; -- Unsafe input detected
        RETURN;
    END

    EXEC CheckInput @Content, @SafeInput OUTPUT;
    IF @SafeInput = 1
    BEGIN
        SET @Result = 2; -- Unsafe input detected
        RETURN;
    END

    -- Insert post into the Posts table
    BEGIN TRY
		DECLARE @user AS INT 
		SET @user = (SELECT TOP 1 UserID FROM Users WHERE UniversityID = @UserID)
		print @user
		print @userId
        INSERT INTO Posts (UserID, Title, Content, Date)
        VALUES (@user, @Title, @Content, @Date);
        SET @Result = 0; -- Success
    END TRY
    BEGIN CATCH
        SET @Result = 1; -- Failure
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE GetAllPosts
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN
        SELECT 
            Posts.PostID, 
            Posts.UserID, 
            Posts.Title, 
            Posts.Content, 
            Posts.Date,
            Users.FirstName,
            Users.LastName
        FROM Posts
        INNER JOIN Users ON Posts.UserID = Users.UserID
        ORDER BY Posts.Date DESC;
    END
END
GO


CREATE OR ALTER PROCEDURE DeletePost
    @PostID INT,
    @UserID INT,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		DECLARE @user AS INT 
		SET @user = (SELECT TOP 1 UserID FROM Users WHERE UniversityID = @UserID)
		print @user
        IF EXISTS (SELECT 1 FROM Posts WHERE PostID = @PostID AND UserID = @user)
        BEGIN
            DELETE FROM Posts WHERE PostID = @PostID AND UserID = @user;
            SET @Result = 0; -- Success
        END
        ELSE
        BEGIN
            SET @Result = 1; -- Post does not exist or user is not the author
        END
    END TRY
    BEGIN CATCH
        SET @Result = 1; -- Failure
    END CATCH
END
GO



CREATE OR ALTER PROCEDURE UpdatePost
    @PostID INT,
    @UserID INT,
	@Title nvarchar(50),
    @Content NVARCHAR(1000),
    @Date DATETIMEOFFSET,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for SQL injection in Content
    DECLARE @SafeInput INT;
    EXEC CheckInput @Content, @SafeInput OUTPUT;
    IF @SafeInput = 1
    BEGIN
        SET @Result = 2; -- Unsafe input detected
        RETURN;
    END

    -- Update post content in the Posts table
    BEGIN TRY
		DECLARE @user AS INT 
		SET @user = (SELECT TOP 1 UserID FROM Users WHERE UniversityID = @UserID)
		print @user
        IF EXISTS (SELECT 1 FROM Posts WHERE PostID = @PostID AND UserID = @user)
        BEGIN
            UPDATE Posts SET Content = @Content, Date = @Date, Title = @Title WHERE PostID = @PostID AND UserID = @user;
            SET @Result = 0; -- Success
        END
        ELSE
        BEGIN
            SET @Result = 1; -- Post does not exist or user is not the author
        END
    END TRY
    BEGIN CATCH
        SET @Result = 1; -- Failure
    END CATCH
END
GO


DECLARE @DATE AS DATETIMEOFFSET = GETDATE()
DECLARE @RES AS INT

--EXEC AddPost 248659, 'Test', 'TIWANNAKMSks', @DATE, @RES OUTPUT
--EXEC UpdatePost 1020, 'JAJHASHHDHF', @DATE, @RES OUTPUT
--EXEC DeletePost 1020, @RES OUTPUT
PRINT @RES

SELECT * FROM Posts

EXEC GetAllPosts
