USE ClrDemo
GO

DROP TABLE IF EXISTS Table1
GO
CREATE TABLE Table1 (Col1 int)
GO

INSERT INTO Table1
VALUES (1), (NULL), (2), (NULL), (3)
GO

SELECT * FROM Table1

SELECT 
(SELECT Sum(Col1) FROM Table1) as [Sum(Col1)],
(SELECT dbo.SumWithNull(Col1) FROM Table1) as [SumWithNull(Col1)]

GO

-- TrimmedAvg
CREATE TABLE Table2 (Col1 decimal)
GO

INSERT INTO Table2
VALUES (1), (2), (3), (4)
GO

SELECT  
	SUM(Col1) as [SUM],	
	AVG(Col1) as [Avg],
	dbo.TrimmedAvg(Col1) as [TrimmedAvg]
FROM Table2

DROP TABLE Table2

-- Просмотр агрегатов 
SELECT *
FROM sys.objects
WHERE type = 'AF'

-- Ручное создание агрегата
CREATE AGGREGATE TrimmedAvg
EXTERNAL NAME ClrDemo.TrimmedAvg

-- Удаление агрегата
DROP AGGREGATE TrimmedAvg