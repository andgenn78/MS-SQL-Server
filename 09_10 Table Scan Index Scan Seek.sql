DROP TABLE IF EXISTS Application.CountriesCount;

CREATE TABLE Application.CountriesCount(Continent VARCHAR(50), CountyCount INT);

INSERT INTO Application.CountriesCount
SELECT Application.Countries.Continent, COUNT(*)
FROM Application.Countries
GROUP BY Application.Countries.Continent;

SELECT * FROM Application.CountriesCount;


--table scan 
SELECT CountyCount
FROM Application.CountriesCount
WHERE Continent = 'Asia';

---information about indexes
exec sp_helpindex 'Application.CountriesCount';

exec sp_helpindex 'Application.People';

--clustered index scan
SELECT CountryName
FROM Application.Countries
WHERE Continent = 'Asia';

exec sp_helpindex 'Application.Countries';

--index seek

DECLARE @CName NVARCHAR(60) = 'Korea'; 
SELECT CountryID
FROM Application.Countries
WHERE CountryName = @CName;

--Key Lookup
SELECT Continent
FROM Application.Countries 
WHERE CountryName = 'Korea';

--creating a heap
SELECT * INTO Application.CountriesCount_Index
FROM Application.CountriesCount

CREATE INDEX IX_CountryCount_ContinentIndex ON Application.CountriesCount_Index (Continent);

--Rid Lookup
SELECT CountyCount
FROM Application.CountriesCount_Index with (index(IX_CountryCount_ContinentIndex))
WHERE Continent = 'Asia';

--Table scan becaues it's faster
SELECT CountyCount
FROM Application.CountriesCount_Index--- with (index(IX_CountryCount_ContinentIndex))
WHERE Continent = 'Asia';


exec sp_helpindex 'Sales.Invoices';

--2 indexes per query
SELECT InvoiceID
FROM Sales.Invoices
WHERE SalespersonPersonID = 16 and CustomerID = 57;

--2 indexes + keylookup
SELECT InvoiceID, InvoiceDate
FROM Sales.Invoices
WHERE SalespersonPersonID = 16 and CustomerID = 57;

select OrderID, OrderDate,  COALESCE([PickingCompletedWhen], OrderDate), [PickingCompletedWhen]
from [Sales].[Orders]
WHERE CustomerID = 90;

select OrderID, OrderDate,  COALESCE([PickingCompletedWhen], OrderDate), [PickingCompletedWhen]
from [Sales].[Orders]
WHERE CustomerID = 90
	AND COALESCE([PickingCompletedWhen], OrderDate) < '2014-01-01';

select OrderID, OrderDate,  COALESCE([PickingCompletedWhen], OrderDate), [PickingCompletedWhen]
from [Sales].[Orders]
WHERE CustomerID = 90
	AND (([PickingCompletedWhen] IS NULL AND OrderDate < '2014-01-01')
			OR 
		([PickingCompletedWhen] < '2014-01-01')
	);


select OrderID, OrderDate,  COALESCE([PickingCompletedWhen], OrderDate), [PickingCompletedWhen]
from [Sales].[Orders]
WHERE CustomerID = 90
	AND ISNULL([PickingCompletedWhen], OrderDate) < '2014-01-01';


Set statistics io,time on

--exec sp_helpindex 'Sales.Invoices'

--nested loops + parallelism
SELECT Staff.PersonID, Staff.FullName, Invoice.InvoiceID, Invoice.InvoiceDate
FROM Application.People	AS Staff
	JOIN Sales.Invoices AS Invoice 
		ON Invoice.SalespersonPersonID = Staff.PersonID
WHERE Staff.PersonID = 16;

--nested loops
SELECT Staff.PersonID, Staff.FullName, Invoice.InvoiceID
FROM Application.People	AS Staff
	JOIN Sales.Invoices AS Invoice 
		ON Invoice.SalespersonPersonID = Staff.PersonID
