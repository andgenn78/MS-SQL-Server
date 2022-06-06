--DBCC FREEPROCCACHE

SELECT TOP 10
		databases.name,
	dm_exec_sql_text.text AS TSQL_Text,
	dm_exec_query_stats.creation_time, 
	dm_exec_query_stats.execution_count,
	dm_exec_query_stats.total_worker_time AS total_cpu_time,
	dm_exec_query_stats.total_elapsed_time, 
	dm_exec_query_stats.total_logical_reads, 
	dm_exec_query_stats.total_physical_reads, 
	dm_exec_query_plan.query_plan
FROM sys.dm_exec_query_stats 
CROSS APPLY sys.dm_exec_sql_text(dm_exec_query_stats.plan_handle)
CROSS APPLY sys.dm_exec_query_plan(dm_exec_query_stats.plan_handle)
INNER JOIN sys.databases
ON dm_exec_sql_text.dbid = databases.database_id
WHERE dm_exec_sql_text.text LIKE '%Customers%';

--Kimberly L. Tripp 
SELECT 
	qp.*
FROM sys.dm_exec_cached_plans  as qp

select cacheobjtype, refcounts, usecounts, size_in_bytes, objectid, dbid 
from sys.dm_exec_cached_plans 
	cross apply sys.dm_exec_query_plan(plan_handle)
where objtype='proc' 
	and objectid = object_id('OrdersSearch_DynamicSql')


 SELECT objtype, cacheobjtype, 
  AVG(usecounts) AS Avg_UseCount, 
  SUM(refcounts) AS AllRefObjects, 
  SUM(CAST(size_in_bytes AS bigint))/1024/1024 AS Size_MB
FROM sys.dm_exec_cached_plans
WHERE objtype = 'Adhoc' AND usecounts = 1
GROUP BY objtype, cacheobjtype;


SELECT *
FROM sys.configurations
WHERE name = 'optimize for ad hoc workloads';