/* ***********
* File: SchoolTranscript.sql
* Author: Ace Galarosa
* CREATE DATABASE SchoolTranscript
************** */
USE SchoolTranscript
GO
/* === Drop Statements === */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'StudentCourses')
    DROP TABLE StudentCourses
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Courses')
    DROP TABLE Courses
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Students')
    DROP TABLE Students


/* === Create Tables === */
CREATE TABLE Students
(
    StudentID       int
        CONSTRAINT PK_Students_StudentID
            PRIMARY KEY
        IDENTITY(20200001, 1)       NOT NULL,
    GivenName       varchar(50)     NOT NULL,
--    % is a wildcard for zero or more characters (letter, digit, or other character)
--    _ is a wildcard for a single character (letter, digit, or other character)
--   [] are used to represent a range or set of characters that are allowed  
    Surname         varchar(50)
		CONSTRAINT CK_Students_Surname
			CHECK (Surname LIKE '__%')       -- LIKE allows us to do a "pattern-match" of values
--OR        CHECK (Surname LIKE '[a-z][a-z]%') -- two letters plus any other characters
--								  \1/  \1/
--			Positive match for 'Fred'
--			Positive match for 'Wu'
--			Positive match for 'F'
--			Negative match for '2udor'
							        NOT NULL,
    DateOfBirth     datetime
		CONSTRAINT CK_Students_DateOfBirth
			CHECK (DateOfBirth < GETDATE()) -- GETDATE is a function to get the current date
							        NOT NULL,
    Enrolled        bit             
        CONSTRAINT DF_Students_Enrolled
            DEFAULT (1)             NOT NULL
)

CREATE TABLE Courses
(
    Number          varchar(10)
        CONSTRAINT PK_Courses_Number
            PRIMARY KEY             NOT NULL,
    [Name]          varchar(50)     NOT NULL,
    Credits         decimal(3, 1)
		CONSTRAINT CK_Courses_Credits
			CHECK  (Credits > 0 AND Credits <= 6)
								    NOT NULL,
    [Hours]         tinyint
		CONSTRAINT CK_Courses_Hours
			CHECK ([Hours] BETWEEN 15 AND 180) -- BETWEEN operator is inclusive
--OR        CHECK ([Hours] >= 15 AND [Hours] <= 180)
							        NOT NULL,
    Active          bit
        CONSTRAINT DF_Courses_Active
            DEFAULT (1)             NOT NULL,
    Cost            money
		CONSTRAINT CK_Courses_Cost
			CHECK (Cost >= 0)     
								    NOT NULL
)

CREATE TABLE StudentCourses
(
    StudentID         int
        CONSTRAINT FK_StudentCourses_StudentID_Students_StudentID
            FOREIGN KEY REFERENCES Students(StudentID)
                                    NOT NULL,
    CourseNumber    varchar(10)
        CONSTRAINT FK_StudentCourses_CourseNumber_Courses_Number
            FOREIGN KEY REFERENCES Courses(Number)
                                    NOT NULL,
    [Year]          tinyint         NOT NULL,
    Term            char(3)         NOT NULL,
    FinalMark       tinyint             NULL,
    [Status]        char(1)
		CONSTRAINT CK_StudentCourses_Status
			CHECK ([Status] = 'E' OR
				   [Status] = 'C' OR
				   [Status] = 'W')
--OR        CHECK ([Status] IN ('E', 'C', 'W'))
					     	        NOT NULL,
    -- Table-level constraint for composite keys
    CONSTRAINT PK_StudentCourses_StudentID_CourseNumber
        PRIMARY KEY (StudentID, CourseNumber),
	-- Table-level constraint involving more that one column
	CONSTRAINT CK_StudentCourses_FinalMark_Status
		CHECK (([Status] = 'C' AND FinalMark IS NOT NULL)
			  OR
			  ([Status] IN ('E', 'W') AND FinalMark IS NULL))
)
