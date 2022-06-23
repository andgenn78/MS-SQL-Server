USE WideWorldImporters
GO

-- ----------------------------------------
-- Создаем таблицу с XML
-- Сводка по всем заказам по заказчикам
-- ----------------------------------------
DROP TABLE IF EXISTS Sales.OrderSummary
GO

CREATE TABLE Sales.OrderSummary
(
  ID INT NOT NULL IDENTITY,
  CustomerID INT NOT NULL,
  OrderSummary XML
)
GO

INSERT INTO Sales.OrderSummary (CustomerID, OrderSummary)
SELECT 
    CustomerID,
    (SELECT
      CustomerName 'OrderHeader/CustomerName', 
      OrderDate 'OrderHeader/OrderDate', 
      OrderID 'OrderHeader/OrderID', 
      (SELECT
          LineItems2.StockItemID '@ProductID', 
          StockItems.StockItemName '@ProductName', 
          LineItems2.UnitPrice '@Price', 
          Quantity '@Qty'
       FROM Sales.OrderLines LineItems2 
       INNER JOIN Warehouse.StockItems StockItems ON LineItems2.StockItemID = StockItems.StockItemID
       WHERE LineItems2.OrderID = Base.OrderID 
       FOR XML PATH('Product'), TYPE) 'OrderDetails'
    FROM
    (
      SELECT DISTINCT
        Customers.CustomerName, 
        SalesOrder.OrderDate, 
        SalesOrder.OrderID
      FROM Sales.Orders SalesOrder
      INNER JOIN Sales.OrderLines LineItem ON SalesOrder.OrderID = LineItem.OrderID
      INNER JOIN Sales.Customers Customers ON Customers.CustomerID = SalesOrder.CustomerID
      WHERE customers.CustomerID = OuterCust.CustomerID
    ) Base 
    FOR XML PATH('Order'), ROOT ('SalesOrders'), TYPE) AS OrderSummary
FROM Sales.Customers OuterCust
GO

-- Посмотрим, что получилось 
SELECT TOP 1 * FROM Sales.OrderSummary

-- Нужен первичный ключ с кластерным индексом
ALTER TABLE Sales.OrderSummary 
ADD CONSTRAINT PK_OrderSummary 
PRIMARY KEY CLUSTERED(ID)
GO

-- -----------------------
-- Создаем индексы
-- -----------------------
exec sp_spaceused 'Sales.OrderSummary'

-- !!! может выполняться долго
CREATE PRIMARY XML INDEX [PXML_OrderSummary_OrderSummary]
ON Sales.OrderSummary ([OrderSummary])
GO
exec sp_spaceused 'Sales.OrderSummary'

CREATE XML INDEX [SXML_OrderSummary_Path]
ON Sales.OrderSummary (OrderSummary)
USING XML INDEX [PXML_OrderSummary_OrderSummary] 
FOR PATH
GO
exec sp_spaceused 'Sales.OrderSummary'

-- Пример селективного индекса в самом конце

-- -----------------------
-- Запросы
-- -----------------------

-- Отображаем статистику
SET STATISTICS TIME ON
GO

-- С path-индексом
DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
GO

SELECT *
FROM Sales.OrderSummary
WHERE OrderSummary.exist('/SalesOrders/Order/OrderDetails/Product/.[@ProductID = 223]') = 1 
GO

-- Только с primary-индексом
DROP INDEX [SXML_OrderSummary_Path] ON Sales.OrderSummary
GO

DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
GO

SELECT *
FROM Sales.OrderSummary
WHERE OrderSummary.exist('/SalesOrders/Order/OrderDetails/Product/.[@ProductID = 223]') = 1
GO

-- Без индексов
DROP INDEX [PXML_OrderSummary_OrderSummary] ON Sales.OrderSummary
GO

DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
GO

SELECT *
FROM Sales.OrderSummary
WHERE OrderSummary.exist('/SalesOrders/Order/OrderDetails/Product/.[@ProductID = 223]') = 1


-- SELECTIVE index
CREATE SELECTIVE XML INDEX [SEL_XML_OrderSummary_OrderSummary]
ON Sales.OrderSummary ([OrderSummary])
FOR 
(
    pathSalesPersonID = '/SalesOrders/Order/OrderDetails/Product'
)
GO
exec sp_spaceused 'Sales.OrderSummary'