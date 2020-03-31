-- Stored Procedures (Sprocs)
-- Validating Parameter Values
-- We can validate parameter values using IF/ELSE statements. An IF/ELSE statement is called a "flow-control" statement because
-- it controls whether or not another statement (or statement block) will execute. The grammar of the IF/ELSE statement is as follows:
-- IF (Conditional_Expression)
--   Statement-or-Statement-Block -- TRUE side
-- ELSE
--   Statement-or-Statement-Block -- FALSE side

-- Where the Conditional_Expression is some kind of expression that will result in a value of TRUE or FALSE.

USE [A01-School]
GO

/* ********* SPROC Template ************
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'SprocName')
    DROP PROCEDURE SprocName
GO
CREATE PROCEDURE SprocName
    -- Parameters here
AS
    -- Body of procedure here
RETURN
GO
************************************** */


-- 1. Create a stored procedure called AddClub that will add a new club to the database. (No validation is required).
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'AddClub')
    DROP PROCEDURE AddClub
GO
-- sp_help Club -- Running the sp_help stored procedure will give you information about a table, sproc, etc.
CREATE PROCEDURE AddClub
    -- Parameters here
    @ClubId     varchar(10),
    @ClubName   varchar(50)
AS
    -- Body of procedure here
    -- Should put some validation here.....

    INSERT INTO Club(ClubId, ClubName)
    VALUES (@ClubId, @ClubName)
RETURN
GO

--Demo/Test my stored procedure
EXEC AddClub 'CLUB', 'Central Library of Unused Books' -- Testing with "good" data
-- Imagine that the stored procedure is called with !bad! data
EXEC AddClub NULL, 'Gotcha'
EXEC AddClub 'OOPS', NULL
GO


-- 1.b. Modify the AddClub procedure to ensure that the club name and id are actually supplied. Use the RAISERROR() function to report that this data is required.
ALTER PROCEDURE AddClub
    -- Parameters here
    @ClubId     varchar(10),
    @ClubName   varchar(50)
AS
    -- Body of procedure here
	-- I validate by finding out if the data is poor. If so, then I report the problem.
    IF @ClubId IS NULL OR @ClubName IS NULL
    BEGIN
        RAISERROR('Club ID and Name are required', 16, 1)
		-- The 16 is the error number (we are basically constrained to a range of error numbers).
		-- The 1 is the severity of the error
		-- We can always use the 16, 1
    END
    ELSE -- Otherwise, I proceed to process the data.
    BEGIN
        INSERT INTO Club(ClubId, ClubName)
        VALUES (@ClubId, @ClubName)
    END
RETURN
GO

-- Imagine that the stored procedure is called with !bad! data
EXEC AddClub NULL, 'Gotcha'
EXEC AddClub 'OOPS', NULL
GO

-- 2. Make a stored procedure that will find a club based on the first two or more characters of the club's ID. Call the procedure "FindStudentClubs"
-- The following stored procedure does the query, but without validation
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'FindStudentClubs')
    DROP PROCEDURE FindStudentClubs
GO
CREATE PROCEDURE FindStudentClubs
    @PartialID      varchar(10)
AS
    -- Body of procedure here
    SELECT  ClubID, ClubName
    FROM    Club
    WHERE   ClubId LIKE @PartialID + '%'
RETURN
GO

EXEC FindStudentClubs NULL  -- What do you predict the result will be?
EXEC FindStudentClubs ''    -- What do you predict the result will be?
GO


ALTER PROCEDURE FindStudentClubs
    @PartialID      varchar(10)
AS
    -- Body of procedure here
    IF @PartialID IS NULL OR LEN(@PartialID) < 2
    BEGIN   -- {
        RAISERROR('The partial ID must be two or more characters', 16, 1)
        -- The 16 is the error number and the 1 is the severity
    END     -- }
    SELECT  ClubID, ClubName
    FROM    Club
    WHERE   ClubId LIKE @PartialID + '%'
