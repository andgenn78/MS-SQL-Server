SELECT 
	StockItemID, 
	StockItemName, 
	UnitPrice, 
	(SELECT 
		MAX(UnitPrice) 
	FROM Warehouse.StockItems) AS MaxPrice
FROM Warehouse.StockItems;

SELECT 
	PersonId, 
	FullName, 
		(SELECT 
			COUNT(InvoiceId) AS SalesCount
		FROM Sales.Invoices
		WHERE Invoices.SalespersonPersonID = People.PersonID
		) AS TotalSalesCount
FROM Application.People
WHERE IsSalesperson = 1;

SELECT *
FROM Application.People
WHERE PersonId IN (SELECT SalespersonPersonID FROM Sales.Invoices);


SELECT *
FROM Application.People
WHERE PersonId IN (1,2,NULL);

SELECT *
FROM Application.People
WHERE PersonId = 1 OR PersonID = 2 OR PersonId = NULL;

SELECT *
FROM Application.People
WHERE PersonId NOT IN (1,2,NULL);

SELECT *
FROM Application.People
WHERE NOT (PersonId = 1 OR PersonID = 2 OR PersonId = 3);

SELECT *
FROM Application.People
WHERE NOT (PersonId = 1 OR PersonID = 2 OR PersonId = NULL);

SELECT * 
FROM Application.People
WHERE EXISTS (SELECT SalespersonPersonID 
	FROM Sales.Invoices
	WHERE SalespersonPersonID = People.PersonID);

SELECT *
FROM Application.People
WHERE NOT EXISTS (SELECT 1 
	FROM Sales.Invoices
	WHERE SalespersonPersonID = People.PersonID);

SELECT *
FROM Application.People
WHERE (SELECT count(*)
	FROM Sales.Invoices
	WHERE SalespersonPersonID = People.PersonID) > 0

SELECT StockItemID, StockItemName, UnitPrice 
FROM Warehouse.StockItems
WHERE UnitPrice <= ALL (SELECT UnitPrice 
	FROM Warehouse.StockItems);

SELECT StockItemID, StockItemName, UnitPrice	
FROM Warehouse.StockItems
WHERE UnitPrice >= ALL (SELECT UnitPrice 
	FROM Warehouse.StockItems);


SELECT StockItemID, StockItemName, UnitPrice 
FROM Warehouse.StockItems
WHERE UnitPrice <= SOME (SELECT UnitPrice 
	FROM Warehouse.StockItems);

SELECT StockItemID, StockItemName, UnitPrice, Size
FROM Warehouse.StockItems
WHERE UnitPrice >= ANY (SELECT UnitPrice
	FROM Warehouse.StockItems
	WHERE Size = 'XL')
	AND Size IS NOT NULL;


--derrived tables

SELECT P.PersonID, P.FullName, I.SalesCount
FROM [Application].People AS P
	JOIN
	(SELECT SalespersonPersonID, Count(InvoiceId) AS SalesCount
	FROM Sales.Invoices
	WHERE InvoiceDate >= '20140101'
		AND InvoiceDate < '20150101' 
	GROUP BY SalespersonPersonID) AS I
		ON P.PersonID = I.SalespersonPersonID;	
	

SELECT 
	Invoices.InvoiceID, 
	Invoices.InvoiceDate,
	(SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice, 
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
			FROM Sales.Orders
			WHERE Orders.PickingCompletedWhen IS NOT NULL	
				AND Orders.OrderId = Invoices.OrderId)	
	) AS TotalSummForPickedItems
FROM Sales.Invoices 
	JOIN
	(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
		ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC