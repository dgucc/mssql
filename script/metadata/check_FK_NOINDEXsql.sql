/*
https://www.mssqltips.com/sqlservertip/5004/script-to-identify-all-nonindexed-foreign-keys-in-a-sql-server-database/
*/
use PUBS
go
WITH v_NonIndexedFKColumns AS (
   SELECT 
      Object_Name(a.parent_object_id) AS Table_Name
      ,b.NAME AS Column_Name
   FROM 
      sys.foreign_key_columns a
      ,sys.all_columns b
      ,sys.objects c
   WHERE 
      a.parent_column_id = b.column_id
      AND a.parent_object_id = b.object_id
      AND b.object_id = c.object_id
      AND c.is_ms_shipped = 0
   EXCEPT
   SELECT 
      Object_name(a.Object_id)
      ,b.NAME
   FROM 
      sys.index_columns a
      ,sys.all_columns b
      ,sys.objects c
   WHERE 
      a.object_id = b.object_id
      AND a.key_ordinal = 1
      AND a.column_id = b.column_id
      AND a.object_id = c.object_id
      AND c.is_ms_shipped = 0
   )
SELECT 
   v.Table_Name AS NonIndexedCol_Table_Name
   ,v.Column_Name AS NonIndexedCol_Column_Name             
   ,fk.NAME AS Constraint_Name   
   ,SCHEMA_NAME(fk.schema_id) AS Ref_Schema_Name       
   ,object_name(fkc.referenced_object_id) AS Ref_Table_Name      
   ,c2.NAME AS Ref_Column_Name         
FROM 
   v_NonIndexedFKColumns v
   ,sys.all_columns c
   ,sys.all_columns c2
   ,sys.foreign_key_columns fkc
   ,sys.foreign_keys fk
WHERE 
   v.Table_Name = Object_Name(fkc.parent_object_id)
   AND v.Column_Name = c.NAME
   AND fkc.parent_column_id = c.column_id
   AND fkc.parent_object_id = c.object_id
   AND fkc.referenced_column_id = c2.column_id
   AND fkc.referenced_object_id = c2.object_id
   AND fk.object_id = fkc.constraint_object_id
ORDER BY 1,2

/*
Output :

NonIndexedCol_Table_Name         NonIndexedCol_Column_Name        Constraint_Name                  Ref_Schema_Name                  Ref_Table_Name                   Ref_Column_Name
-------------------------------- -------------------------------- -------------------------------- -------------------------------- -------------------------------- --------------------------------
discounts                        stor_id                          FK__discounts__stor___3C69FB99   dbo                              stores                           stor_id
employee                         job_id                           FK__employee__job_id__48CFD27E   dbo                              jobs                             job_id
employee                         pub_id                           FK__employee__pub_id__4BAC3F29   dbo                              publishers                       pub_id
titles                           pub_id                           FK__titles__pub_id__2E1BDC42     dbo                              publishers                       pub_id

(4 rows affected)
*/