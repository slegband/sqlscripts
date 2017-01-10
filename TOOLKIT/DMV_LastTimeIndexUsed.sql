SELECT t.name "Table Name", 
i.name AS index_name, STATS_DATE(i.object_id, i.index_id) AS statistics_update_date, 
	Fill_Factor, i.Type_desc AS "Type Of Index"
   --, t.create_date Table_create_date, t.Modify_date Table_modify_date
FROM sys.indexes i JOIN sys.tables t ON i.object_id = t.object_id
ORDER BY "Table Name", i.Type_desc,index_name