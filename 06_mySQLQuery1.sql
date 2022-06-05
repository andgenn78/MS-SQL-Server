USE master
GO

CREATE DATABASE [Roga and copita]


GO
USE [Roga and copita]
GO

---DROP TABLE Заказы


CREATE TABLE Заказы (Код INT IDENTITY, Дата DATE, Товар NVARCHAR(50), Количество INT, Цена MONEY, Стоимость AS Цена * Количество);


INSERT Заказы(Дата, Товар, Количество, Цена)
VALUES	 ('20220101', N'Товар1', 5, 1)
		,('20220101', N'Товар2', 3, 1)
		,('20220102', N'Товар3', 4, 1)
		,('20220203', N'Товар1', 5, 2)
		,('20220201', N'Товар3', 2, 1)
		,('20220302', N'Товар4', 3, 1)
		,('20220303', N'Товар5', 4, 1)
		,('20220401', N'Товар1', 5, 1)
		,('20220403', N'Товар3', 1, 1)
		,('20210104', N'Товар5', 2, 2)
		,('20210104', N'Товар6', 3, 1)
		,('20210107', N'Товар4', 3, 1)
		,('20210108', N'Товар1', 4, 3)
		,('20210209', N'Товар2', 5, 4)
		,('20210201', N'Товар5', 3, 5)
		,('20210203', N'Товар7', 6, 6)
		,('20210304', N'Товар8', 3, 7)
		,('20210305', N'Товар1', 7, 8)
		,('20210306', N'Товар2', 3, 1)

SELECT * FROM Заказы;

SELECT	*
		, ROUND(100 * Стоимость / SUM(Стоимость) OVER(), 2) AS [Процент] 
		, SUM(Стоимость) OVER() AS [Итого за все время]
		, SUM(Стоимость) OVER(PARTITION BY YEAR(Дата)) AS [Итого по году]
		, SUM(Стоимость) OVER(PARTITION BY MONTH(Дата)) AS [Итого по месяцу]
		, SUM(Стоимость) OVER(PARTITION BY [Товар]) AS [Итого по товару]
		, SUM(Стоимость) OVER(PARTITION BY YEAR(Дата), MONTH(Дата)) AS [Итог по году и месяцу]
		, ROUND(100 * SUM(Стоимость) OVER(PARTITION BY YEAR(Дата), MONTH(Дата))/SUM(Стоимость) OVER(PARTITION BY YEAR(Дата)),2) AS [Процент месяца от года]
FROM	Заказы;


SELECT	*
		,SUM(Стоимость) OVER(ORDER BY Дата ROWS UNBOUNDED PRECEDING) AS [Итого с накоплением]
		,SUM(Стоимость) OVER(PARTITION BY YEAR(Дата) ORDER BY Дата ROWS UNBOUNDED PRECEDING) AS [Итого с накоплением по году]
FROM	Заказы;


SELECT	*
		,SUM(Стоимость) OVER(ORDER BY Дата ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [ROWS Итого с накоплением]
		,SUM(Стоимость) OVER(ORDER BY Дата RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [RANGE Итого с накоплением]
FROM	Заказы;


SELECT	*
		,SUM(Стоимость) OVER(PARTITION BY YEAR(Дата) ORDER BY Дата ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [ROWS Итого с накоплением]
		,SUM(Стоимость) OVER(PARTITION BY YEAR(Дата) ORDER BY Дата RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [RANGE Итого с накоплением]
FROM	Заказы;


SELECT	*
		,SUM(Стоимость) OVER(PARTITION BY YEAR(Дата), MONTH(Дата) ORDER BY Дата ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [ROWS Итого с накоплением]
		,SUM(Стоимость) OVER(PARTITION BY YEAR(Дата), MONTH(Дата) ORDER BY Дата RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [RANGE Итого с накоплением]
FROM	Заказы;


SELECT	*
		, SUM(Стоимость) OVER(PARTITION BY YEAR(Дата) ORDER BY Дата ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING) AS [Два предыдущих]
FROM	Заказы;

SELECT	*
		, SUM(Стоимость) OVER(PARTITION BY YEAR(Дата) ORDER BY Дата ROWS BETWEEN 1 FOLLOWING AND 2 FOLLOWING) AS [Два последующих]
		, SUM(Стоимость) OVER(PARTITION BY YEAR(Дата) ORDER BY Дата ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS [Пред+Тек+След]
		, SUM(Стоимость) OVER(PARTITION BY YEAR(Дата) ORDER BY Дата ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) AS [Pre+..]
FROM	Заказы
ORDER BY Код;

SELECT	*
		, SUM(Стоимость) OVER(PARTITION BY YEAR(Дата) ORDER BY Дата ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS [Все пред]
FROM	Заказы
ORDER BY Код;

SELECT	*
		, SUM(Стоимость) OVER(ORDER BY Дата) [Сумма до текущего] ---RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		, SUM(Стоимость) OVER(ORDER BY Дата RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) [Сумма до текущего2] ---
FROM	Заказы;


SELECT	*
		, MAX(Товар) OVER(ORDER BY Код, Дата ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS [Пред строка]
FROM	Заказы;


SELECT	*
		, LAG(Товар) OVER(ORDER BY Код, Дата) AS [Пред строка]
FROM	Заказы;