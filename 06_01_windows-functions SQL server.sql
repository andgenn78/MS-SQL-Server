--заказы и оплаты по заказам
SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate

--заказы и оплаты по заказам с максимальной суммой за год
SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount,
	(SELECT MAX(inr.TransactionAmount)
	FROM Sales.CustomerTransactions as inr
		join Sales.Invoices as InvoicesInner ON 
			InvoicesInner.InvoiceID = inr.InvoiceID
	WHERE inr.CustomerID = trans.CustomerId
		AND InvoicesInner.InvoiceDate < '2014-01-01'
		)
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate

--заказы и оплаты по заказам с максимальной суммой за год
SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount,
	MAX(trans.TransactionAmount) OVER (PARTITION BY trans.CustomerId)
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate

--заказы и оплаты по заказам с максимальной суммой за год
--с сортировкой по сумме
SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount,
	MAX(trans.TransactionAmount) OVER (PARTITION BY trans.CustomerId),
	ROW_NUMBER() OVER (PARTITION BY Invoices.CustomerId 
						ORDER BY trans.TransactionAmount ASC) AS calc_rank
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
and Invoices.CustomerID = 958
---ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate
ORDER BY calc_rank DESC

SELECT Invoices.InvoiceId, Invoices.InvoiceDate, 
	Invoices.CustomerID, trans.TransactionAmount,
	MAX(trans.TransactionAmount)
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
and Invoices.CustomerID = 958
GROUP BY Invoices.InvoiceId, Invoices.InvoiceDate, 
	Invoices.CustomerID, trans.TransactionAmount
ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate

--заказы и оплаты по заказам с максимальной суммой за год
--с сортировкой по сумме
SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.CustomerId, trans.TransactionAmount,
	MAX(trans.TransactionAmount) OVER (PARTITION BY trans.CustomerId),
	ROW_NUMBER() OVER (PARTITION BY Invoices.CustomerId ORDER BY trans.TransactionAmount DESC)
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
and Invoices.CustomerID = 958
ORDER BY Invoices.CustomerID, trans.TransactionAmount DESC


SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount,
	LAG(trans.TransactionAmount) OVER (PARTITION BY Invoices.CustomerId ORDER BY trans.TransactionAmount) as prev,
	LEAD(trans.TransactionAmount) OVER (PARTITION BY Invoices.CustomerId ORDER BY trans.TransactionAmount) as Follow ,
	MAX(trans.TransactionAmount) OVER (PARTITION BY trans.CustomerId),
	ROW_NUMBER() OVER (PARTITION BY Invoices.CustomerId ORDER BY trans.TransactionAmount DESC)
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
and Invoices.CustomerID = 958
ORDER BY trans.TransactionAmount, Invoices.InvoiceId, Invoices.InvoiceDate


SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount,
	LAG(trans.TransactionAmount) OVER (PARTITION BY Invoices.CustomerId ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate) as prev,
	LEAD(trans.TransactionAmount) OVER (PARTITION BY Invoices.CustomerId ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate) as Follow ,
	MAX(trans.TransactionAmount) OVER (PARTITION BY trans.CustomerId),
	ROW_NUMBER() OVER (PARTITION BY Invoices.CustomerId ORDER BY trans.TransactionAmount DESC)
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
and Invoices.CustomerID = 958
ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate

SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID,Invoices.BillToCustomerID, trans.TransactionAmount,
	LAG(trans.TransactionAmount) OVER (PARTITION BY Invoices.CustomerId ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate) as prev,
	LEAD(trans.TransactionAmount) OVER (PARTITION BY Invoices.CustomerId ORDER BY Invoices.InvoiceId, Invoices.InvoiceDate) as Follow ,
	MAX(trans.TransactionAmount) OVER (PARTITION BY trans.CustomerId),
	ROW_NUMBER() OVER (PARTITION BY Invoices.CustomerId ORDER BY trans.TransactionAmount DESC)
