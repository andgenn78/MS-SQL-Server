-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Sales.GetNewInvoices (@batchsize INT = 100)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP (@batchsize) 
		InvoiceID
		,CustomerID
		,BillToCustomerID
		,OrderID + 1000 
		,DeliveryMethodID
		,ContactPersonID
		,AccountsPersonID
		,SalespersonPersonID
		,PackedByPersonID
		,InvoiceDate
		,CustomerPurchaseOrderNumber
		,IsCreditNote
		,CreditNoteReason
		,Comments
		,DeliveryInstructions
		,InternalComments
		,TotalDryItems
		,TotalChillerItems
		,DeliveryRun
		,RunPosition
		,ReturnedDeliveryData
		,[ConfirmedDeliveryTime]
		,[ConfirmedReceivedBy]
		,LastEditedBy
		,GETDATE()
	FROM Sales.Invoices
	WHERE InvoiceDate >= '2016-01-01' 
		AND InvoiceDate < '2016-04-01';
END
GO
