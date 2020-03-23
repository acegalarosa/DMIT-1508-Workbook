--Practive Transactions
USE [A01-School]
GO

/*
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'SprocName')
    DROP PROCEDURE SprocName
GO
CREATE PROCEDURE SprocName
    -- Parameters here
AS
    -- Body of procedure here
RETURN
GO
*/

--Create a stored procedure called DissolveClub that will acceept a clud id as its parameter. Ensure that the club exists before attempting to dissolve the club. You are to dissolve the club by fiest removing all the members and then removing the club itself.
--   -Delete of rows in the Activity table
--   - Delete of rows in the Club table

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'DissolveClub')
    DROP PROCEDURE DissolveClub
GO

CREATE PROCEDURE DissolveClub