FROM Sales.Invoices as Invoices
	join Sales.CustomerTransactions as trans
		ON Invoices.InvoiceID = trans.InvoiceID
WHERE Invoices.InvoiceDate < '2014-01-01'
and Invoices.CustomerID in (958, 884)
ORDER BY trans.TransactionAmount DESC

SELECT *
FROM 
	(
		SELECT Invoices.InvoiceId, Invoices.InvoiceDate, Invoices.CustomerID, trans.TransactionAmount,
			ROW_NUMBER() OVER (PARTITION BY Invoices.CustomerId ORDER BY trans.TransactionAmount DESC) AS CustomerTransRank
		FROM Sales.Invoices as Invoices
			join Sales.CustomerTransactions as trans
				ON Invoices.InvoiceID = trans.InvoiceID
	) AS tbl
WHERE CustomerTransRank <= 3
order by CustomerID, TransactionAmount desc


DECLARE @page INT = 10,
	@pageSize INT = 20;

WITH InvoiceLinePage AS
(
	SELECT I.InvoiceID, 
		I.InvoiceDate, 
		I.SalespersonPersonID, 
		L.Quantity, 
		L.UnitPrice,
		ROW_NUMBER() OVER (Order by InvoiceLineID) AS Row
	FROM Sales.Invoices AS I
		JOIN Sales.InvoiceLines AS L 
			ON I.InvoiceID = L.InvoiceID
	--ORDER BY Row
)
SELECT *
FROM InvoiceLinePage
WHERE Row Between (@page-1)*@pageSize 
	AND @page*@pageSize;

SELECT UnitPrice, SupplierID, StockItemID, StockItemName,
	ROW_NUMBER() OVER (ORDER BY UnitPrice),
	RANK() OVER (ORDER BY UnitPrice),
	DENSE_RANK() OVER (ORDER BY UnitPrice)
FROM Warehouse.StockItems
WHERE SupplierID = 7
ORDER By UnitPrice

SELECT UnitPrice, SupplierID, StockItemID, StockItemName, ColorId,
	ROW_NUMBER() OVER (ORDER BY UnitPrice) AS Rn,
	RANK() OVER (ORDER BY UnitPrice) AS Rnk,
	DENSE_RANK() OVER (PARTITION BY SupplierId ORDER BY UnitPrice) AS DenseRnk,
	NTILE(10) OVER (PARTITION BY SupplierId ORDER BY UnitPrice) AS GroupNumber
FROM Warehouse.StockItems
WHERE SupplierID in (5, 7)
ORDER By SupplierID, UnitPrice

SELECT SupplierID, ColorId, StockItemID, StockItemName,
	UnitPrice,
	SUM(UnitPrice) OVER() AS Total,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice) AS RunningTotal,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice, StockItemID) AS RunningTotalSort,
	SUM(UnitPrice) OVER(Partition BY ColorId ORDER BY UnitPrice) AS RunningTotalByColor,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice, StockItemID ROWS UNBOUNDED PRECEDING) AS TotalBoundP,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice ROWS BETWEEN CURRENT row AND UNBOUNDED Following) AS TotalBoundF,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice, StockItemID ROWS 2 PRECEDING) AS TotalBound2,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice, StockItemID RANGE UNBOUNDED PRECEDING) AS TotalBoundRange,
	SUM(UnitPrice) OVER(ORDER BY UnitPrice RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS TotalBoundRange
FROM Warehouse.StockItems
WHERE SupplierID in (5, 7)
ORDER By UnitPrice, StockItemID

SELECT UnitPrice, SupplierID, StockItemID, StockItemName, ColorId,
	ROW_NUMBER() OVER (ORDER BY UnitPrice) AS Rn,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ColorId) OVER (PARTITION BY SupplierId) AS PC,
	CUME_DIST() OVER (ORDER BY UnitPrice)
FROM Warehouse.StockItems
WHERE SupplierID in (5, 7)
ORDER By SupplierID, UnitPrice