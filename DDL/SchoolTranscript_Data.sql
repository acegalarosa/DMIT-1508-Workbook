/* **********
* SchoolTranscript_Data.sql
* Ace Galarosa
************* */
USE SchoolTranscript
GO

INSERT INTO Students(GivenName, Surname, DateOfBirth) -- notice no Enrolled column
VALUES ('Ace', 'Galarosa', '19900912 10:34:09 AM'),
	   ('Charles', 'Kuhn', '19990806 00:00:00 AM'),
	   ('Flenn', 'Morrison', '19480403 09:10:05 AM'),
	   ('Earl', 'Fowler', '19840801 13:00:00 PM'),
	   ('Sherri', 'Caldwell', '19450405 18:09:00 PM')


SELECT * FROM Students

/* 
INSERT INTO Students(GivenName, Surname, DateOfBirth) -- notice no Enrolled column
VALUES ('Ace', 'G', '19900912 10:34:09 AM')
*/

SELECT  Number, [Name], Credits, [Hours]
FROM	Courses
WHERE   [Name] LIKE '%Fundamentals%'




INSERT INTO Courses(Number, [Name], Credits, [Hours], Cost)
VALUES ('DMIT-1508', 'Database Fundamentals', 3.0, 60, 750),
	   ('CPSC-1012', 'Programming Fundamentals', 3.0, 60, 750),
	   ('DMIT-1720', 'OOP Fundamentals', 3.0, 60, 750),
	   ('DMIT-2210', 'Agile Development', 4.5, 90, 850),
	   ('DMIT-1718', 'Software Testing', 4.5, 90, 850)

SELECT * FROM Courses	   