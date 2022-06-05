
SELECT *
FROM Application.People
WHERE PersonId IN (SELECT SalespersonPersonID FROM Sales.Invoices);

SELECT *
FROM Application.People
WHERE EXISTS (SELECT SalespersonPersonID 
	FROM Sales.Invoices
	WHERE SalespersonPersonID = People.PersonID);