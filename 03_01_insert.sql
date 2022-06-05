USE WideWorldImporters;

INSERT INTO Warehouse.Colors
	(ColorId, ColorName, LastEditedBy)
VALUES
	(NEXT VALUE FOR Sequences.ColorID, 'Ohra', 1);

Declare 
	@colorId INT, 
	@LastEditedBySystemUser INT,
	@SystemUserName NVARCHAR(50) = 'Data Conversion Only'
		
SET @colorId = NEXT VALUE FOR Sequences.ColorID;

SELECT @LastEditedBySystemUser = PersonID
FROM [Application].People
WHERE FullName = @SystemUserName

INSERT INTO Warehouse.Colors
	(ColorId, ColorName, LastEditedBy)
VALUES
	(@colorId, 'Ohra2', @LastEditedBySystemUser);

select ColorId, ColorName, LastEditedBy into Warehouse.Color_Copy 
from Warehouse.Colors;
--DROP TABLE Warehouse.Color_Copy

INSERT INTO Warehouse.Colors
		(ColorId, ColorName, LastEditedBy)
	OUTPUT inserted.ColorId, inserted.ColorName, inserted.LastEditedBy 
		INTO Warehouse.Color_Copy (ColorId, ColorName, LastEditedBy)
	OUTPUT inserted.ColorId
	VALUES
		(NEXT VALUE FOR Sequences.ColorID,'Dark Blue', 1), 
		(NEXT VALUE FOR Sequences.ColorID,'Light Blue', 1);

SELECT @@ROWCOUNT;


USE AdventureWorks2017;

begin tran
INSERT INTO person.address
(addressline1, addressline2, city, stateprovinceid, postalcode)
VALUES('6777 Kingsway', '', 'Burnaby', 7, 'V5H 3Z7');

SELECT @@IDENTITY, SCOPE_IDENTITY();
commit tran


SELECT top 1 * into Sales.Invoices_Q12016
FROM Sales.Invoices
WHERE InvoiceDate >= '2016-01-01' 
	AND InvoiceDate < '2016-04-01';

-- delete from Warehouse.Colors where ColorName = 'Ohra';
-- delete from Warehouse.Colors where ColorName = 'Dark Blue';
-- delete from Warehouse.Colors where ColorName = 'Light Blue';
-- delete from person.address where AddressId = 
-- drop table Sales.Invoices_Q12016;

TRUNCATE TABLE Sales.Invoices_Q12016;
 
INSERT INTO Sales.Invoices_Q12016
SELECT TOP (5) 
	InvoiceID
	,CustomerID
	,BillToCustomerID
	,OrderID + 1000 
	,DeliveryMethodID
	,ContactPersonID
	,AccountsPersonID
	,SalespersonPersonID
	,PackedByPersonID
	,InvoiceDate
	,CustomerPurchaseOrderNumber
	,IsCreditNote
	,CreditNoteReason
	,Comments
	,DeliveryInstructions
	,InternalComments
	,TotalDryItems
	,TotalChillerItems
	,DeliveryRun
	,RunPosition
	,ReturnedDeliveryData
	,[ConfirmedDeliveryTime]
	,[ConfirmedReceivedBy]
	,LastEditedBy
	,GETDATE()
FROM Sales.Invoices
WHERE InvoiceDate >= '2016-01-01' 
	AND InvoiceDate < '2016-04-01'
ORDER BY InvoiceID;


INSERT INTO Sales.Invoices_Q12016
EXEC Sales.GetNewInvoices @batchsize = 10

INSERT INTO Sales.Invoices_Q12016
	(InvoiceID
	,CustomerID
	,BillToCustomerID
	,OrderID 
	,DeliveryMethodID
	,ContactPersonID
	,AccountsPersonID
	,SalespersonPersonID
	,PackedByPersonID
	,InvoiceDate
	,CustomerPurchaseOrderNumber
	,IsCreditNote
	,CreditNoteReason
	,Comments
	,DeliveryInstructions
	,InternalComments
	,TotalDryItems
	,TotalChillerItems
	,DeliveryRun
	,RunPosition
	,ReturnedDeliveryData
	,[ConfirmedDeliveryTime]
	,[ConfirmedReceivedBy]
	,LastEditedBy
	,LastEditedWhen)
EXEC Sales.GetNewInvoices @batchsize = 10

--- [Link Server]
EXEC [c7ffe396c242].[WideWorldImporters].Sales.GetNewInvoices @batchsize = 10


SELECT PhoneNumber, FaxNumber, *
FROM [Application].People
WHERE PersonId = 3


UPDATE [Application].People
SET
	PhoneNumber = '(496) 555-0102',
	FaxNumber = '(496) 555-0103'
OUTPUT inserted.*, deleted.*
WHERE PersonId = 3

ALTER TABLE [Application].People ADD FirstSale DATETIME;
ALTER TABLE [Application].People ADD FirstSale2 DATETIME;


USE [WideWorldImporters];

---update every 1111 rows
UPDATE [Application].[People]
SET FirstSale = (
		SELECT MIN(InvoiceDate)
		FROM Sales.Invoices AS I
		WHERE [Application].People.PersonID = I.SalespersonPersonID);


SELECT firstsale, fullname FROM Application.People;


SELECT FirstSale, FirstSale2, *
FROM [Application].People
WHERE FirstSale IS NOT NULL;

---update 10 rows
UPDATE P
SET FirstSale2 = I.MinInvoiceDate
FROM [Application].People AS P
	JOIN
	(
		SELECT SalespersonPersonID, MIN(InvoiceDate) AS MinInvoiceDate
		FROM Sales.Invoices
		GROUP BY SalespersonPersonID
	) AS I
	ON P.PersonID = I.SalespersonPersonID;

SELECT P.FirstSale2, I.MinInvoiceDate
FROM [Application].People AS P
	JOIN
	(
		SELECT SalespersonPersonID, MIN(InvoiceDate) AS MinInvoiceDate
		FROM Sales.Invoices
		GROUP BY SalespersonPersonID
	) AS I
	ON P.PersonID = I.SalespersonPersonID;

ALTER TABLE [Application].People DROP COLUMN FirstSale;
ALTER TABLE [Application].People DROP COLUMN FirstSale2;

ALTER TABLE [Application].People ADD TotalSaleCount INT NOT NULL Default 0;

UPDATE P
SET TotalSaleCount = TotalSaleCount + I.SalesCount
FROM [Application].People AS P
	JOIN
	(
		SELECT SalespersonPersonID, COUNT(InvoiceId) AS SalesCount
		FROM Sales.Invoices
		WHERE InvoiceDate < '20140101'
		GROUP BY SalespersonPersonID) AS I
			ON P.PersonID = I.SalespersonPersonID;

SELECT TotalSaleCount, *
FROM [Application].People
WHERE TotalSaleCount > 0


UPDATE P
SET TotalSaleCount = TotalSaleCount + I.SalesCount
OUTPUT inserted.PersonID, inserted.FullName, inserted.TotalSaleCount
FROM [Application].People AS P
	JOIN
	(
		SELECT SalespersonPersonID, COUNT(InvoiceId) AS SalesCount
		FROM Sales.Invoices
		WHERE InvoiceDate >= '20140101'
			AND InvoiceDate < '20150101'
		GROUP BY SalespersonPersonID) AS I
			ON P.PersonID = I.SalespersonPersonID;


ALTER TABLE [Application].[People]
