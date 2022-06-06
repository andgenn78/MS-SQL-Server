-- Нет источника
SELECT  '1' AS Col01,
        'A' AS Col02;

-- Одна таблица
SELECT  OrderLineID as [Order Line ID],
        StockItemID,
        Quantity,
        Price = UnitPrice,
        'Batch 1' AS [BatchID], -- константа
        (Quantity * UnitPrice) AS [TotalCost]  -- арифметическое выражение
FROM Sales.OrderLines

-- SELECT *
SELECT TOP 10 *
FROM Sales.OrderLines

-- ORDER BY
SELECT TOP 10 *
FROM Sales.OrderLines l
ORDER BY l.Description

-- Разбивка на страницы
SELECT *
FROM Sales.OrderLines l
ORDER BY l.Description OFFSET 20 ROWS FETCH NEXT 50 ROWS ONLY;

-- DISTINCT
SELECT ContactPersonID
FROM Sales.Orders

SELECT DISTINCT ContactPersonID
FROM Sales.Orders
