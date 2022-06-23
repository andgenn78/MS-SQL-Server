USE ClrDemo
GO

DECLARE @phone PhoneNumber
SET @phone = '5105495930'
SELECT @phone, @phone.ToString()
GO

-- Валидация
DECLARE @phone PhoneNumber
SET @phone = '123'
GO

-- Но можно и через свойство
DECLARE @phone PhoneNumber
SET @phone = '0000000000'
SET @phone.Number = '5105495930'
SELECT @phone, @phone.ToString()
GO

-- Пример с таблицей
CREATE TABLE Employees
(
	Name nvarchar(20),
	Phone PhoneNumber
)
GO

INSERT INTO Employees VALUES('empl_1', '9001234567')
GO

SELECT * FROM Employees e
GO

-- ошибка
INSERT INTO Employees VALUES('empl_2', '1234567')
GO

SELECT 
 e.Name, 
 e.Phone, 
 e.Phone.ToString() as Phone_ToString,
 e.Phone.ToFormattedString() as Phone_FormattedString
FROM Employees e
GO

-- WHERE
SELECT 
 e.Name, 
 e.Phone, 
 e.Phone.ToString() as Phone_ToString,
 e.Phone.ToFormattedString() as Phone_FormattedString
FROM Employees e
WHERE e.Phone = '9001234567'
GO

-- А так будет работать?
INSERT INTO Employees VALUES('empl_3', '900 123-45-67')

DROP TABLE Employees
GO

-- Просмотр CLR-типов 
SELECT *
FROM sys.types
WHERE is_assembly_type = 1

-- Удаление типа
DROP TYPE PhoneNumber

-- Ручное создание типа
CREATE TYPE PhoneNumber
EXTERNAL NAME ClrDemo.PhoneNumber
