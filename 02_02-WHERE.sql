-- equals
SELECT *
FROM Warehouse.StockItems
WHERE StockItemName = 'Chocolate sharks 250g'

-- like
SELECT *
FROM Warehouse.StockItems
WHERE StockItemName like 'Chocolate%'

-- index scan
SELECT *
FROM Warehouse.StockItems
WHERE StockItemName like '%250g'
-- как сделать, чтобы использовалс¤ индекс, если нужно часто делать такие запросы?

SELECT *
FROM Warehouse.StockItems
WHERE StockItemName like 'Chocolate%250g'

-- AND, OR
-- нужно вывести StockItems, где цена 350-500 и
-- название начинаетс¤ с USB или Ride.
-- ¬се правильно?
SELECT RecommendedRetailPrice, *
FROM Warehouse.StockItems
WHERE
    RecommendedRetailPrice BETWEEN 350 AND 500 AND
    StockItemName like 'USB%' OR
    StockItemName like 'Ride%'


-- ‘ункции в WHERE
DROP INDEX IF EXISTS IX_Sales_Orders_OrderDate ON Sales.Orders

SELECT *
FROM Sales.Orders o
WHERE year(OrderDate) = 2013

SELECT *
FROM Sales.Orders o
WHERE OrderDate = '2013-01-01'

CREATE INDEX IX_Sales_Orders_OrderDate ON Sales.Orders(OrderDate)

SELECT *
FROM Sales.Orders o
WHERE year(OrderDate) = 2013

SELECT *
FROM Sales.Orders o
WHERE OrderDate = '2013-01-01'

DROP INDEX IX_Sales_Orders_OrderDate ON Sales.Orders

