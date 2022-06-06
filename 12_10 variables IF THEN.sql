
--вариант 1
DECLARE @CustomerId INT,
		@TransactionDate DATE, 
		@InvoiceDate DATE;

--вариант 2

Declare @InvoiceId INT;
DECLARE @CustomerName NVARCHAR(100);

--Одинаковое ли будет значение?
SELECT 
	@InvoiceId = InvoiceID
FROM Sales.CustomerTransactions
ORDER BY TransactionDate DESC;

select @InvoiceId

SELECT TOP 1
	@InvoiceId = InvoiceID,
	@TransactionDate = TransactionDate
FROM Sales.CustomerTransactions
ORDER BY TransactionDate DESC;

select @InvoiceId


SELECT 
	@InvoiceDate = InvoiceDate,
	@CustomerId = CustomerId
FROM Sales.Invoices
WHERE InvoiceId = @InvoiceId

SELECT 
	@CustomerName = CustomerName
FROM Sales.Customers
WHERE CustomerID = @CustomerId;

SELECT @InvoiceId AS InvoiceId, @InvoiceDate AS InvoiceDate, @CustomerId AS CustomerId, @CustomerName AS CustomerName
, @TransactionDate AS TD

SELECT DATEDIFF(dd, @TransactionDate, @InvoiceDate) AS paymentLag;

--вариант 1
IF @TransactionDate = @InvoiceDate
	SELECT 'Great customer';

--вариант 2
IF (@TransactionDate = @InvoiceDate)
	SELECT 'Great customer';
ELSE 
	SELECT 'So so';


IF DATEDIFF(dd, @TransactionDate, @InvoiceDate) < 2
BEGIN
	SELECT 'Great customer';
END
ELSE 
BEGIN
	SELECT 'So so';
END

SELECT
  IIF(
    (client.CustomerName like 'Tailspin%') OR (client.BillToCustomerID = 1),
    'Tailspin Toys',
    'Smb else')
  AS locale,
  client.* 
FROM Sales.Customers AS client

--вариант 1
DECLARE @CustomerId INT,
		@TransactionDate DATE, 
		@InvoiceDate DATE;
--вариант 2
Declare @InvoiceId INT;
DECLARE @CustomerName NVARCHAR(100);

SELECT TOP 1
	@InvoiceId = InvoiceID,
	@TransactionDate = TransactionDate
FROM Sales.CustomerTransactions
ORDER BY TransactionDate DESC;
SELECT 
	@InvoiceDate = InvoiceDate,
	@CustomerId = CustomerId
FROM Sales.Invoices
WHERE InvoiceId = @InvoiceId

SELECT 
	@CustomerName = CustomerName
FROM Sales.Customers
WHERE CustomerID = @CustomerId;

SELECT @InvoiceId AS InvoiceId, @InvoiceDate AS InvoiceDate, @CustomerId AS CustomerId, @CustomerName AS CustomerName
, @TransactionDate AS TD, DATEDIFF(dd, @TransactionDate, @InvoiceDate)

--к чему относится ELSE? 
IF DATEDIFF(dd, @TransactionDate, @InvoiceDate) < 2
BEGIN
	IF @CustomerId = 1
		SELECT 'Great customer';
END
ELSE 
	SELECT 'So so';

DECLARE @error INT = 0,
		@vip   INT = -1;

--antipattern
IF DATEDIFF(dd, @TransactionDate, @InvoiceDate) < 2
	IF @CustomerId != 1 
		IF @TransactionDate > '20150101'
			IF @CustomerName IS NOT NULL 
				IF @CustomerName like '%toys%'
					SET @vip = 1
				ELSE
					SET @vip = 0
			ELSE
				SET @error = 100 --кривое имя
		ELSE
		BEGIN
			IF @TransactionDate > '20140101'
				SET @error = 300; --старый
			ELSE
				SET @error = 320; --очень старый
		END
	ELSE
		SET @error = 200; --задержан платеж
ELSE
	SET @error = 530; --задержан платеж

select @error as error, @vip AS vip;

---- correct
DECLARE @error INT,
		@vip   INT;
DECLARE @CustomerId INT,
		@TransactionDate DATE, 
		@InvoiceDate DATE;
--вариант 2
Declare @InvoiceId INT;
DECLARE @CustomerName NVARCHAR(100);
SET @error = -1;
SET @vip = -1;

IF DATEDIFF(dd, @TransactionDate, @InvoiceDate) < 2
	SET @error = 0;
ELSE 
	SET @error = 530;

IF @error = 0 
BEGIN
	IF @CustomerId != 1
		--делаем что то полезное
		SET @error = 0;
	ELSE 
		SET @error = 200;
END;

IF @error = 0 
BEGIN
	IF @TransactionDate > '20150101'
		SET @error = 0; --старый
	ELSE
		SET @error = 300; --должно уточниться на следующей проверке
END;

IF @error = 300 
BEGIN
	IF @TransactionDate > '20140101' AND @TransactionDate < '20150101'
		SET @error = 300; --старый
	ELSE
		SET @error = 320; --очень старый
END;

IF @error = 0 
BEGIN
	IF @CustomerName IS NOT NULL 
		SET @error = 0; 
		--что-то считаем
	ELSE
		SET @error = 100; --кривое имя
END;
				

IF @error = 0 
BEGIN
	IF @CustomerName like '%toys%'
		SET @vip = 1;
	ELSE
		SET @vip = 0;
END;



select @error as error, @vip AS vip;
	
--Варианты можно посмотреть в теме https://www.sqlteam.com/forums/topic.asp?TOPIC_ID=53185

