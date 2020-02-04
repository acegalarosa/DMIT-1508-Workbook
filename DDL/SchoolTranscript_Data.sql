/* **********
* SchoolTranscript_Data.sql
* Ace Galarosa
************* */
USE SchoolTranscript
GO

INSERT INTO Students(GivenName, Surname, DateOfBirth) -- notice no Enrolled column
VALUES ('Ace', 'Galarosa', '19900912 10:34:09 AM')

SELECT * FROM Students