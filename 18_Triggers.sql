---https://metanit.com/sql/sqlserver/12.2.php

---Для рассмотрения операций с триггерами определим следующую базу данных productsdb:
CREATE DATABASE productsdb;
GO
USE productsdb;
CREATE TABLE Products
(
    Id INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price MONEY NOT NULL
);
CREATE TABLE History 
(
    Id INT IDENTITY PRIMARY KEY,
    ProductId INT NOT NULL,
    Operation NVARCHAR(200) NOT NULL,
    CreateAt DATETIME NOT NULL DEFAULT GETDATE(),
);

--- Определим триггер, который будет срабатывать после добавления:
USE productsdb
GO
CREATE TRIGGER Products_INSERT
ON Products
AFTER INSERT
AS
INSERT INTO History (ProductId, Operation)
SELECT Id, 'Добавлен товар ' + ProductName + '   фирма ' + Manufacturer
FROM INSERTED


--- Выполним добавление данных в Products и получим данные из таблицы History:


USE productsdb;
INSERT INTO Products (ProductName, Manufacturer, ProductCount, Price)
VALUES('iPhone X', 'Apple', 2, 79900),
	('Mi', 'Android', 1, 79900)
 
SELECT * FROM History


--- Удаление данных
--- При удалении все удаленные данные помещаются в виртуальную таблицу DELETED:

USE productsdb
GO
CREATE TRIGGER Products_DELETE
ON Products
AFTER DELETE
AS
INSERT INTO History (ProductId, Operation)
SELECT Id, 'Удален товар ' + ProductName + '   фирма ' + Manufacturer
FROM DELETED

--- Выполним команду на удаление:
USE productsdb;
DELETE FROM Products
WHERE Id=2
 
SELECT * FROM History


--- Изменение данных

--- Создадим триггер обновления:

USE productsdb
GO
CREATE TRIGGER Products_UPDATE
ON Products
AFTER UPDATE
AS
INSERT INTO History (ProductId, Operation)
SELECT Id, 'Обновлен товар ' + ProductName + '   фирма ' + Manufacturer
FROM INSERTED


USE productsdb;

UPDATE Products
SET ProductCount=33
FROM Products
WHERE Id = 1
 
SELECT * FROM History