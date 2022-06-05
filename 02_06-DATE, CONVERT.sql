SELECT 'GETDATE' AS STFunction, GETDATE();

SELECT 'SYSDATETIME' AS STFunction, SYSDATETIME();
GO

-- MONTH, DAY, YEAR
SELECT DISTINCT o.OrderDate,
       MONTH(o.OrderDate) AS OrderMonth,
       DAY(o.OrderDate) AS OrderDay,
       YEAR(o.OrderDate) AS OrderYear
FROM Sales.Orders AS o

-- DATEPART ( datepart , date )
SELECT o.OrderID,
       o.OrderDate,
       DATEPART(m, o.OrderDate) AS OrderMonth,
       DATEPART(d, o.OrderDate) AS OrderDay,
       DATEPART(yy, o.OrderDate) AS OrderYear
FROM Sales.Orders AS o

-- -----------------------------

-- DATEDIFF ( datepart , startdate , enddate )

-- Years
SELECT DATEDIFF (yy,'2007-01-01', '2008-01-01') AS 'YearDiff';

-- Days
SELECT DATEDIFF (dd,'2007-01-01', '2008-01-01') AS 'DayDiff';

-- Months
SELECT o.OrderID,
       o.OrderDate,
       o.PickingCompletedWhen,
       DATEDIFF(mm, o.OrderDate, o.PickingCompletedWhen) AS MonthsDiff
FROM Sales.Orders o
WHERE DATEDIFF(mm, o.OrderDate, o.PickingCompletedWhen) > 0

-- DATEADD (datepart , number , date )
SELECT o.OrderID,
       o.OrderDate,
       DATEADD (yy, 1, o.OrderDate) AS DateAddOneYear,
       EOMONTH(o.OrderDate) AS EndOfMonth
FROM Sales.Orders o

-- BETWEEN date
SELECT PickingCompletedWhen, *
FROM Sales.Orders o
WHERE PickingCompletedWhen BETWEEN '2013-01-05' AND

-- DATETIME to date, CONVERT
-- Показать заказы с 2013-01-05 по 2013-01-07 включительно.
-- Есть ошибка?
SELECT
 PickingCompletedWhen,
 cast(PickingCompletedWhen as date),
 convert(nvarchar(16), PickingCompletedWhen, 104) as DateAsString,
 -- floor(cast(PickingCompletedWhen as float)) as PickingDateWithoutTime,
 *
FROM Sales.Orders o
WHERE PickingCompletedWhen BETWEEN '2013-01-05' AND '2013-01-07'

-- COLLATION
SELECT name, description  
FROM fn_helpcollations()

