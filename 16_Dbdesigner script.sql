create schema dbd
CREATE TABLE dbd.[Customer] (
	CustomerId integer NOT NULL,
	CustomerName varchar(200) NOT NULL,
  CONSTRAINT [PK_CUSTOMER] PRIMARY KEY CLUSTERED
  (
  [CustomerId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
CREATE TABLE dbd.[Order] (
	OrderId BIGINT NOT NULL,
	OrderDate datetime NOT NULL,
	CustomerId integer NOT NULL,
  CONSTRAINT [PK_ORDER] PRIMARY KEY CLUSTERED
  (
  [OrderId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO

ALTER TABLE dbd.[Order] WITH CHECK ADD CONSTRAINT [Order_fk0] FOREIGN KEY ([CustomerId]) REFERENCES dbd.[Customer]([CustomerId])
ON UPDATE CASCADE
GO
ALTER TABLE dbd.[Order] CHECK CONSTRAINT [Order_fk0]
GO

 