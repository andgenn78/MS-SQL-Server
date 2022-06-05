-- IS NULL, IS NOT NULL
SELECT OrderID, PickingCompletedWhen
FROM Sales.Orders
WHERE PickingCompletedWhen = null
GO

SELECT OrderID, PickingCompletedWhen
FROM Sales.Orders
WHERE PickingCompletedWhen != null
GO

SELECT OrderID, PickingCompletedWhen
FROM Sales.Orders
WHERE PickingCompletedWhen is null
GO

SELECT OrderID, PickingCompletedWhen
FROM Sales.Orders
WHERE PickingCompletedWhen is not null
GO

SET ANSI_NULLS OFF
SELECT OrderID, PickingCompletedWhen
FROM Sales.Orders
WHERE PickingCompletedWhen = null
GO

-- Конкатенация с NULL
SELECT 'abc' + null

SET CONCAT_NULL_YIELDS_NULL OFF
SELECT 'abc' + null
SET CONCAT_NULL_YIELDS_NULL ON

-- Арифметические операции с NULL
SELECT 3 + null

-- ISNULL()

--   Conversion failed 
SELECT 
    OrderId,    
    ISNULL(PickingCompletedWhen, 'Unknown') AS PickingCompletedWhen
FROM Sales.Orders

SELECT 
    OrderId,    
    PickingCompletedWhen,
    ISNULL(CONVERT(nvarchar(10), PickingCompletedWhen, 104), 'Unknown') AS PickingCompletedWhen
FROM Sales.Orders


-- COALESCE()
DECLARE @val1 int = NULL;
DECLARE @val2 int = NULL;
DECLARE @val3 int = 2;
DECLARE @val4 int = 5;

SELECT COALESCE(@val1, @val2, @val3, @val4)
   AS FirstNonNull;
   
-- Здесь есть NULL
SELECT DISTINCT PickingCompletedWhen
FROM Sales.Orders
ORDER BY PickingCompletedWhen

-- Здесь NULL не учитывается
SELECT COUNT(DISTINCT PickingCompletedWhen)
FROM Sales.Orders
