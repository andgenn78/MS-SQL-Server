-- Неправильно
SELECT * 
FROM Sales.OrderLines
WHERE UnitPrice * Quantity > AVG(UnitPrice * Quantity)

-- подзапрос для среднего
SELECT AVG(UnitPrice * Quantity) 
FROM Sales.OrderLines

SELECT * 
FROM Sales.OrderLines 
WHERE UnitPrice * Quantity  > 
	(SELECT 
		AVG(UnitPrice * Quantity) 
	FROM Sales.OrderLines)