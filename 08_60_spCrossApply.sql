CREATE procedure [dbo].[spGatherIndexUsage]
AS
/*


create table dbo.gatherIndexUsage (dbname nvarchar(100), index_name nvarchar(200), procedurename nvarchar(200), cacheobjtype nvarchar(100),Objtype nvarchar(100),
						ScanCount int,  SeekCount int, UpdateCount int, RefCount int, UseCount int, queryplan nvarchar(max), createdAt datetime default getdate())
exec opsdb.dbo.spGatherIndexUsage

*/
begin
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	--drop table #result
	--select * from #result
	create table #result (dbname nvarchar(100), index_name nvarchar(200), procedurename nvarchar(200), cacheobjtype nvarchar(100),Objtype nvarchar(100),
						ScanCount int,  SeekCount int, UpdateCount int, RefCount int, UseCount int, queryplan xml)	

	DECLARE @IndexName AS NVARCHAR(128) = 'IX_DataFile_HierarchyId_Active';

	-- Make sure the name passed is appropriately quoted 
	IF (LEFT(@IndexName, 1) <> '[' AND RIGHT(@IndexName, 1) <> ']') SET @IndexName = QUOTENAME(@IndexName); 

	
	WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
	insert into #result (dbname, index_name, procedurename, cacheobjtype,Objtype,
						ScanCount,  SeekCount, UpdateCount, RefCount, UseCount, queryplan)
	SELECT
		DB_NAME(E.dbid) AS [DBName],@IndexName as indexname,
		object_name(E.objectid, dbid) AS [ObjectName],
		P.cacheobjtype AS [CacheObjType],
		P.objtype AS [ObjType],
		E.query_plan.query('count(//RelOp[@LogicalOp = ''Index Scan'' or @LogicalOp = ''Clustered Index Scan'']/*/Object[@Index=sql:variable("@IndexName")])').value('/', 'int')  AS [ScanCount],
		E.query_plan.query('count(//RelOp[@LogicalOp = ''Index Seek'' or @LogicalOp = ''Clustered Index Seek'']/*/Object[@Index=sql:variable("@IndexName")])').value('/', 'int')  AS [SeekCount],
		E.query_plan.query('count(//Update/Object[@Index=sql:variable("@IndexName")])').value('/', 'int')  AS [UpdateCount],
		P.refcounts AS [RefCounts],
		P.usecounts AS [UseCounts],
		E.query_plan AS [QueryPlan]
	FROM sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_query_plan(P.plan_handle) E
	WHERE E.query_plan.exist('//*[@Index=sql:variable("@IndexName")]') = 1
	OPTION(MAXDOP 1, RECOMPILE);

	SET @IndexName = 'IX_DataFile_HierarchyId_DirId_Active_Name';

	-- Make sure the name passed is appropriately quoted 
	IF (LEFT(@IndexName, 1) <> '[' AND RIGHT(@IndexName, 1) <> ']') SET @IndexName = QUOTENAME(@IndexName); 

	WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
	insert into #result (dbname, index_name, procedurename, cacheobjtype,Objtype,
						ScanCount,  SeekCount, UpdateCount, RefCount, UseCount, queryplan)
	SELECT
		DB_NAME(E.dbid) AS [DBName],@IndexName as indexname,
		object_name(E.objectid, dbid) AS [ObjectName],
		P.cacheobjtype AS [CacheObjType],
		P.objtype AS [ObjType],
		E.query_plan.query('count(//RelOp[@LogicalOp = ''Index Scan'' or @LogicalOp = ''Clustered Index Scan'']/*/Object[@Index=sql:variable("@IndexName")])').value('/', 'int')  AS [ScanCount],
		E.query_plan.query('count(//RelOp[@LogicalOp = ''Index Seek'' or @LogicalOp = ''Clustered Index Seek'']/*/Object[@Index=sql:variable("@IndexName")])').value('/', 'int')  AS [SeekCount],
		E.query_plan.query('count(//Update/Object[@Index=sql:variable("@IndexName")])').value('/', 'int')  AS [UpdateCount],
		P.refcounts AS [RefCounts],
		P.usecounts AS [UseCounts],
		E.query_plan AS [QueryPlan]
	FROM sys.dm_exec_cached_plans P
	CROSS APPLY sys.dm_exec_query_plan(P.plan_handle) E
	WHERE E.query_plan.exist('//*[@Index=sql:variable("@IndexName")]') = 1
	OPTION(MAXDOP 1, RECOMPILE);

	SET @IndexName = 'IX_DataFileMachine_MachineId_HierarchyId_DirId';

	-- Make sure the name passed is appropriately quoted 
	IF (LEFT(@IndexName, 1) <> '[' AND RIGHT(@IndexName, 1) <> ']') SET @IndexName = QUOTENAME(@IndexName); 

	WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
	insert into #result (dbname, index_name, procedurename, cacheobjtype,Objtype,
						ScanCount,  SeekCount, UpdateCount, RefCount, UseCount, queryplan)
	SELECT
		DB_NAME(E.dbid) AS [DBName], @IndexName as indexname,
		object_name(E.objectid, dbid) AS [ObjectName],
		P.cacheobjtype AS [CacheObjType],
		P.objtype AS [ObjType],
		E.query_plan.query('count(//RelOp[@LogicalOp = ''Index Scan'' or @LogicalOp = ''Clustered Index Scan'']/*/Object[@Index=sql:variable("@IndexName")])').value('/', 'int')  AS [ScanCount],
		E.query_plan.query('count(//RelOp[@LogicalOp = ''Index Seek'' or @LogicalOp = ''Clustered Index Seek'']/*/Object[@Index=sql:variable("@IndexName")])').value('/', 'int')  AS [SeekCount],
		E.query_plan.query('count(//Update/Object[@Index=sql:variable("@IndexName")])').value('/', 'int')  AS [UpdateCount],
		P.refcounts AS [RefCounts],
		P.usecounts AS [UseCounts],
		E.query_plan AS [QueryPlan]
	FROM sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_query_plan(P.plan_handle) E
	WHERE E.query_plan.exist('//*[@Index=sql:variable("@IndexName")]') = 1
	OPTION(MAXDOP 1, RECOMPILE);

	select dbname, index_name, procedurename, cacheobjtype,Objtype,
						ScanCount,  SeekCount, UpdateCount, RefCount, UseCount, cast (queryplan as nvarchar(max)) as queryplan 
	from #result

	drop table #result
end
