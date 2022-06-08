BEGIN TRAN

SELECT PersonId, FullName, PreferredName,  PhoneNumber
FROM Application.People
WHERE FullName = 'Kayla Woodcock'
AND IsEmployee = 1;

UPDATE Sales.Orders
SET Comments = 'Deadlock simulation orders'
WHERE SalespersonPersonID = 2
	AND OrderId IN (73535, 73537, 73545);


----Transaction (Process ID 61) was deadlocked on lock resources with another process and has been chosen as the deadlock victim. Rerun the transaction.

UPDATE Application.People
SET PhoneNumber = '(495) 777-0304'
WHERE PersonID = 2;

SELECT * 
FROM Application.People
WHERE PersonID = 2;

SELECT *
FROM Sales.Orders
WHERE OrderId IN (73535, 73537, 73545);

ROLLBACK TRAN