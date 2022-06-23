USE ClrDemo
GO

-- Deterministic vs NotDeterministic
select dbo.SumDeterministic(1, 2), dbo.SumNondeterministic(1, 2)

create table Table1
(
	a int,
	b int,
	summa as dbo.SumDeterministic(a, b) persisted
)

create table Table2
(
	a int,
	b int,
	summa as dbo.SumNondeterministic(a, b) persisted
)


-- Data Access
drop table if exists Table3
go
create table Table3 (col1 int)
go
insert into Table3 values(1),(2),(3),(4),(5),(6)
go

select * from Table3
go
select dbo.CountBiggerThen(3)
go
select dbo.CountBiggerThen(5)
go

-- Table valued functions
select * from dbo.Splitter('a, ab, abc', ',')

