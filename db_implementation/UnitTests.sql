-- file for testing procedures and new features in database

USE SVO_DB_PROJECT_FINAL_VERSION


-- UserLogInValidation PROCEDURE

DECLARE @RES INT
EXEC UserLogInValidation 123, 'haslo', @RES OUTPUT
PRINT CAST(@RES AS VARCHAR(10))
GO

-- CheckInput PROCEDURE

DECLARE @Input AS VARCHAR(255) = 'SELECT * FROM USERS'
DECLARE @Result INT
EXEC CheckInput @Input, @Result OUTPUT
PRINT @Result
GO
-- Registration procedure
DECLARE @RES INT
EXEC UserRegistration 232299, 'SELECT', 'TEST', 'TEST', @RES OUTPUT
PRINT @RES

SET NOCOUNT OFF
SELECT * FROM USERS