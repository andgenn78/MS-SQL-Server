USE ClrDemo
GO

-- ===================
-- NULL
-- ===================

-- NULL
select dbo.IntAdd(1, 2)
go

select dbo.IntAdd(1, null)
go

-- Обработка NULL
select dbo.IntAdd(1, 2)
go

-- -- не работает с NULL
select dbo.IntAdd(null, 2)
go

---- работает с NULL
select dbo.IntAdd2(null, 2)
go

-- -- return null
select dbo.NullIfZero(2)
select dbo.NullIfZero(0)
go

-- ===================
-- SqlStrings
-- ===================

-- long string, nvarchar(max)
declare @ReallyLongName nvarchar(max)
set @ReallyLongName = cast(replicate('abcd', 1001) as nvarchar(max));
select @ReallyLongName
select dbo.Hello(@ReallyLongName)
