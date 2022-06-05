----LOG C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA
----simple
----full

CREATE TABLE #T(ID INT NULL);

CREATE TABLE #T2(ID INT NULL);

SELECT * FROM tempdb.dbo.SYSOBJECTS where ID = OBJECT_ID(N'TEMPDB.[DBO].[#T]');

SELECT * FROM tempdb.dbo.SYSOBJECTS where ID = OBJECT_ID(N'TEMPDB.[DBO].[#T2]');

----

SET NOCOUNT ON;
USE tempdb;

IF OBJECT_ID('dbo.proc1', 'P') IS NOT NULL DROP PROC dbo.proc1;
IF OBJECT_ID('dbo.proc2', 'P') IS NOT NULL DROP PROC dbo.proc2;
GO

CREATE PROC dbo.proc1
AS

CREATE TABLE #T1(col1 INT NOT NULL);
INSERT INTO #T1 VALUES(1);
SELECT * FROM #T1;

EXEC dbo.proc2;
GO

CREATE PROC dbo.proc2
AS

CREATE TABLE #T1(col1 INT NULL);
INSERT INTO #T1 VALUES(2);
SELECT * FROM #T1;
GO


-----

ALTER PROC dbo.proc2
AS

CREATE TABLE #T1(col1 INT NULL, col2 INT NOT NULL);
INSERT INTO #T1 VALUES(2, 2);
SELECT * FROM #T1;
GO

----

EXEC dbo.proc1; --- error Column name or number of supplied values does not match table definition.

EXEC dbo.proc2;

EXEC dbo.proc1; --- ok 

---

EXEC sp_recompile 'dbo.proc2';
EXEC dbo.proc1;---not ok, becaues the same name of temp tables


---
IF OBJECT_ID('dbo.proc1', 'P') IS NOT NULL DROP PROC dbo.proc1;
IF OBJECT_ID('dbo.proc2', 'P') IS NOT NULL DROP PROC dbo.proc2;


----

DECLARE @column_defs AS VARCHAR(1000), @insert AS VARCHAR(1000);
SET @column_defs = 'col1 INT, col2 DECIMAL(10,2)';
SET @insert = 'INSERT INTO #T VALUES(10, 20, 30)';

IF EXISTS (SELECT * FROM tempdb.dbo.SYSOBJECTS where ID = OBJECT_ID(N'TEMPDB.[DBO].[#T]'))
	DROP TABLE #T;

---In the outer level, create temp #T with a single summy column
CREATE TABLE #T(dummycol INT);

SET NOCOUNT ON;
USE tempdb;

IF OBJECT_ID('dbo.TestCaching', 'P') IS NOT NULL
	DROP PROC dbo.TestCaching;
GO

CREATE PROC dbo.TestCaching
AS
CREATE TABLE #T1(n INT, filler CHAR(2000));

INSERT INTO #T1 VALUES
	(1, 'a'),
	(2, 'a'),
	(3, 'a');
GO

---

CREATE TABLE #T(ID INT NULL);

DECLARE @column_defs AS VARCHAR(1000), @insert AS VARCHAR(1000);
SET @column_defs = 'col1 INT, col2 DECIMAL(10,2), dummycol INT';
SET @insert = 'INSERT INTO #T VALUES(10, 20, 30)';

