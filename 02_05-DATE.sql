SELECT max(OrderDate )
FROM [Sales].[Orders]

SET DATEFORMAT mdy
SELECT *
FROM [Sales].[Orders]
WHERE OrderDate > '01.05.2016' -- ןעמו םגאנ
ORDER BY OrderDate
GO


SET DATEFORMAT dmy
SELECT *
FROM [Sales].[Orders]
WHERE OrderDate > '01.05.2016' -- ןונגמו לא
ORDER BY OrderDate
GO

SET DATEFORMAT mdy
SELECT *
FROM [Sales].[Orders]
WHERE OrderDate > '20160501' -- ןונגמו לא
ORDER BY OrderDate
GO

SET DATEFORMAT mdy
SELECT *
FROM [Sales].[Orders]
WHERE OrderDate > '2016-05-01' -- ןונגמו לא
ORDER BY OrderDate
GO
