SELECT statement AS "Database.Owner.Table",user_seeks,avg_user_impact AS "Ave User Impact",equality_columns,inequality_columns,included_columns,
			avg_total_user_cost,last_user_seek,Last_user_scan,unique_compiles,user_scans, DB_NAME(database_id) dbname,object_id
 	FROM sys.dm_db_missing_index_group_stats gs 
		JOIN sys.dm_db_missing_index_groups ig ON (ig.index_group_handle = gs.group_handle)
		JOIN sys.dm_db_missing_index_details id ON (ig.index_handle = id.index_handle)
--	where db_name(database_id) = 'anet411'
	ORDER BY  statement,user_seeks DESC, Avg_user_impact DESC