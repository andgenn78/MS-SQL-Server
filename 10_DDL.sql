USE master; 
GO 
CREATE DATABASE DDL; 
GO 
-- Verify the database files and sizes 
SELECT name, size, size*1.0/128 AS [Size in MBs]  
FROM sys.master_files 
WHERE name = N'DDL'; 
GO  

------создание базы данных с расширенными опциями
USE master; 
GO 
CREATE DATABASE DDL 
ON  
( NAME = DDL_dat, 
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\ddldat.mdf', 
    SIZE = 10, 
    MAXSIZE = 50, 
    FILEGROWTH = 5 ) 
LOG ON 
( NAME = DDL_log, 
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\ddllog.ldf', 
    SIZE = 5MB, 
    MAXSIZE = 25MB, 
    FILEGROWTH = 5MB ) ; 
GO  



USE master; 
GO 
CREATE DATABASE DDL2
ON  
( NAME = DDL_dat, 
FILENAME = '/var/opt/mssql/data/ddldat.mdf', 
    SIZE = 10, 
    MAXSIZE = 50, 
    FILEGROWTH = 5 ) 
LOG ON 
( NAME = DDL_log, 
    FILENAME = '/var/opt/mssql/data/ddllog.ldf', 
    SIZE = 5MB, 
    MAXSIZE = 25MB, 
    FILEGROWTH = 5MB ) ; 
GO  


-----с множественными файлами данных

USE master; 
GO 
CREATE DATABASE Archive  
ON 
PRIMARY   
    (NAME = Arch1, 
    FILENAME = '/var/opt/mssql/data/archdat1.mdf', 
    SIZE = 100MB, 
    MAXSIZE = 200, 
    FILEGROWTH = 20), 
    ( NAME = Arch2, 
    FILENAME = '/var/opt/mssql/data/archdat2.ndf', 
    SIZE = 100MB, 
    MAXSIZE = 200, 
    FILEGROWTH = 20), 
( NAME = Arch3, 
    FILENAME = '/var/opt/mssql/data/archdat3.ndf', 
    SIZE = 100MB, 
    MAXSIZE = 200, 
    FILEGROWTH = 20) LOG ON  
   (NAME = Archlog1, 
    FILENAME = '/var/opt/mssql/data/archlog1.ldf', 
    SIZE = 100MB, 
    MAXSIZE = 200, 
    FILEGROWTH = 20), 
   (NAME = Archlog2, 
    FILENAME = '/var/opt/mssql/data/archlog2.ldf', 
    SIZE = 100MB, 
    MAXSIZE = 200, 
    FILEGROWTH = 20) ; 
GO


----пример на attach

USE master; GO sp_detach_db Archive; 
GO 
CREATE DATABASE Archive 
      ON (FILENAME = '/var/opt/mssql/data/archdat1.mdf')  
      FOR ATTACH ; 
GO 

----снмок базы данных
USE master; 
GO 
CREATE DATABASE sales_snapshot0600 ON 
    ( NAME = SPri1_dat, FILENAME = '/var/opt/mssql/data/SPri1dat_0600.ss'), 
    ( NAME = SPri2_dat, FILENAME = '/var/opt/mssql/data/SPri2dt_0600.ss'), 
    ( NAME = SGrp1Fi1_dat, FILENAME = '/var/opt/mssql/data/SG1Fi1dt_0600.ss'), 
    ( NAME = SGrp1Fi2_dat, FILENAME = '/var/opt/mssql/data/SG1Fi2dt_0600.ss'), 
    ( NAME = SGrp2Fi1_dat, FILENAME = '/var/opt/mssql/data/SG2Fi1dt_0600.ss'), 
    ( NAME = SGrp2Fi2_dat, FILENAME = '/var/opt/mssql/data/SG2Fi2dt_0600.ss') 
AS SNAPSHOT OF Archive ; 
GO

-----сортировка
USE master; 
GO 
IF DB_ID (N'MyOptionsTest') IS NOT NULL 
DROP DATABASE MyOptionsTest; 
GO 
CREATE DATABASE MyOptionsTest 
COLLATE French_CI_AI 
WITH TRUSTWORTHY ON, DB_CHAINING ON; 
GO 
--Verifying collation and option settings. 
SELECT name, collation_name, is_trustworthy_on, is_db_chaining_on 
FROM sys.databases 
WHERE name = N'MyOptionsTest'; 
GO 


-----

EXECUTE ('CREATE DATABASE FileStreamDB 
ON PRIMARY  
    ( 
    NAME = FileStreamDB_data  
    ,FILENAME = ''' + @data_path + 'FileStreamDB_data.mdf'' 
    ,SIZE = 10MB 
    ,MAXSIZE = 50MB 
    ,FILEGROWTH = 15% 
    ), 
FILEGROUP FileStreamPhotos CONTAINS FILESTREAM DEFAULT 
    ( 
    NAME = FSPhotos 
    ,FILENAME = ''C:\myFTCatalogs\Photos'' 
-- SIZE and FILEGROWTH should not be specified here. 
-- If they are specified an error will be raised. 
, MAXSIZE = 5000 MB 
    ), 
    ( 
      NAME = FSPhotos2 
      , FILENAME = ''C:\D\myFTCatalogs\Photos'' 
      , MAXSIZE = 10000 MB 
     ), 
FILEGROUP FileStreamResumes CONTAINS FILESTREAM 
    ( 
    NAME = FileStreamResumes 
    ,FILENAME = ''C:\myFTCatalogs\Resumes'' 
    )  LOG ON 
    ( 
    NAME = FileStream_log 
    ,FILENAME = ''' + @data_path + 'FileStreamDB_log.ldf'' 
    ,SIZE = 5MB 
    ,MAXSIZE = 25MB 
    ,FILEGROWTH = 5MB 
    )' 
); 
GO 