RETURN
GO
EXEC FindStudentClubs ''    -- What do you predict the result will be?
GO
-- The above change did not stop the select.
-- To fix it, we need the ELSE side of the IF validation
ALTER PROCEDURE FindStudentClubs -- Third time's the charm ;)
    @PartialID      varchar(10)
AS
    -- Body of procedure here
    IF @PartialID IS NULL OR LEN(@PartialID) < 2
    BEGIN   -- {
        RAISERROR('The partial ID must be two or more characters', 16, 1)
        -- The 16 is the error number and the 1 is the severity
    END     -- }
    ELSE
    BEGIN
        SELECT  ClubID, ClubName
        FROM    Club
        WHERE   ClubId LIKE @PartialID + '%'
    END
RETURN
GO
EXEC FindStudentClubs ''    -- What do you predict the result will be?
EXEC FindStudentClubs 'NA'  -- Should give good results with no errors.


-- 3. Create a stored procedure that will change the mailing address for a student. Call it ChangeMailingAddress.
--    Make sure all the parameter values are supplied before running the UPDATE (ie: no NULLs).
-- sp_help Student
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'ChangeMailingAddress')
    DROP PROCEDURE ChangeMailingAddress
GO
CREATE PROCEDURE ChangeMailingAddress
    -- Parameters here
    @StudentId  int,
    @Street     varchar(35), -- Model the type/size of parameters to match what's needed in the database tables
    @City       varchar(30),
    @Province   char(2),
    @PostalCode char(6)
AS
    -- Body of procedure here
    -- Validate
    IF (@StudentId IS NULL OR @Street IS NULL OR @City IS NULL OR @Province IS NULL or @PostalCode IS NULL)
    BEGIN --  { A...
        RAISERROR('All parameters require a value (NULL is not accepted)', 16, 1)
    END   -- ...A }
    ELSE
    BEGIN -- { B...
        UPDATE  Student
        SET     StreetAddress = @Street
               ,City = @City
               ,Province = @Province
               ,PostalCode = @PostalCode
        WHERE   StudentId = @StudentId 
    END   -- ...B }
RETURN
GO

EXEC ChangeMailingAddress '199899200', 'B1 L7', 'Taytay',  'AB',  'T6W0K2'
GO


-- 4. Create a stored procedure that allows us to make corrections to a student's name. It should take in the student ID and the corrected name (first/last) of the student. Call the stored procedure CorrectStudentName. Validate that the student exists before attempting to change the name.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'CorrectStudentName')
    DROP PROCEDURE CorrectStudentName
GO
CREATE PROCEDURE CorrectStudentName
    @StudentId      int,
    @FirstName      varchar(25),
    @LastName       varchar(35)
AS
    IF @StudentId IS NULL OR @FirstName IS NULL OR @LastName IS NULL
        RAISERROR('All parameters are required.', 16, 1)
    ELSE IF NOT EXISTS (SELECT StudentID FROM Student WHERE StudentID = @StudentId)
	    --The EXISTS() function will return true if there are 1 or more rows,
		-- otherwise it will return false.
        RAISERROR('That student id does not exist', 16, 1)
    ELSE
        UPDATE  Student
        SET     FirstName = @FirstName,
                LastName = @LastName
        WHERE   StudentID = @StudentId
RETURN
GO

EXEC CorrectStudentName '199912010', 'Ace', 'Galarosa'


-- 5. Create a stored procedure that will remove a student from a club. Call it RemoveFromClub.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'RemoveFromClub')
    DROP PROCEDURE RemoveFromClub
GO

CREATE PROCEDURE RemoveFromClub
   @StudentID   int
AS
   IF @StudentID IS NULL
      RAISERROR('The StudentID is required.', 16, 1)
   ELSE IF NOT EXISTS (SELECT StudentID FROM Activity WHERE StudentID = @StudentID)
      RAISERROR('The StudentID does not exist', 16, 1)
   ELSE
      DELETE Activity
	  WHERE  StudentID = @StudentID
