SELECT P.PersonID, P.FullName, I.SalesCount
FROM [Application].People AS P
	JOIN
	(SELECT SalespersonPersonID, Count(InvoiceId) AS SalesCount
	FROM Sales.Invoices
	WHERE InvoiceDate >= '20140101'
		AND InvoiceDate < '20150101' 
	GROUP BY SalespersonPersonID) AS I
		ON P.PersonID = I.SalespersonPersonID

;WITH InvoicesCTE AS 
(
	SELECT SalespersonPersonID, Count(InvoiceId) AS SalesCount
	FROM Sales.Invoices
	WHERE InvoiceDate >= '20140101'
		AND InvoiceDate < '20150101' 
	GROUP BY SalespersonPersonID
)
SELECT P.PersonID, P.FullName, I.SalesCount
FROM [Application].People AS P
	JOIN InvoicesCTE AS I
		ON P.PersonID = I.SalespersonPersonID;


WITH InvoicesCTE AS 
(
	SELECT SalespersonPersonID, Count(InvoiceId) AS SalesCount
	FROM Sales.Invoices
	WHERE InvoiceDate >= '20140101'
		AND InvoiceDate < '20150101' 
	GROUP BY SalespersonPersonID
),
InvoicesLinesCTE AS 
(
	SELECT Invoices.SalespersonPersonID, SUM(Lines.Quantity) AS TotalQuantity, SUM(Lines.Quantity*Lines.UnitPrice) AS TotalSumm
	FROM Sales.Invoices	
		JOIN Sales.InvoiceLines AS Lines
			ON Invoices.InvoiceID = Lines.InvoiceID
	GROUP BY Invoices.SalespersonPersonID
)
SELECT P.PersonID, P.FullName, I.SalesCount, L.TotalQuantity, L.TotalSumm
FROM [Application].People AS P
	JOIN InvoicesCTE AS I
		ON P.PersonID = I.SalespersonPersonID
	JOIN InvoicesLinesCTE AS L
		ON P.PersonID = L.SalespersonPersonID
ORDER BY L.TotalSumm DESC, I.SalesCount DESC;

--delete CTE

SELECT TOP 10 InvoiceId
	FROM Sales.Invoices_Q12016_Archive
	ORDER BY InvoiceID;

WITH OrdDelete AS
(	
	SELECT TOP 10  InvoiceId
	FROM Sales.Invoices_Q12016_Archive
	ORDER BY InvoiceID
)
DELETE FROM OrdDelete;

SELECT TOP 10 InvoiceId
	FROM Sales.Invoices_Q12016_Archive
	ORDER BY InvoiceID;
