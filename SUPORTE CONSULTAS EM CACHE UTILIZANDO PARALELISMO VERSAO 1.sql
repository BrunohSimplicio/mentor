SELECT TOP(20)
    st.[text] AS [SqlText],
    cp.cacheobjtype,
    cp.objtype,
    DB_NAME(st.[dbid]) AS [DatabaseName],
    cp.usecounts,
    qp.query_plan
FROM
    sys.dm_exec_cached_plans cp
    CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
    CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) qp
WHERE
    cp.cacheobjtype = 'Compiled Plan'
    AND qp.query_plan.value('declare namespace p="http://schemas.microsoft.com/sqlserver/2004/07/showplan"; max(//p:RelOp/@Parallel)', 'float') > 0
ORDER BY
    cp.usecounts DESC;