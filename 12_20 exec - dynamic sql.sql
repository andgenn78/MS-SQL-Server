EXEC ('SELECT 1 AS ValueDynamic');

EXEC ('SELECT top 20 CustomerName, CustomerId FROM Sales.Customers WHERE CustomerID = 1');

Declare @CustomerName NVARCHAR(50),
	@command NVARCHAR(4000);

SET @CustomerName = 'Tailspin Toys (Guin, AL)'

SET @command = 'SELECT top 20 CustomerName, CustomerId 
				FROM Sales.Customers WHERE CustomerName = '''+@CustomerName+''''; 

SELECT @command;

EXEC (@command);


--- SQL INJECTION
Declare @CustomerName NVARCHAR(50),
	@command NVARCHAR(4000);

SET @CustomerName = 'Tailspin Toys (Guin, AL)'' OR 1 = 1 --'

SET @command = 'SELECT top 20 CustomerName, CustomerId 
FROM Sales.Customers WHERE CustomerName = '''+@CustomerName+''''; 

SELECT @command;

EXECute (@command);

----

Declare @CustomerName NVARCHAR(50),
	@command NVARCHAR(4000),
	@param NVARCHAR(4000);

SET @CustomerName = 'Tailspin Toys (Guin, AL)'

SET @command = 'SELECT top 20 CustomerName, CustomerId 
			FROM Sales.Customers WHERE CustomerName = '+QUOTENAME(@CustomerName,''''); 

SELECT @command;

--EXEC (@command);
SET @param = '@CustomerName NVARCHAR(50)'

EXEC sp_executesql @command, @param, @CustomerName;

Declare @CustomerName NVARCHAR(50),
	@command NVARCHAR(4000),
	@param NVARCHAR(4000);

SET @CustomerName = 'Tailspin Toys (Guin, AL)'

SET @command = 'SELECT top 20 CustomerName, CustomerId 
			FROM Sales.Customers WHERE CustomerName = @CustomerName'; 

SELECT @command;
SET @param = '@CustomerName NVARCHAR(50)'

EXEC sp_executesql @command, @param, @CustomerName;


Declare @CustomerName NVARCHAR(50),
	@command NVARCHAR(4000);

SET @CustomerName = 'Tailspin Toys (Guin, AL)'' OR 1 =1 --'

SET @command = 'SELECT top 20 CustomerName, CustomerId 
			FROM Sales.Customers WHERE CustomerName = '+QUOTENAME(@CustomerName,''''); 

SELECT @command;

EXEC (@command);

Declare @table NVARCHAR(50),
	@schema NVARCHAR(50),
	@command NVARCHAR(4000);

SET @schema = 'Sales'
SET @table = 'Orders'

SET @command = 'SELECT top 20 * FROM '+QUOTENAME(@schema)+'.'+QUOTENAME(@table); 

SELECT @command;

EXEC (@command);



DECLARE @query NVARCHAR(4000),
		@sort NVARCHAR(100),
		@cnt INT = 10,
		@debug TINYINT = 1;

SET @sort = 'CustomerId'

SET @query = 'SELECT top '+ CAST(@cnt AS VARCHAR(10))
	+' CustomerName, CustomerId FROM Sales.Customers ORDER BY '+@sort+';'

IF @debug >0 
	PRINT @query;

EXEC sp_executesql @query;



DECLARE @query NVARCHAR(4000),
		@sort NVARCHAR(100),
		@cnt INT = 10;

SET @sort = 'CreditLimit DESC; DROP TABLE dbo.test'

SET @query = 'SELECT top '+ CAST(@cnt AS VARCHAR(10))
	+' CustomerName, CustomerId FROM Sales.Customers ORDER BY '+@sort+';'

PRINT @query;
EXEC sp_executesql @query;

--CREATE TABLE dbo.test (id INT);

SELECT top 20 CustomerName, CustomerId 
FROM Sales.Customers 
WHERE CustomerID = 1