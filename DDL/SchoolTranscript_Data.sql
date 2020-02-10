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

INSERT INTO Students(GivenName, Surname, DateOfBirth) -- notice no Enrolled column
VALUES ('Ace', 'Ga', '19900912 10:34:09 AM')

SELECT * FROM Courses

INSERT INTO Courses(Number, [Name], Credits, [Hours], Cost)
VALUES ('1508', 'Database Fundamentals', '3', '30', '900')