SELECT C.CustomerName, O.*
FROM Sales.Customers C
CROSS APPLY (SELECT TOP 2 *
                FROM Sales.Orders O
                WHERE O.CustomerID = C.CustomerID
                ORDER BY O.OrderDate DESC, O.OrderID DESC) AS O
ORDER BY C.CustomerName;

SELECT C.CustomerName, O.*
FROM Sales.Customers C
OUTER APPLY (SELECT TOP 2 *
                FROM Sales.Orders O
                WHERE O.CustomerID = C.CustomerID
                ORDER BY O.OrderDate DESC, O.OrderID DESC) AS O
ORDER BY C.CustomerName;


--function call
SELECT City.CityId, City.CityName, City.LatestRecordedPopulation, Acc.*
FROM Application.Cities AS City
	CROSS APPLY [Application].[DetermineCustomerAccessTest](City.CityId) AS Acc
ORDER BY City.CityId, City.CityName

--subquery for table 
SELECT *
FROM 
	(
		SELECT 
			Invoices.InvoiceId, 
			Invoices.InvoiceDate, 
			Invoices.CustomerID, 
			trans.TransactionAmount,
			ROW_NUMBER() OVER (PARTITION BY Invoices.CustomerId ORDER BY trans.TransactionAmount DESC) AS CustomerTransRank
		FROM Sales.Invoices as Invoices
			join Sales.CustomerTransactions as trans
				ON Invoices.InvoiceID = trans.InvoiceID
	) AS tbl
WHERE CustomerTransRank <= 3
order by CustomerID, TransactionAmount desc

SELECT
	BiggestTransaction.InvoiceID,
	BiggestTransaction.InvoiceDate, 
	C.CustomerID,
	C.CustomerName,
	BiggestTransaction.TransactionAmount
FROM Sales.Customers AS C
CROSS APPLY (
	SELECT TOP 3 Invoices.InvoiceId, Invoices.InvoiceDate, trans.TransactionAmount
		FROM Sales.Invoices as Invoices
			join Sales.CustomerTransactions as trans
				ON Invoices.InvoiceID = trans.InvoiceID
	WHERE Invoices.CustomerID = C.CustomerID
	ORDER BY trans.TransactionAmount DESC
	) AS BiggestTransaction
ORDER BY C.CustomerID, BiggestTransaction.TransactionAmount DESC;

alter table Sales.Customers add LastInvoiceId INT;

select top 10 LastInvoiceId, *
FROM Sales.Customers;
 
UPDATE C
SET LastInvoiceId = LatestTransaction.InvoiceID
FROM Sales.Customers AS C
CROSS APPLY (
	SELECT TOP 1 Invoices.InvoiceId, Invoices.InvoiceDate, trans.TransactionAmount
		FROM Sales.Invoices as Invoices
			join Sales.CustomerTransactions as trans
				ON Invoices.InvoiceID = trans.InvoiceID
	WHERE Invoices.CustomerID = C.CustomerID
	ORDER BY Invoices.InvoiceDate DESC
	) AS LatestTransaction;

select top 10 LastInvoiceId, *
FROM Sales.Customers;

SELECT
	BiggestTransaction.InvoiceID,
	BiggestTransaction.InvoiceDate, 
	C.CustomerID,
	C.CustomerName,
	BiggestTransaction.TransactionAmount
FROM Sales.Customers AS C
OUTER APPLY (
	SELECT TOP 3 Invoices.InvoiceId, Invoices.InvoiceDate, trans.TransactionAmount
		FROM Sales.Invoices as Invoices
			join Sales.CustomerTransactions as trans
				ON Invoices.InvoiceID = trans.InvoiceID
	WHERE Invoices.CustomerID = C.CustomerID
	ORDER BY trans.TransactionAmount DESC
	) AS BiggestTransaction
ORDER BY C.CustomerID, BiggestTransaction.TransactionAmount DESC

--readable queries
SELECT CAST(DATEADD(mm,DATEDIFF(mm,0,P.OrderDate),0) AS DATE) AS PurchaseOrderMonth,
	COUNT(*) AS PurchaseCount
FROM Purchasing.PurchaseOrders AS P
GROUP BY CAST(DATEADD(mm,DATEDIFF(mm,0,P.OrderDate),0) AS DATE)
ORDER BY CAST(DATEADD(mm,DATEDIFF(mm,0,P.OrderDate),0) AS DATE);

--cross apply
SELECT CA.PurchaseOrderMonth,
	COUNT(*) AS PurchaseCount
FROM Purchasing.PurchaseOrders AS P
CROSS APPLY (SELECT CAST(DATEADD(mm,DATEDIFF(mm,0,P.OrderDate),0) AS DATE) AS PurchaseOrderMonth) AS CA
GROUP BY CA.PurchaseOrderMonth
ORDER BY CA.PurchaseOrderMonth