WHERE Invoice.SalespersonPersonID = 16;


--hash match
SELECT Staff.PersonID, Staff.FullName, Invoice.InvoiceID, Invoice.InvoiceDate
FROM Application.People	AS Staff
	JOIN Sales.Invoices AS Invoice 
		ON Invoice.SalespersonPersonID = Staff.PersonID;

--hash match left join
SELECT Staff.PersonID, Staff.FullName, Invoice.InvoiceID, Invoice.InvoiceDate
FROM Application.People	AS Staff
	LEFT JOIN Sales.Invoices AS Invoice 
		ON Invoice.SalespersonPersonID = Staff.PersonID;


DROP TABLE  Sales.InvoiceLines_CLI;

SELECT * INTO Sales.InvoiceLines_CLI
FROM Sales.InvoiceLines


SELECT * FROM Sales.InvoiceLines_CLI;

CREATE CLUSTERED INDEX CL_InvoiceLines on Sales.InvoiceLines_CLI (InvoiceId);

---REATE CLUSTERED INDEX CL_InvoiceLines on Sales.InvoiceLines_CLI (InvoiceId, InvoiceLineId);
ALTER TABLE [Sales].[InvoiceLines_CLI] ADD  CONSTRAINT [PK_Sales_InvoiceLines_CLI] PRIMARY KEY NONCLUSTERED 
(
	[InvoiceLineID] ASC
);

ALTER TABLE [Sales].[InvoiceLines_CLI] ADD  CONSTRAINT [PK_Sales_InvoiceLines_CLI] PRIMARY KEY NONCLUSTERED 
(
	[InvoiceLineID] ASC
);

exec sp_helpindex 'Sales.Invoices'
exec sp_helpindex 'Sales.InvoiceLines_CLI'

--MERGE example
SELECT Invoice.InvoiceID, Invoice.InvoiceDate, Detail.InvoiceDate
FROM  Sales.Invoices AS Invoice
	JOIN Sales.Invoices AS Detail 
		ON Invoice.InvoiceId = Detail.InvoiceId;

---hash join
SELECT Invoice.InvoiceID, Invoice.InvoiceDate, Detail.Quantity, Detail.UnitPrice
FROM  Sales.Invoices AS Invoice
	JOIN Sales.InvoiceLines_CLI AS Detail 
		ON Invoice.InvoiceId = Detail.InvoiceId;

--sort
SELECT Continent, CountryName, CountryID
FROM Application.Countries
ORDER BY Continent;

---no sort because clustered index
SELECT Continent, CountryName, CountryID
FROM Application.Countries
ORDER BY CountryID;

--index seek + parallel sort
SELECT Staff.PersonID, Staff.FullName, Invoice.InvoiceID, Invoice.InvoiceDate
FROM Application.People	AS Staff
	JOIN Sales.Invoices AS Invoice 
		ON Invoice.SalespersonPersonID = Staff.PersonID
WHERE Invoice.SalespersonPersonID = 16
ORDER BY Invoice.InvoiceDate;

--top + sort
SELECT TOP 50 Staff.PersonID, Staff.FullName, Invoice.InvoiceID, Invoice.InvoiceDate
FROM Application.People	AS Staff
	JOIN Sales.Invoices AS Invoice 
		ON Invoice.SalespersonPersonID = Staff.PersonID
WHERE Invoice.SalespersonPersonID = 16
ORDER BY Invoice.InvoiceDate;

SELECT Staff.PersonID, Staff.FullName, Invoice.InvoiceID, Invoice.InvoiceDate
FROM Application.People	AS Staff
	JOIN Sales.Invoices AS Invoice 
		ON Invoice.SalespersonPersonID = Staff.PersonID
WHERE Invoice.SalespersonPersonID = 16
ORDER BY Invoice.InvoiceDate
	OFFSET 100 ROWS 
	FETCH NEXT 50 ROWS ONLY;