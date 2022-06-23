use WideWorldImporters

-- Включаем CLR
exec sp_configure 'show advanced options', 1;
go
reconfigure;
go
exec sp_configure 'clr enabled', 1;
exec sp_configure 'clr strict security', 0 
go
reconfigure;
go

-- Подключаем dll 
CREATE ASSEMBLY DemoAssembly
FROM 'D:\otus\mssql\CLR\ClrDemo\Simple\bin\Debug\Simple.dll'
WITH PERMISSION_SET = SAFE;  

-- DROP ASSEMBLY DemoAssembly

-- Посмотреть подключенные сборки (SSMS: Programmability -> Assemblies)
SELECT * FROM sys.assemblies
GO

-- Подключить функцию из dll
CREATE FUNCTION dbo.fn_Multiply(@Num1 int, @Num2 int)  
RETURNS int
AS EXTERNAL NAME DemoAssembly.Demo.Multiply;  
GO 

-- Подключить процедуру из dll
CREATE PROCEDURE dbo.sp_GetCustomer  
(  
    @CustomerID int
)  
AS EXTERNAL NAME DemoAssembly.Demo.GetCustomer;  
GO 

-- Проверяем, что создали ХП и функцию
SELECT assembly_id, assembly_class, assembly_method
from sys.assembly_modules

-- Используем функцию
select dbo.fn_Multiply(2,3)

-- Используем
exec dbo.sp_GetCustomer @customerId = 17;