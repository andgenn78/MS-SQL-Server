
  select sum(invoiceLines.UnitPrice) OVER (Partition by invoices.CustomerId) AS SumByCustomer,
  sum(invoiceLines.UnitPrice) OVER (Partition by invoices.CustomerId ORDER BY invoiceLines.InvoiceLineId)  AS SumByCustomerSort,
  invoiceLines.UnitPrice,invoiceLines.InvoiceLineId,
  invoices.*, invoiceLines.*
  from [Sales].[Invoices] AS invoices
	join [Sales].[InvoiceLines] as invoiceLines
		ON invoiceLines.InvoiceID = invoices.InvoiceId
  WHERE Invoices.InvoiceDate > '2016-05-01'
  ORDER BY invoices.CustomerId,invoiceLines.InvoiceLineId;

  select lag(ExtendedPrice,2) over (ORDER BY InvoiceId),
	lag(ExtendedPrice) over (ORDER BY InvoiceId),
	ExtendedPrice,
	*
  from [Sales].[InvoiceLines];

  select lag(ExtendedPrice,2) over (ORDER BY InvoiceLineId) as lag_2_offset,
	lag(ExtendedPrice) over (ORDER BY InvoiceLineId) as lag,
	SUM(ExtendedPrice) over (PARTITION BY InvoiceId ORDER BY InvoiceLineId) as summ,
	MAX(ExtendedPrice) over (PARTITION BY InvoiceId) as maxsumm,
	SUM(ExtendedPrice) over (PARTITION BY InvoiceId ORDER BY InvoiceLineId ROWS BETWEEN current row and 1 Following) as summ_unbound,
	ExtendedPrice,
	*
  from [Sales].[InvoiceLines]
  ORDER BY InvoiceId,InvoiceLineId;

