USE WideWorldImporters
GO

-----------------------------------------
-- Исходные таблицы
-----------------------------------------

-- Исходная таблица Suppliers
SELECT 
  SupplierID,
  SupplierName
FROM Purchasing.Suppliers
/* where - чтобы в примере было меньше строк */
WHERE SupplierName IN ('A Datum Corporation', 'Contoso, Ltd.', 'Consolidated Messenger', 'Nod Publishers')
ORDER BY SupplierID

-- Исходная таблица -- SupplierTransactions
SELECT 
  SupplierTransactionID,
  SupplierID,
  TransactionDate,
  TransactionAmount
FROM Purchasing.SupplierTransactions 
WHERE SupplierID IN (1, 2, 3, 9) /* чтобы в примере было меньше строк */
ORDER BY SupplierID

-----------------------------------------
-- JOINS 
-----------------------------------------

-- CROSS JOIN with FROM, ANSI SQL-89
SELECT   
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  t.SupplierID,
  t.TransactionDate,
  t.TransactionAmount
FROM Purchasing.Suppliers s, Purchasing.SupplierTransactions t
WHERE s.SupplierID IN (1, 2, 3, 9) and t.SupplierID IN (1, 2, 3, 9)
ORDER BY s.SupplierID, t.SupplierID

-- INNER JOIN with FROM and WHERE, ANSI SQL-89
SELECT   
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  t.SupplierID,
  t.TransactionDate,
  t.TransactionAmount
FROM Purchasing.Suppliers s, Purchasing.SupplierTransactions t
WHERE s.SupplierID IN (1, 2, 3, 9) and t.SupplierID IN (1, 2, 3, 9)
and s.SupplierID = t.SupplierID
ORDER BY s.SupplierID, t.SupplierID

-- CROSS JOIN, ANSI SQL-92
SELECT   
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  t.SupplierID,
  t.TransactionDate,
  t.TransactionAmount
FROM Purchasing.Suppliers s
CROSS JOIN Purchasing.SupplierTransactions t
WHERE s.SupplierID IN (1, 2, 3, 9) and t.SupplierID IN (1, 2, 3, 9)
ORDER BY s.SupplierID, t.SupplierID

-- INNER JOIN with WHERE, ANSI SQL-89
SELECT   
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  t.SupplierID,
  t.TransactionDate,
  t.TransactionAmount
FROM Purchasing.Suppliers s
CROSS JOIN Purchasing.SupplierTransactions t
WHERE s.SupplierID IN (1, 2, 3, 9) and 
t.SupplierID = s.SupplierID

-- INNER JOIN with ON, ANSI SQL-92
SELECT   
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  t.SupplierID,
  t.TransactionDate,
  t.TransactionAmount
FROM Purchasing.Suppliers s
/*INNER */ JOIN Purchasing.SupplierTransactions t 
	ON t.SupplierID = s.SupplierID
WHERE s.SupplierID IN (1, 2, 3, 9)
ORDER BY s.SupplierID

-- LEFT JOIN 
SELECT   
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  t.SupplierID,
  t.TransactionDate,
  t.TransactionAmount
FROM Purchasing.Suppliers s
LEFT /*OUTER */ JOIN Purchasing.SupplierTransactions t 
	ON t.SupplierID = s.SupplierID
WHERE s.SupplierName IN ('Contoso, Ltd.', 'A Datum Corporation', 'Consolidated Messenger', 'Nod Publishers')
ORDER BY s.SupplierID

-- RIGHT JOIN
SELECT   
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  t.SupplierID,
  t.TransactionDate,
  t.TransactionAmount
FROM Purchasing.SupplierTransactions t
RIGHT JOIN  Purchasing.Suppliers s 
	ON s.SupplierID = t.SupplierID 
WHERE s.SupplierName IN ('Contoso, Ltd.', 'A Datum Corporation', 'Consolidated Messenger', 'Nod Publishers')
ORDER BY s.SupplierID

-- Найти поставщиков (Supplier) без транзакций (transactions)
SELECT   
  s.SupplierID,
  s.SupplierName,
  t.SupplierTransactionID,
  t.SupplierID,
  t.TransactionDate,
  t.TransactionAmount
FROM Purchasing.Suppliers s
LEFT JOIN Purchasing.SupplierTransactions t 
	ON t.SupplierID = s.SupplierID
WHERE s.SupplierName IN ('Contoso, Ltd.', 'A Datum Corporation', 'Consolidated Messenger', 'Nod Publishers') and
t.SupplierTransactionID is null
ORDER BY s.SupplierID

-- MANY JOINs and CASE
SELECT 
  s.SupplierID,
  s.SupplierName,
  p.FullName as ContactFullName,
  p.EmailAddress as ContactEmail,
  t.TransactionDate,
  t.TransactionAmount,
  CASE 
    WHEN t.TransactionAmount is null  THEN 'NULL'
    WHEN t.TransactionAmount < 0  THEN '< 0'
    WHEN t.TransactionAmount >= 0 AND t.TransactionAmount < 20000 THEN '0 - 20000'
    ELSE '> 20000'
  END TransactionDesc
