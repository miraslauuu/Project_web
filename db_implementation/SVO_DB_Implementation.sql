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

-- Creating the database for out website

IF DB_ID('SVO_DB_PROJECT_FINAL_VERSION') IS NULL
BEGIN 
	CREATE DATABASE SVO_DB_PROJECT_FINAL_VERSION
END

GO

-- Creating symmetric encryption (ensuring security of database)

USE SVO_DB_PROJECT_FINAL_VERSION
CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = '7#kD9G@f2$Pq&Z!';

-- Create certificate to protect symmetric key
CREATE CERTIFICATE SVOManegementCertificate
WITH SUBJECT = 'SVOManegementCertificate',
EXPIRY_DATE = '2026-01-01';

-- Create symmetric key to encrypt data
CREATE SYMMETRIC KEY SVOManegementSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE SVOManegementCertificate;

-- Open symmetric key
OPEN SYMMETRIC KEY SVOManagementSymmetricKey
DECRYPTION BY CERTIFICATE SVOManagementCertificate;

GO

-- Drop Constarint (may help with changing the db structure)

--here will be dropping of foreign keys and constraints from tables

GO

-- Drop procedures

--in process

GO

-- Drop User sefine table

-- in process

GO

-- Drop and create functions

GO

/* ************************************************************************************************************* */
-- Drop and create tables

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





