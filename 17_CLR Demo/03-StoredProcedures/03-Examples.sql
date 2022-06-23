USE ClrDemo
GO

declare @result int;
exec dbo.[Add] 3, 4, @result output;
select @result;
go 

-- а если передать null
declare @result int;
exec dbo.[Add] 3, null, @result output;
select @result;
go 

-- ref SqlInt32 result
declare @result int;
set @result = 100;
exec dbo.Inc 10,  @result output;
select @result
go 

declare @result int;
set @result = 100;
exec dbo.Inc 10,  @result output;
exec dbo.Inc 10,  @result output;
exec dbo.Inc 10,  @result output;
select @result
go 

-- ================
-- SqlPipe
-- ================
exec dbo.Echo 'hello message'

-- Генерирование ResultSet
exec dbo.Fibonacci 2, 3, 10


-- sp_GetBigOrdersCount
drop table if exists Table3
go
create table Table3 (col1 int)
go
insert into Table3 values(1),(2),(3),(4),(5),(6)
go

exec dbo.sp_CountBiggerThen 3

exec dbo.sp_CountBiggerThen 5

-- GetAllObjects
exec GetAllObjects

