--begin tran 

DELETE FROM Warehouse.Colors
OUTPUT deleted.*
WHERE ColorName like '%2%';

TRUNCATE TABLE Warehouse.Colors;

--Checkident reseed

--JOIN and Exists
SELECT ColorId, ColorName, LastEditedBy INTO Warehouse.Colors_DeleteDemo
FROM Warehouse.Colors;

SELECT * FROM Warehouse.Colors_DeleteDemo;

INSERT INTO Warehouse.Colors_DeleteDemo
	(ColorId, ColorName, LastEditedBy)
VALUES
	(NEXT VALUE FOR Sequences.ColorID,'Dark Blue11991', 1), 
	(NEXT VALUE FOR Sequences.ColorID,'Light Blue119991', 1);

SELECT * FROM Warehouse.Colors_DeleteDemo
WHERE EXISTS (SELECT 100 
	FROM Warehouse.Colors
	WHERE Warehouse.Colors_DeleteDemo.ColorName = Warehouse.Colors.ColorName);

DELETE FROM Warehouse.Colors_DeleteDemo
WHERE EXISTS (SELECT * 
	FROM Warehouse.Colors
	WHERE Warehouse.Colors.ColorName = Warehouse.Colors_DeleteDemo.ColorName);

DELETE FROM Demo
FROM Warehouse.Colors_DeleteDemo AS Demo
	JOIN  Warehouse.Colors AS C
		ON Demo.ColorName = C.ColorName;

SELECT * 
FROM Warehouse.Colors_DeleteDemo;

--Drop table Warehouse.Colors_DeleteDemo;


	SELECT 
		InvoiceID
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
		,ConfirmedDeliveryTime
		,ConfirmedReceivedBy
		,LastEditedBy
		,LastEditedWhen
	INTO Sales.Invoices_Q12016_Archive
	FROM Sales.Invoices_Q12016
	WHERE InvoiceDate >= '2016-01-01' 
		AND InvoiceDate < '2016-04-01';

	SELECT * FROM Sales.Invoices_Q12016_Archive
		
		
	SELECT * FROM Sales.Invoices_Q12016


DECLARE @rowcount INT,
		@batchsize INT = 10;

SET @rowcount = @batchsize;

WHILE @rowcount = @batchsize
BEGIN
	DELETE top (@batchsize) FROM Sales.Invoices_Q12016
	OUTPUT
		deleted.InvoiceID
		,deleted.CustomerID
		,deleted.BillToCustomerID
		,deleted.OrderID
		,deleted.DeliveryMethodID
		,deleted.ContactPersonID
		,deleted.AccountsPersonID
		,deleted.SalespersonPersonID
		,deleted.PackedByPersonID
		,deleted.InvoiceDate
		,deleted.CustomerPurchaseOrderNumber
		,deleted.IsCreditNote
		,deleted.CreditNoteReason
		,deleted.Comments
		,deleted.DeliveryInstructions
		,deleted.InternalComments
		,deleted.TotalDryItems
		,deleted.TotalChillerItems
		,deleted.DeliveryRun
		,deleted.RunPosition
		,deleted.ReturnedDeliveryData
		,deleted.ConfirmedDeliveryTime
		,deleted.ConfirmedReceivedBy
		,deleted.LastEditedBy
		,deleted.LastEditedWhen
	  INTO Sales.Invoices_Q12016_Archive
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
		,ConfirmedDeliveryTime
		,ConfirmedReceivedBy
		,LastEditedBy
		,LastEditedWhen)
	OUTPUT
		deleted.InvoiceID
	WHERE InvoiceDate >= '2016-01-01' 
		AND InvoiceDate < '2016-04-01';

	SET @rowcount = @@ROWCOUNT;
END

--rollback tran
--truncate table Sales.Invoices_Q12016_Archive

select * 
from Sales.Invoices_Q12016_Archive
where InvoiceId = 61321

--Detele vs Truncate
TRUNCATE TABLE Sales.Invoices_Q12016_Archive;

DELETE FROM Sales.Invoices_Q12016_Archive;