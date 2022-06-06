
DECLARE @query NVARCHAR(4000),
		@sort NVARCHAR(100),
		@cnt INT = 10,
		@PersonId INT, 
		@Name NVARCHAR(200);

SET @PersonId = 1;

SET @query = N'SELECT top '+CAST(@cnt AS NVARCHAR(50))+' PersonId, FullName, IsEmployee 
	FROM Application.People
	WHERE PersonId = '+CAST(@PersonId AS NVARCHAR(50));

PRINT @query;
EXEC (@query);

SET @Name = 'Amy Trefl'

SET @query = N'SELECT top '+CAST(@cnt AS NVARCHAR(50))+' PersonId, FullName, IsEmployee 
	FROM Application.People
	WHERE FullName = '''+@Name+'''';

PRINT @query;
EXEC (@query);



SET @Name = 'Amy Trefl'' OR 1=1--'

SET @query = N'SELECT top '+CAST(@cnt AS NVARCHAR(50))+' PersonId, FullName, IsEmployee 
	FROM Application.People
	WHERE FullName = '''+@Name+'''';

PRINT @query;
EXEC (@query);

DECLARE @query NVARCHAR(4000),
		@sort NVARCHAR(100),
		@cnt INT = 10,
		@PersonId INT, 
		@Name NVARCHAR(200);

SET @Name = 'Amy Trefl'' UNION ALL 
SELECT null, loginname COLLATE Latin1_General_100_CI_AS, null FROM sys.syslogins; --'

SET @query = N'SELECT top '+CAST(@cnt AS NVARCHAR(50))+' PersonId, FullName, IsEmployee 
	FROM Application.People
	WHERE FullName = '''+@Name+'''';

PRINT @query;
EXEC (@query);


DECLARE @query NVARCHAR(4000),
		@sort NVARCHAR(100),
		@cnt INT = 10;

SET @sort = 'CreditLimit DESC; DROP TABLE dbo.test'

SET @query = 'SELECT top '+ CAST(@cnt AS VARCHAR(10))
	+' CustomerName, CustomerId FROM Sales.Customers ORDER BY '+@sort+';'

PRINT @query;
EXEC sp_executesql @query;