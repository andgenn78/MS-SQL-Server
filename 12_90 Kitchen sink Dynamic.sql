ALTER PROCEDURE [dbo].[CustomerSearch_DynamicSQL]
  @CustomerID            int            = NULL,
  @CustomerName          nvarchar(100)  = NULL,
  @BillToCustomerID      int            = NULL,
  @CustomerCategoryID    int            = NULL,
  @BuyingGroupID         int            = NULL,
  @MinAccountOpenedDate  date           = NULL,
  @MaxAccountOpenedDate  date           = NULL,
  @DeliveryCityID        int            = NULL,
  @IsOnCreditHold        bit            = NULL
AS
BEGIN
  SET NOCOUNT ON;
 
  DECLARE @sql nvarchar(max) = N'
    SELECT CustomerID, CustomerName, IsOnCreditHold
      FROM Sales.Customers WHERE 1 = 1'
      + CASE WHEN @CustomerID IS NOT NULL THEN
        N' AND CustomerID = @CustomerID' ELSE N'' END
      + CASE WHEN @CustomerName IS NOT NULL THEN
        N' AND CustomerName LIKE @CustomerName' ELSE N'' END
      + CASE WHEN @CustomerName IS NOT NULL THEN
        N' AND CustomerName LIKE @CustomerName' ELSE N'' END
      + CASE WHEN @BillToCustomerID IS NOT NULL THEN
        N' AND BillToCustomerID = @BillToCustomerID' ELSE N'' END
      + CASE WHEN @CustomerCategoryID IS NOT NULL THEN
        N' AND CustomerCategoryID = @CustomerCategoryID' ELSE N'' END
      + CASE WHEN @BuyingGroupID IS NOT NULL THEN
        N' AND BuyingGroupID = @BuyingGroupID' ELSE N'' END
      + CASE WHEN @MinAccountOpenedDate IS NOT NULL THEN
        N' AND AccountOpenedDate >= @MinAccountOpenedDate' ELSE N'' END
      + CASE WHEN @MaxAccountOpenedDate IS NOT NULL THEN
        N' AND AccountOpenedDate <= @MaxAccountOpenedDate' ELSE N'' END
      + CASE WHEN @DeliveryCityID IS NOT NULL THEN
        N' AND DeliveryCityID = @DeliveryCityID' ELSE N'' END
      + CASE WHEN @IsOnCreditHold IS NOT NULL THEN
        N' AND IsOnCreditHold = @IsOnCreditHold' ELSE N'' END;
 
    DECLARE @params nvarchar(max) = N'
      @CustomerID            int,
      @CustomerName          nvarchar(100),
      @BillToCustomerID      int,
      @CustomerCategoryID    int,
      @BuyingGroupID         int,
      @MinAccountOpenedDate  date,
      @MaxAccountOpenedDate  date,
      @DeliveryCityID        int,
      @IsOnCreditHold        bit';
 
    PRINT @sql;
 
    EXEC sys.sp_executesql @sql, @params, 
      @CustomerID,
      @CustomerName,
      @BillToCustomerID,
      @CustomerCategoryID,
      @BuyingGroupID,
      @MinAccountOpenedDate,
      @MaxAccountOpenedDate,
      @DeliveryCityID,
      @IsOnCreditHold;
END