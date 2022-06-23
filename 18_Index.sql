use AdventureWorks2012
go

--
SELECT RejectedQty, ((RejectedQty/OrderQty)*100) AS RejectionRate,  
    ProductID, DueDate  
FROM Purchasing.PurchaseOrderDetail  
ORDER BY RejectedQty DESC, ProductID ASC; 

--

CREATE NONCLUSTERED INDEX IX_PurchaseOrderDetail_RejectedQty  
ON Purchasing.PurchaseOrderDetail  
    (RejectedQty DESC, ProductID ASC, DueDate, OrderQty);

--
select * from sys.index_columns ;


--Using Included Columns 
CREATE INDEX IX_Document_Title   
ON Production.Document (Title, Revision)   
INCLUDE (FileName);   

--Design example
SELECT AddressLine1, AddressLine2, City, StateProvinceID, PostalCode  
FROM Person.Address  
WHERE PostalCode BETWEEN N'98000' and N'99999';  

CREATE INDEX IX_Address_PostalCode  
ON Person.Address (PostalCode)  
INCLUDE (AddressLine1, AddressLine2, City, StateProvinceID); 

--Filtered Indexes 
CREATE NONCLUSTERED INDEX FIBillOfMaterialsWithEndDate  
    ON Production.BillOfMaterials (ComponentID, StartDate)  
    WHERE EndDate IS NOT NULL ;  
GO

 --example
 SELECT ProductAssemblyID, ComponentID, StartDate   
FROM Production.BillOfMaterials  
WHERE EndDate IS NOT NULL   
    AND ComponentID = 5   
    AND StartDate > '20080101' ;


--Filtered Indexes for Heterogeneous Data
CREATE NONCLUSTERED INDEX FIProductAccessories  
    ON Production.Product (ProductSubcategoryID, ListPrice)   
        Include (Name)  
WHERE ProductSubcategoryID >= 27 AND ProductSubcategoryID <= 36;

--examples
SELECT Name, ProductSubcategoryID, ListPrice  
FROM Production.Product  
WHERE ProductSubcategoryID = 33 AND ListPrice > 25.00 ;

--индекс FIBillOfMaterialsWithEndDate покрывает следующий запрос
SELECT ComponentID, StartDate FROM Production.BillOfMaterials  
WHERE EndDate IS NOT NULL;   

--Обработчик запросов не может выполнить этот запрос без поиска значений EndDate
SELECT ComponentID, StartDate FROM Production.BillOfMaterials  
WHERE EndDate > '20040101';  

--FIBillOfMaterialsWithEndDate не покрывает следующий запрос, поскольку он 
--возвращает столбец EndDate в результатах запроса
SELECT ComponentID, StartDate, EndDate FROM Production.BillOfMaterials  
WHERE EndDate IS NOT NULL
 

 --написать отфильтрованное индексное выражение с оператором 
 --преобразования данных (CAST или CONVERT) справа от оператора сравнения
 USE AdventureWorks2012;  
GO  
CREATE TABLE dbo.TestTable (a int, b varbinary(4));  

--сообщение об ошибке 10611, поскольку преобразование происходит слева от оператора в отфильтрованном предикате
CREATE NONCLUSTERED INDEX TestTabIndex ON dbo.TestTable(a,b)  
WHERE b = 1;  

--преобразовать константу в правой части того же типа, что и столбец b
CREATE INDEX TestTabIndex ON dbo.TestTable(a,b)  
WHERE b = CONVERT(Varbinary(4), 1);  


--additional examples
-- Adding clustered index through constraint
ALTER TABLE Sales.Currency ADD CONSTRAINT PK_Currency_CurrencyCode
PRIMARY KEY CLUSTERED (CurrencyCode ASC);

-- Adding clustered index without constraint
CREATE CLUSTERED INDEX IX_Person_LastNameFirstName ON Person.Person (LastName ASC,FirstName ASC);

--Лучшим решением было бы выполнить следующие шаги:
--1. Удалите все некластеризованные индексы.
--2. Удалите кластерный индекс
--3. Создать новый кластерный индекс
--4. Повторно создайте все некластеризованные индексы (включая удаленный кластеризованный индекс как некластеризованный).

DROP INDEX AK_SalesOrderDetail_rowguid ON Sales.SalesOrderDetail;
DROP INDEX IX_SalesOrderDetail_ProductID ON Sales.SalesOrderDetail;
ALTER TABLE Sales.SalesOrderDetail
   DROP CONSTRAINT PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID;
CREATE CLUSTERED INDEX IX_SalesOrderDetail_ProductID 
   ON Sales.SalesOrderDetail (ProductID ASC);
ALTER TABLE Sales.SalesOrderDetail 
   ADD CONSTRAINT PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID
   PRIMARY KEY NONCLUSTERED (SalesOrderID ASC, SalesOrderDetailID ASC);
CREATE UNIQUE NONCLUSTERED INDEX AK_SalesOrderDetail_rowguid 
   ON Sales.SalesOrderDetail (rowguid ASC);

   --SalesOrderDetail -> SalesOrderDetail_HEAP
   --скопировал все данные из SalesOrderDetail в новую таблицу с именем SalesOrderDetail_HEAP и удалил индексы
   SELECT * FROM Sales.SalesOrderDetail_HEAP 
WHERE SalesOrderID BETWEEN 43755 AND 43759 
ORDER BY SalesOrderID, SalesOrderDetailID;

--не требуется сканирование таблицы для извлечения данных, 
--поиск по некластеризованному индексу и поиск кластеризованного индекса для получения данных
SELECT * FROM Sales.SalesOrderDetail 
WHERE ProductID = 750
ORDER BY ProductID;