----создание 
CREATE LOGIN student WITH PASSWORD = 'Pa$$w0rd'; 


CREATE LOGIN student1 WITH PASSWORD = 'Pa$$w0rd'
MUST_CHANGE;

----создание кредов
CREATE CREDENTIAL [StudentCredentials] WITH IDENTITY = N'WIN-01O5SCPD3P5\Guest', SECRET = N'Pa$$w0rd'
GO

CREATE LOGIN student3 WITH PASSWORD = 'Pa$$w0rd',  
    CREDENTIAL = StudentCredentials; 
GO 


-----
CREATE LOGIN [WIN-01O5SCPD3P5\vagrant] FROM WINDOWS WITH DEFAULT_DATABASE=[master]
GO 


---


spaceused


----

use Sales;

CREATE TABLE dbo.PurchaseOrderDetail 
( 
    PurchaseOrderID int NOT NULL 
        REFERENCES Purchasing.PurchaseOrderHeader(PurchaseOrderID), 
    LineNumber smallint NOT NULL, 
    ProductID int NULL  
        REFERENCES Production.Product(ProductID), 
    UnitPrice money NULL, 
    OrderQty smallint NULL,     
	ReceivedQty float NULL, 
    RejectedQty float NULL,     
	DueDate datetime NULL, 
    rowguid uniqueidentifier ROWGUIDCOL  NOT NULL 
        CONSTRAINT DF_PurchaseOrderDetail_rowguid DEFAULT (newid()), 
    ModifiedDate datetime NOT NULL  
        CONSTRAINT DF_PurchaseOrderDetail_ModifiedDate DEFAULT (getdate()), 
    LineTotal  AS ((UnitPrice*OrderQty)), 
    StockedQty  AS ((ReceivedQty-RejectedQty)), 
    CONSTRAINT PK_PurchaseOrderDetail_PurchaseOrderID_LineNumber 
               PRIMARY KEY CLUSTERED (PurchaseOrderID, LineNumber) 
               WITH (IGNORE_DUP_KEY = OFF) 
)


----

USE AdventureWorks2016; 
GO 
CREATE TABLE HumanResources.EmployeeResumes     (LName nvarchar(25), FName nvarchar(25),  
    Resume xml( DOCUMENT HumanResources.HRResumeSchemaCollection) ); 

----пример на расчитываемые столбцы

use MyDB;
CREATE TABLE dbo.mytablecalc  
    ( low int, high int, myavg AS (low + high)/2 )


----
use MyDB;
CREATE TABLE dbo.Tablesparse     
(c1 int PRIMARY KEY,     c2 varchar(50) SPARSE NULL ) ;


----


USE master; 
GO 
ALTER DATABASE MyupdDB  
ADD FILE  
( 
    NAME = Test1dat2, 
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\t1dat2.ndf', 
    SIZE = 5MB, 
    MAXSIZE = 100MB,     FILEGROWTH = 5MB 
); 
GO

----увеличение размера файла
USE master; 
GO 
ALTER DATABASE MyupdDB  
MODIFY FILE 
    (NAME = test1dat3, 
    SIZE = 20MB); 
GO  


----где tempdb
SELECT name, physical_name 
FROM sys.master_files 
WHERE database_id = DB_ID('tempdb'); 
GO 


----перемещение файлов
USE master; 
GO 
ALTER DATABASE tempdb  
MODIFY FILE (NAME = tempdev, FILENAME = 'E:\SQLData\tempdb.mdf'); 
GO 
ALTER DATABASE  tempdb  
MODIFY FILE (NAME = templog, FILENAME = 'E:\SQLData\templog.ldf'); 
GO 


---изменение статуса базы данных
USE master; 
GO 
ALTER DATABASE DBOPTION 
SET SINGLE_USER 
WITH ROLLBACK IMMEDIATE; 
GO 

---alter login
ALTER LOGIN student_alter_duble WITH PASSWORD = 'pass@w0rd1' UNLOCK ; 

----

EXEC sp_help EmplTable ; 

----

ALTER TABLE dbo.doc_exc ADD column_b VARCHAR(20) NULL  
    CONSTRAINT exb_unique UNIQUE ;


----

----изменение таблицы с заполнением по умолчанию
ADD AddDate smalldatetime NULL 
CONSTRAINT AddDateDflt 
DEFAULT GETDATE() WITH VALUES ; 


----удаление ограничения
ALTER TABLE dbo.doc_exc DROP CONSTRAINT my_constraint ; 