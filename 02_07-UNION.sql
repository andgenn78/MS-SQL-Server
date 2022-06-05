-- Задачка вывести в одном столбце
select 'a' as Col1
union
select 'b' as Col2
union
select 'c' as Col3
go

-- Значения null считаются одинаковыми
select null 
union 
select null

select null 
union all
select null
go

-- а в WHERE нет !
select 1 
where null = null

-- Что быстрее UNION или UNION ALL?
select 'a'
union all
select 'b'

select 'a'
union
select 'b'
go

-- Совместимость по типам 
-- ошибка
select 'a'
union 
select 123
go

select 'a'
union 
select cast(1 as nchar(1))
go