-- Adding non-clustered index 
CREATE NONCLUSTERED INDEX IX_Person_LastNameFirstName ON Person.Person(LastName ASC,FirstName ASC);

CREATE INDEX IX_Person_FirstName ON Person.Person (FirstName ASC);

--covering index
CREATE NONCLUSTERED INDEX IX_Production_ProductNumber_Name 
   ON Production.Product (Name ASC,ProductNumber ASC);

SELECT ProductNumber, Name FROM Production.Product WHERE Name = 'Cable Lock';

--index with included columns
--уже существует с таким именем
CREATE NONCLUSTERED INDEX IX_Production_ProductNumber_Name
   ON Production.Product (Name ASC) INCLUDE (ProductNumber);

SELECT ProductNumber, Name FROM Production.Product WHERE Name = 'Cable Lock';

--Filtered Indexes
CREATE NONCLUSTERED INDEX IX_SalesOrderHeader_OrderDate_INC_ShipDate ON Sales.SalesOrderHeader
(OrderDate ASC) WHERE ShipDate IS NULL;

SELECT OrderDate FROM Sales.SalesOrderHeader 
WHERE ShipDate IS NULL
ORDER BY OrderDate ASC;


--columnstore index
CREATE COLUMNSTORE INDEX IX_SalesOrderDetail_ProductIDOrderQty_ColumnStore
ON Sales.SalesOrderDetail (ProductId,OrderQty);

SELECT ProductID,SUM(OrderQty)
FROM Sales.SalesOrderDetail 
GROUP BY ProductId;

--Full Text Index
CREATE FULLTEXT CATALOG fulltextCatalog AS DEFAULT;   

DROP FULLTEXT INDEX ON Production.Document;
CREATE FULLTEXT INDEX ON Production.Document(DocumentSummary) 
KEY INDEX PK_Document_DocumentNode 
WITH STOPLIST = SYSTEM;

SELECT * FROM Production.Document 
WHERE CONTAINS(DocumentSummary, 'important'); 

--XML index
--create primary XML index
CREATE PRIMARY XML INDEX PXML_Person_Demographics ON Person.Person (Demographics);

-- create secondary XML indexes уже создан на предедущем шаге с таким именем
CREATE XML INDEX XMLPATH_Person_Demographics ON Person.Person (Demographics)
  USING XML INDEX PXML_Person_Demographics FOR PATH;
CREATE XML INDEX XMLPROPERTY_Person_Demographics ON Person.Person (Demographics)
  USING XML INDEX PXML_Person_Demographics FOR PROPERTY;
CREATE XML INDEX XMLVALUE_Person_Demographics ON Person.Person (Demographics)
  USING XML INDEX PXML_Person_Demographics FOR VALUE;


;WITH XMLNAMESPACES 
('http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey' AS ns)
SELECT COUNT(1)
FROM Person.Person
WHERE Demographics.exist('(/ns:IndividualSurvey/ns:Occupation[.="Professional"])')=1;

--spatial index
CREATE SPATIAL INDEX IX_Address_SpatialLocation ON Person.Address(SpatialLocation);

--не подходящие данные поэтому показыватся не то, что ожидается
DECLARE @g geography = 'POINT(-121.626 47.8315)'; 
SELECT TOP(7) SpatialLocation.ToString(), City FROM Person.Address 
WHERE SpatialLocation.STDistance(@g) IS NOT NULL 
ORDER BY SpatialLocation.STDistance(@g); 

--SQL Server Index Maintenance
SELECT * FROM sys.dm_db_index_physical_stats  
    (DB_ID(N'AdventureWorks2017'), OBJECT_ID(N'Person.Address'), NULL, NULL , 'DETAILED'); 

-- Reorganize Определить #TableName#
  ALTER INDEX ALL ON #TableName# REORGANIZE;
  ALTER INDEX #IndexName# ON #TableName# REORGANIZE;
-- Rebuild Определить #TableName# и  #IndexName#
  ALTER INDEX ALL ON #TableName# REBUILD [WITH (ONLINE=ON)];
  ALTER INDEX #IndexName# ON #TableName# REBUILD [WITH (ONLINE=ON)];
 
SELECT * FROM sys.dm_db_index_operational_stats(DB_ID(N'AdventureWorks2017'), OBJECT_ID(N'Person.Address'), NULL, NULL); 
SELECT * FROM     SYS.DM_DB_INDEX_USAGE_STATS  

--Missing Indexes
SELECT * FROM sys.dm_db_missing_index_details

--Unused Indexes
SELECT
    objects.name AS Table_name,
    indexes.name AS Index_name,
    dm_db_index_usage_stats.user_seeks,
    dm_db_index_usage_stats.user_scans,
    dm_db_index_usage_stats.user_updates
FROM
    sys.dm_db_index_usage_stats
    INNER JOIN sys.objects ON dm_db_index_usage_stats.OBJECT_ID = objects.OBJECT_ID
    INNER JOIN sys.indexes ON indexes.index_id = dm_db_index_usage_stats.index_id AND dm_db_index_usage_stats.OBJECT_ID = indexes.OBJECT_ID
WHERE
    dm_db_index_usage_stats.user_lookups = 0
    AND
    dm_db_index_usage_stats.user_seeks = 0
    AND
    dm_db_index_usage_stats.user_scans = 0
ORDER BY
    dm_db_index_usage_stats.user_updates DESC


--check Index Fragmentation
SELECT OBJECT_NAME(ips.OBJECT_ID)
 ,i.NAME
 ,ips.index_id
 ,index_type_desc
 ,avg_fragmentation_in_percent
 ,avg_page_space_used_in_percent
 ,page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') ips
INNER JOIN sys.indexes i ON (ips.object_id = i.object_id)
 AND (ips.index_id = i.index_id)
ORDER BY avg_fragmentation_in_percent DESC
