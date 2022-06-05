
SELECT CustomerID, InvoiceID, InvoiceDate 
FROM Sales.Invoices
WHERE CustomerID IN 
		(SELECT CustomerID
		FROM Sales.Customers
		WHERE PostalAddressLine2 = 'Minville');