FROM Purchasing.Suppliers s 
JOIN Application.People p 
	ON p.PersonID = s.PrimaryContactPersonID
JOIN Purchasing.SupplierTransactions t 
	ON t.SupplierID =  s.SupplierID
ORDER BY s.SupplierID

-- MANY MANY JOINs with LEFT
-- Поставщики (Suppliers) и транзакциями, 
-- включая тех поставщиков, у которых нет транзакций
SELECT 
  s.SupplierID as [Supplier ID],
  s.SupplierName as [Supplier Name],
  c.SupplierCategoryName as [Supplier Category],
  primaryContact.EmailAddress as [Primary Contact],
  alternateContact.EmailAddress as [Alternate Contact],
  d.DeliveryMethodName as [Delivery Method Name],
  t.SupplierTransactionID as [Transaction ID],
  t.TransactionDate as [Transaction Date],  
  tt.TransactionTypeName AS [Transaction Type]
FROM Purchasing.Suppliers s 

JOIN Purchasing.SupplierCategories c ON c.SupplierCategoryID = s.SupplierCategoryID
JOIN Application.People primaryContact ON primaryContact.PersonID = s.PrimaryContactPersonID
JOIN Application.People alternateContact ON alternateContact.PersonID = s.AlternateContactPersonID
LEFT JOIN Application.DeliveryMethods d ON d.DeliveryMethodID = s.DeliveryMethodID

LEFT JOIN Purchasing.SupplierTransactions t ON t.SupplierID = s.SupplierID
LEFT JOIN Application.TransactionTypes tt ON tt.TransactionTypeID = t.TransactionTypeID
ORDER BY t.TransactionTypeID

-- Другой вариант CASE 
SELECT 
  o.OrderID AS [Order ID], 
  o.OrderDate AS [Order Date], 
  o.PickingCompletedWhen AS [Picking Date],
  
  CASE datediff(d, o.OrderDate, o.PickingCompletedWhen)
    WHEN 0 THEN 'today'
    WHEN 1 THEN 'one today'
    ELSE 'more then one day'  
  END [Order and Picking Date Diff],

  cust.CustomerName AS [Customer]
FROM Sales.Orders o
JOIN Sales.Customers cust ON cust.CustomerID = o.CustomerID
WHERE
  o.PickingCompletedWhen is not null and
  cust.CustomerName like '%Toys%'
  
-- Self joins

-- Исходная таблица
SELECT * 
FROM Application.People
WHERE PersonID < 5 /* чтобы в примере было меньше строк */

-- Все пары 
SELECT 
  p1.FullName as Person1, 
  p2.FullName as Person2
FROM Application.People AS p1
JOIN Application.People AS p2
ON p1.PersonID < p2.PersonID
WHERE p1.PersonID < 5 and p2.PersonID < 5 /* чтобы в примере было меньше строк */

-- 1 - CROSS JOIN
SELECT 
  p1.PersonID as Person1_ID,
  p1.FullName as Person1_Name, 
  p2.PersonID as Person1_ID,
  p2.FullName as Person1_Name
FROM Application.People AS p1
CROSS JOIN Application.People AS p2
WHERE p1.PersonID < 5 and p2.PersonID < 5 /* чтобы в примере было меньше строк */

-- 2 - JOIN
-- p1.PersonID != p2.PersonID
SELECT 
  p1.PersonID as Person1_ID,
  p1.FullName as Person1_Name, 
  p2.PersonID as Person2_ID,
  p2.FullName as Person2_Name
FROM Application.People AS p1
JOIN Application.People AS p2 ON p1.PersonID != p2.PersonID
WHERE p1.PersonID < 5 and p2.PersonID < 5 /* чтобы в примере было меньше строк */
order by person1_id, person2_id
-- 2 - ready
SELECT 
  p1.PersonID as Person1_ID,
  p1.FullName as Person1_Name, 
  p2.PersonID as Person1_ID,
  p2.FullName as Person1_Name
FROM Application.People AS p1
JOIN Application.People AS p2 ON p1.PersonID < p2.PersonID
WHERE p1.PersonID < 5 and p2.PersonID < 5 /* чтобы в примере было меньше строк */

-----------------------------------------
-- Из ДЗ
-----------------------------------------

-- ошибка
SELECT 
  s.SupplierID,
  s.SupplierName,
  p.FullName as ContactFullName,
  p.EmailAddress as ContactEmail
FROM Purchasing.Suppliers s 
JOIN (select PersonID, FullName, EmailAddress from Application.People) p 
	ON p.PersonID = s.PrimaryContactPersonID
ORDER BY s.SupplierID

-- -- правильно
SELECT 
  s.SupplierID,
  s.SupplierName,
  p.FullName as ContactFullName,
  p.EmailAddress as ContactEmail
FROM Purchasing.Suppliers s 
JOIN Application.People p ON p.PersonID = s.PrimaryContactPersonID
ORDER BY s.SupplierID

-- логическая ошибка в join
SELECT 
    p.PersonID,
    p.FullName,
    P.PhoneNumber,
    o.OrderId
FROM Sales.Orders o 
JOIN Application.People p ON o.CustomerID = p.PersonID
