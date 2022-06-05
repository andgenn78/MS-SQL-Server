SELECT ProductId, Name, DaysToManufacture, StandardCost,
	AVG(StandardCost) OVER (PARTITION BY DaysToManufacture)
FROM Production.Product
ORDER BY DaysToManufacture;

SELECT DISTINCT DaysToManufacture, 
	AVG(StandardCost) OVER (PARTITION BY DaysToManufacture)
FROM Production.Product
---GROUP BY DaysToManufacture
ORDER BY DaysToManufacture
;

SELECT 'AverageCost' AS Cost_Sorted_By_Production_Days, [0], [1], [2],
[3], [4]
FROM (SELECT DaysToManufacture, StandardCost FROM Production.Product) AS
SourceTable
PIVOT ( AVG(StandardCost)
FOR DaysToManufacture
IN ([0], [1], [2], [3], [4])
) AS PivotTable;

--raw data
SELECT YEAR(ord.OrderDate) as SalesYear,
        L.UnitPrice*L.Quantity as TotalSales,
		SUM(L.UnitPrice*L.Quantity) OVER (PARTITION BY YEAR(ord.OrderDate))
 FROM Sales.Orders AS ord 
     JOIN Sales.OrderLines L ON ord.OrderID = L.OrderID
ORDER BY YEAR(ord.OrderDate)


--raw data
SELECT DISTINCT YEAR(ord.OrderDate) as SalesYear,
		SUM(L.UnitPrice*L.Quantity) OVER (PARTITION BY YEAR(ord.OrderDate))
 FROM Sales.Orders AS ord 
     JOIN Sales.OrderLines L ON ord.OrderID = L.OrderID
ORDER BY YEAR(ord.OrderDate);
--
SELECT * FROM 
(
SELECT YEAR(ord.OrderDate) as SalesYear,
        L.UnitPrice*L.Quantity as TotalSales
 FROM Sales.Orders AS ord 
     JOIN Sales.OrderLines L ON ord.OrderID = L.OrderID
) AS Sales
PIVOT (SUM(TotalSales)
FOR SalesYear IN ([2013],[2014],[2015],[2016]))
as PVT;
--
SELECT * FROM 
(
SELECT MONTH(ord.OrderDate) as SalesMonth, YEAR(ord.OrderDate) as SalesYear,
        L.UnitPrice*L.Quantity as TotalSales
 FROM Sales.Orders AS ord 
     JOIN Sales.OrderLines L ON ord.OrderID = L.OrderID
 ---ORDER BY SalesMonth, SalesYear
) AS Sales
PIVOT (SUM(TotalSales)
FOR SalesYear IN ([2013],[2014],[2015]))
as PVT
ORDER BY SalesMonth;


--https://www.codeproject.com/Tips/500811/Simple-Way-To-Use-Pivot-In-SQL-Query
SELECT *
FROM (
    SELECT 
        year(I.InvoiceDate) as [year],left(datename(month,I.InvoiceDate),3)as [month], 
         Trans.TransactionAmount as Amount 
    FROM Sales.Invoices AS I
		JOIN Sales.CustomerTransactions AS Trans
			ON I.InvoiceId = Trans.InvoiceID
) as s
PIVOT
(
    SUM(Amount)
    FOR [month] IN (jan, feb, mar, apr, 
    may, jun, jul, aug, sep, oct, nov, dec)
)AS pvt

--https://www.sqlshack.com/static-and-dynamic-sql-pivot-and-unpivot-relational-operator-overview/
SELECT SalesYear, 
       ISNULL([Q1], 0) AS Q1, 
       ISNULL([Q2], 0) AS Q2, 
       ISNULL([Q3], 0) AS Q3, 
       ISNULL([Q4], 0) AS Q4, 
       (ISNULL([Q1], 0) + ISNULL([Q2], 0) + ISNULL([Q3], 0) + ISNULL([Q4], 0)) SalesYTD
FROM
(
    SELECT YEAR(OH.OrderDate) AS SalesYear, 
           CAST('Q'+CAST(DATEPART(QUARTER, OH.OrderDate) AS VARCHAR(1)) AS VARCHAR(2)) AS Quarters, 
           SUM(L.UnitPrice*L.Quantity) AS TotalSales
    FROM Sales.Orders OH
         JOIN Sales.OrderLines L ON OH.OrderId = L.OrderId
	GROUP BY YEAR(OH.OrderDate), 
           CAST('Q'+CAST(DATEPART(QUARTER, OH.OrderDate) AS VARCHAR(1)) AS VARCHAR(2))
 ) AS Data PIVOT(SUM(TotalSales) FOR Quarters IN([Q1], 
                                                [Q2], 
                                                [Q3], 
                                                [Q4])) AS pvt
ORDER BY SalesYear;

SELECT SalesYear,TotalSales
FROM (
	SELECT * 
	FROM (
		SELECT YEAR(ord.OrderDate) as SalesYear,
				L.UnitPrice*L.Quantity as TotalSales
		 FROM Sales.Orders AS ord 
			 JOIN Sales.OrderLines L ON ord.OrderID = L.OrderID
		) AS Sales
		PIVOT (SUM(TotalSales)
		FOR SalesYear IN ([2013],[2014],[2015],[2016]))
		as PVT
) T UNPIVOT(TotalSales FOR SalesYear IN([2013],
                                        [2014],
										[2015],
										[2016])) AS upvt;