RETURN
GO
  
EXEC RemoveFromClub '199912010'
GO


-- Query-based Stored Procedures
-- 6. Create a stored procedure that will display all the staff and their position in the school.
--    Show the full name of the staff member and the description of their position.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'DisplayStaffPosition')
    DROP PROCEDURE DisplayStaffPosition
GO

CREATE PROCEDURE DisplayStaffPosition
AS
   SELECT FirstName + ' ' + S.LastName AS 'Staff Name',
          P.PositionDescription AS 'Position'
   FROM   Staff AS S
      INNER JOIN Position AS P
	    ON P.PositionID = S.PositionID
RETURN
GO

EXEC DisplayStaffPosition 
GO


-- 7. Display all the final course marks for a given student. Include the name and number of the course
--    along with the student's mark.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'FinalCourseMarks')
    DROP PROCEDURE FinalCourseMarks
GO

CREATE PROCEDURE FinalCourseMarks
   @StudentID  int
AS
	IF @StudentID IS NULL
		BEGIN
			 RAISERROR('Student ID is required', 16, 1)
		END

    ELSE IF NOT EXISTS (SELECT StudentID FROM Student WHERE StudentID = @StudentID)
		BEGIN
			 RAISERROR('Student ID does not exist', 16, 1)
		END

    ELSE
	    BEGIN
		   SELECT S.FirstName + ' ' + S.LastName AS 'Student Name',
				  C.CourseID AS 'Course ID',
				  C.CourseName AS 'CourseName',
				  R.Mark AS 'Student Mark'
		   FROM   Student AS S
			  INNER JOIN Registration AS R
				ON S.StudentID = R.StudentID
			  INNER JOIN Course AS C
				ON C.CourseID = R.CourseID
		   WHERE S.StudentID = @StudentID
        END
RETURN
GO

EXEC FinalCourseMarks '199899200'
GO


-- 8. Display the students that are enrolled in a given course on a given semester.
--    Display the course name and the student's full name and mark.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'StudentsEnrolled')
    DROP PROCEDURE StudentsEnrolled
GO

CREATE PROCEDURE StudentsEnrolled
    @CourseID  char(7),
	@Semester  char(5)
AS
   IF @CourseID IS NULL OR @Semester IS NULL
	   BEGIN
		   RAISERROR('All parameters are required.', 16, 1)
	   END

   ELSE IF NOT EXISTS (SELECT CourseID FROM Registration WHERE CourseID = @CourseID)
	   BEGIN
		   RAISERROR('That CourseID does not exist', 16, 1)
	   END

   ELSE IF NOT EXISTS (SELECT Semester FROM Registration WHERE Semester = @Semester)
	   BEGIN
		   RAISERROR('That Semester does not exist', 16, 1)
	   END

   ELSE
	   BEGIN
		   SELECT C.CourseName AS 'Course Name',
				  S.FirstName + ' ' + S.LastName AS 'Student Name',
				  R.Mark AS 'Mark'
		   FROM   Course AS C
			  INNER JOIN Registration AS R
				ON C.CourseID = R.CourseID
			  INNER JOIN Student AS S
				ON S.StudentID = R.StudentID
		   WHERE R.CourseID = @CourseID AND R.Semester = @Semester
	   END
RETURN
GO

EXEC StudentsEnrolled 'DMIT152', '2004J'
GO


-- 9. The school is running out of money! Find out who still owes money for the courses they are enrolled in.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'ListOutstandingBalances')
    DROP PROCEDURE ListOutstandingBalances
GO
CREATE PROCEDURE ListOutstandingBalances
AS
    SELECT  FirstName + ' ' + LastName AS 'Student', BalanceOwing
    FROM    Student
    WHERE   BalanceOwing > 0

RETURN
GO

EXEC ListOutstandingBalances

