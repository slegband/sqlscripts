/****************************************************************************************************/
/* Index detail DMVs							 */
/****************************************************************************************************/
SELECT DB_NAME(database_id) DBName, OBJECT_NAME(si.object_id) AS Tablename, Name "Index Name", type_desc, user_seeks,user_scans,user_lookups,user_updates,last_user_seek,
	last_user_scan,last_user_lookup,last_user_update,system_seeks,system_scans,system_lookups,system_updates       
	last_system_seek, last_system_scan,last_system_lookup,last_system_update
FROM sys.dm_db_index_usage_stats ius
	 JOIN sys.indexes si ON si.object_id = ius.object_id
--where db_name(database_id) = 'anet411'   --Use this to get a specific database.
WHERE --user_scans = 0 and ius.user_lookups = 0 and ius.user_updates = 0  /* gets not used indexes  */
--AND 
Name LIKE '%GL%'  OR name LIKE '%Reconciliations%'
ORDER BY OBJECT_NAME(si.object_id), name