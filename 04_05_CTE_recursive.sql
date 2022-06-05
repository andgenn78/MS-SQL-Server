Declare @maxId INT = 1000;

WITH GenId (Id) AS 
(	SELECT 1 
	UNION ALL
	SELECT GenId.Id + 1
	FROM GenId 
	WHERE GenId.Id < @maxId
)
Select * 
from GenId
OPTION (MAXRECURSION 1000);
