select *
from Sales.Customers
WHERE CustomerName like 'J%'
ORDER BY CustomerID

select *
from Sales.Customers FOR System_Time AS OF '20130101'
WHERE CustomerName like 'J%'	
ORDER BY CustomerID

select *
from Sales.Customers FOR System_Time BETWEEN '20130101' AND '20130501'
WHERE CustomerName like 'J%'	
ORDER BY CustomerID

select *
from Sales.Customers FOR System_Time FROM '20130101' To '20130501'
WHERE CustomerName like 'J%'	
ORDER BY CustomerID

select *
from Sales.Customers FOR System_Time CONTAINED IN ('20130501' ,'20190212')
WHERE CustomerName like 'J%'	
ORDER BY CustomerID

select *
from Sales.Customers FOR System_Time ALL
WHERE CustomerName like 'J%'	
ORDER BY CustomerID, ValidFrom 