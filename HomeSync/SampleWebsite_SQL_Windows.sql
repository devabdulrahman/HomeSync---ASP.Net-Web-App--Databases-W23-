CREATE DATABASE Project;
USE Project;
GO
CREATE TABLE Company(
	company_id int PRIMARY KEY IDENTITY NOT NULL,
	name varchar(128) NOT NULL,
	field varchar(512) NOT NULL
)
SET IDENTITY_INSERT Company ON
INSERT INTO Company (company_id, name, field) VALUES (1, 'Mentor Graphics', 'Computer hardware')
INSERT INTO Company (company_id, name, field) VALUES (2, 'Siemens', 'Electronics')
INSERT INTO Company (company_id, name, field) VALUES (3, 'Amazon', 'Online shop')
INSERT INTO Company (company_id, name, field) VALUES (4, 'Microsoft', 'Computer Software')
INSERT INTO Company (company_id, name, field) VALUES (5, 'Apple', 'Computer Software')
INSERT INTO Company (company_id, name, field) VALUES (6, 'Volks Wagen', 'Car Manufacturing')
SET IDENTITY_INSERT Company OFF

CREATE TABLE Employee(
	employee_id int PRIMARY KEY IDENTITY NOT NULL,
	username varchar(50) NOT NULL,
	password varchar(50) NOT NULL,
	company_id int NOT NULL,
	FOREIGN KEY(company_id) REFERENCES Company(company_id)
)
SET IDENTITY_INSERT Employee ON
INSERT INTO Employee (employee_id, username, password, company_id) VALUES (1, 'Sherif', '12345', 1)
INSERT INTO Employee (employee_id, username, password, company_id) VALUES (2, 'Ahmed', '12345', 1)
INSERT INTO Employee (employee_id, username, password, company_id) VALUES (3, 'John', '12345', 2)
INSERT INTO Employee (employee_id, username, password, company_id) VALUES (4, 'Ali', '12345', 1)
INSERT INTO Employee (employee_id, username, password, company_id) VALUES (5, 'Amr', '45678', 1)
INSERT INTO Employee (employee_id, username, password, company_id) VALUES (6, 'Marc', '45678', 5)
INSERT INTO Employee (employee_id, username, password, company_id) VALUES (7, 'Slim', '45678', 5)
INSERT INTO Employee (employee_id, username, password, company_id) VALUES (8, 'Salem', '23456', 2)
INSERT INTO Employee (employee_id, username, password, company_id) VALUES (9, 'Haythem', '23456', 3)
INSERT INTO Employee (employee_id, username, password, company_id)VALUES (10, 'Nora', '23456', 3)
SET IDENTITY_INSERT Employee OFF
GO

GO
CREATE PROC ViewEmployee
AS
SELECT username
FROM Employee

go
CREATE PROCEDURE login
    @id INT,
    @first_name NVARCHAR(255),
    @success INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Employee WHERE employee_id = @id AND username = @first_name)
    BEGIN
        SET @success = 1; 
    END
    ELSE
    BEGIN
        SET @success = 0; 
    END
END
