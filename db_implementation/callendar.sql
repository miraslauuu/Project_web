use SVO_DB_PROJECT_FINAL_VERSION

go
CREATE PROCEDURE AddEvent
    @UserID INT,
    @CalendarID INT,
    @Date DATETIMEOFFSET,
    @Type BIT,
    @Title NVARCHAR(30),
    @Description NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Events (UserID, CalendarID, Date, Type, Title, Description)
        VALUES (@UserID, @CalendarID, @Date, @Type, @Title, @Description);

        SELECT 'Event added successfully' AS Message;
    END TRY
    BEGIN CATCH
        -- Error handling
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
go