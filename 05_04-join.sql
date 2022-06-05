---------------------------------------
-- Порядок JOIN
-----------------------------------------
SET SHOWPLAN_TEXT OFF
-- Работает
SELECT TOP 10 
    o.CustomerID,
    c.CustomerName,
    c.PhoneNumber
FROM Sales.OrderLines l
JOIN Sales.Orders o ON o.OrderID = l.OrderID 
JOIN Sales.Customers c ON c.CustomerID = o.CustomerID

-- Поменяем таблицы в FROM и JOIN
SELECT TOP 10 
    o.CustomerID,
    c.CustomerName,
    c.PhoneNumber
FROM Sales.Orders o
JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
JOIN Sales.OrderLines l ON l.OrderID  = o.OrderID 

-- Теперь порядок JOIN не влияет
-- Планы для всех запросов абсолютно одинаковые 
SELECT TOP 10 
    o.CustomerID,
    c.CustomerName,
    c.PhoneNumber
FROM Sales.Orders o
JOIN Sales.OrderLines l ON l.OrderID  = o.OrderID 
JOIN Sales.Customers c ON c.CustomerID = o.CustomerID

--------------------------------
-- "Съедание данных" LEFT JOIN
--------------------------------
SELECT   
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  t.TransactionDate,
  t.TransactionAmount
FROM Purchasing.Suppliers s
LEFT JOIN Purchasing.SupplierTransactions t ON t.SupplierID = s.SupplierID
WHERE s.SupplierName IN ('Contoso, Ltd.', 'A Datum Corporation', 'Consolidated Messenger', 'Nod Publishers')
ORDER BY s.SupplierID

SELECT   
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  tt.TransactionTypeName
FROM Purchasing.Suppliers s
LEFT JOIN Purchasing.SupplierTransactions t ON t.SupplierID = s.SupplierID
LEFT JOIN Application.TransactionTypes tt ON tt.TransactionTypeID = t.TransactionTypeID
WHERE s.SupplierName IN ('Contoso, Ltd.', 'A Datum Corporation', 'Consolidated Messenger', 'Nod Publishers')
ORDER BY s.SupplierID

