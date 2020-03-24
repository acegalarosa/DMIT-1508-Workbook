--Practice Transactions
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
   @ClubID  varchar(10)
AS

	IF @ClubID IS NULL
	BEGIN
		RAISERROR('ClubID is required (cannot be null)',16,1)
	END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT ClubID FROM Club WHERE ClubID = @ClubID)
		BEGIN
			RAISERROR('That Club does not exist', 16, 1)
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION
			--1) Remove members of the club (from Activity)
			DELETE FROM Activity WHERE ClubID = @ClubID
			--Remember to do a check of your global variables to see if there was a problem
			IF @@ERROR <> 0 -- then there is a problem with the delete, no need to check @@ROWCOUNT
			BEGIN
				ROLLBACK TRANSACTION
				RAISERROR('Unable to remove members from the club', 16, 1)
			END
			ELSE
			BEGIN
			--2) Remove from Club
				DELETE FROM Club WHERE ClubID = @ClubID
				IF @@ERROR <> 0 OR @@ROWCOUNT = 0 -- Check if there's a problem
				BEGIN
					ROLLBACK TRANSACTION
					RAISERROR('Unable to delete the club', 16, 1)
				END
				ELSE
				BEGIN
					COMMIT TRANSACTION
				END
			END
		END
	END
RETURN
GO

-- Test my stored procedure
-- SELECT * FROM Club
-- SELECT * FROM Activity
EXEC DissolveClub 'CSS'
EXEC DissolveClub 'NASA1'
EXEC DissolveClub 'WHA?'









	--ELSE
	--BEGIN TRANSACTION
	--DELETE ClubID FROM Activity WHERE ClubID = @ClubID
	--IF ClubID NOT EXISTS (SELECT ClubID FROM Activity WHERE ClubID = @ClubID)

	--BEGIN
	--	RAISERROR('Unable to Delete ClubID' ,16, 1)
	--ROLLBACK TRANSACTION


	




