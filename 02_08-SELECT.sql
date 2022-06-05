SELECT  OrderLineID as [Order Line ID],
        Quantity,
        UnitPrice,
        (Quantity * UnitPrice) AS [TotalCost]
FROM Sales.OrderLines
WHERE [TotalCost] > 1000

-- ---------

SELECT  OrderLineID as [Order Line ID],
        Quantity,
        UnitPrice,
        (Quantity * UnitPrice) AS [TotalCost]
FROM Sales.OrderLines
ORDER BY [TotalCost]