EXEC('
ALTER TABLE #T ADD ' + @column_defs + ';
ALTER TABLE #T DROP COLUMN dummycol;
EXEC(''' + @insert + ''')');
GO

--- Back to the outer level, access #T in a new batch
SELECT * FROM #T;

DROP TABLE #T;



---- 
CREATE PROC dbo.TestCaching
AS
CREATE TABLE #T1(n INT, filler CHAR(2000));

INSERT INTO #T1 VALUES
  (1, 'a'),
  (2, 'a'),
  (3, 'a');
GO


ALTER PROC dbo.TestCaching
AS

CREATE TABLE #T1(n INT, filler CHAR(2000));
CREATE UNIQUE INDEX idx1 ON #T1(n);

INSERT INTO #T1 VALUES
  (1, 'a'),
  (2, 'a'),
  (3, 'a');
GO



---

EXEC dbo.TestCaching;
SELECT name FROM tempdb.sys.objects WHERE name LIKE '#%';

----


ALTER PROC dbo.TestCaching
AS

CREATE TABLE #T1(n INT, filler CHAR(2000), UNIQUE(n));

INSERT INTO #T1 VALUES
  (1, 'a'),
  (2, 'a'),
  (3, 'a');
GO 


EXEC dbo.TestCaching;
SELECT name FROM tempdb.sys.objects WHERE name LIKE '#%';


##Global

#Local



CREATE TABLE ##T(col1 INT);
INSERT INTO ##T VALUES(1);



USE master;
IF OBJECT_ID('dbo.CreateGlobals', 'P') IS NOT NULL DROP PROC dbo.CreateGlobals
GO
CREATE PROC dbo.CreateGlobals
AS
CREATE TABLE ##Globals
(
  varname sysname NOT NULL PRIMARY KEY,
  val     SQL_VARIANT NULL
);
GO

---run proc at sql server starup
EXEC dbo.sp_procoption 'dbo.CreateGlobals', 'startup', 'true';


INSERT INTO ##Globals VALUES('var1', CAST('abc' AS VARCHAR(10)));
SELECT * FROM ##Globals;


----
----


Declare @MyTableVar table
     (Id int primary key,
      Lookup varchar(15))

Insert @MyTableVar values (1, '1Q2000')
Insert @MyTableVar values (2, '2Q2000')
Insert @MyTableVar values (3, '3Q2000')

Select * from @MyTableVar
Go


----table var - not for big table


DECLARE @EmployeeLocal TABLE
(
 EmpID int,
 EmpName varchar(100), 
 EmpAddress varchar(300),
 EmpDOB Date
)
 
INSERT INTO @EmployeeLocal values ( 235, 'John Doe','Minneapolis, MN', '1975-03-01');
 
SELECT * FROM @EmployeeLocal
GO



--------------

USE AdventureWorks2017;
--initialise out timer
DECLARE @log TABLE (TheOrder INT IDENTITY(1,1), 
WhatHappened varchar(200), WHENItDid  Datetime2 DEFAULT GETDATE())
 

IF EXISTS (SELECT * FROM tempdb.dbo.SYSOBJECTS where ID = OBJECT_ID(N'TEMPDB.[DBO].[#employees]'))
	DROP TABLE #employees;

CREATE TABLE #employees
  (Employee NATIONAL CHARACTER VARYING(500) NOT NULL);
----start of timing
INSERT INTO @log(WhatHappened) 
SELECT 'Starting My_Section_of_code'--place at the start
 
--start by using a table variable for workpad
DECLARE @WorkPad TABLE
  (NameOfEmployee NATIONAL CHARACTER VARYING(100) NOT NULL,
BusinessEntityID INT PRIMARY KEY NOT NULL,
NationalIDNumber NATIONAL CHARACTER VARYING(15) NOT NULL);
 
INSERT INTO @WorkPad
  (NameOfEmployee, BusinessEntityID, NationalIDNumber)
  SELECT Coalesce(Person.Title + ' ', '') + Person.FirstName + ' '
         + Coalesce(Person.MiddleName + ' ', '') + Person.LastName
         + ': ' + Coalesce(Person.Suffix, '') + Employee.JobTitle,
    Employee.BusinessEntityID, Employee.NationalIDNumber
    FROM HumanResources.Employee
      INNER JOIN Person.Person
        ON Person.BusinessEntityID = Employee.BusinessEntityID
....



;WITH Sales_CTE (SalesPersonID, NumberOfOrders)  
AS  
(  
    SELECT SalesPersonID, COUNT(*)  
    FROM Sales.SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  
    GROUP BY SalesPersonID  
)  
SELECT AVG(NumberOfOrders) AS "Average Sales Per Person"  
FROM Sales_CTE;  
GO

---
WITH Sales_CTE (SalesPersonID, TotalSales, SalesYear)  
AS  
-- Define the first CTE query.  
(  
    SELECT SalesPersonID, SUM(TotalDue) AS TotalSales, YEAR(OrderDate) AS SalesYear  
    FROM Sales.SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  
       GROUP BY SalesPersonID, YEAR(OrderDate)  
  
)  
,   -- Use a comma to separate multiple CTE definitions.  
  
-- Define the second CTE query, which returns sales quota data by year for each sales person.  
Sales_Quota_CTE (BusinessEntityID, SalesQuota, SalesQuotaYear)  
AS  
(  
       SELECT BusinessEntityID, SUM(SalesQuota)AS SalesQuota, YEAR(QuotaDate) AS SalesQuotaYear  
       FROM Sales.SalesPersonQuotaHistory  
       GROUP BY BusinessEntityID, YEAR(QuotaDate)  
)  
  
-- Define the outer query by referencing columns from both CTEs.  
SELECT SalesPersonID  
  , SalesYear  
  , FORMAT(TotalSales,'C','en-us') AS TotalSales  
  , SalesQuotaYear  
  , FORMAT (SalesQuota,'C','en-us') AS SalesQuota  
  , FORMAT (TotalSales -S




  -- Create an Employee table.  
CREATE TABLE dbo.MyEmployees  
(  
EmployeeID smallint NOT NULL,  
FirstName nvarchar(30)  NOT NULL,  
LastName  nvarchar(40) NOT NULL,  
Title nvarchar(50) NOT NULL,  
DeptID smallint NOT NULL,  
ManagerID int NULL,  
 CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC)   
);  
-- Populate the table with values.  
INSERT INTO dbo.MyEmployees VALUES   
 (1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL)  
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)  
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)  
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)  
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)  
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)  
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)  
,(16,  N'David',N'Bradley', N'Marketing Manager', 4, 273)  
,(23,  N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);  



WITH DirectReports(ManagerID, EmployeeID, Title, EmployeeLevel) AS   
(  
    SELECT ManagerID, EmployeeID, Title, 0 AS EmployeeLevel  
    FROM dbo.MyEmployees   
    WHERE ManagerID IS NULL  
    UNION ALL  
    SELECT e.ManagerID, e.EmployeeID, e.Title, EmployeeLevel + 1  
    FROM dbo.MyEmployees AS e  
        INNER JOIN DirectReports AS d  
        ON e.ManagerID = d.EmployeeID   
)  
SELECT ManagerID, EmployeeID, Title, EmployeeLevel   
FROM DirectReports  
WHERE EmployeeLevel <= 2 ;  
GO