# SQL Server

## Sample DB **AdventureWorks**

Download backup files :
[AdventureWorks](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak)  

Identify logical filenames contained in the backup set
```sql
use master
go
RESTORE FILELISTONLY FROM DISK = 'D:\Backup\AdventureWorks\AdventureWorks2019.bak' WITH FILE = 1  
```
Restore **AdventureWorks** (WITH MOVE...TO... REPLACE)  
```mssql
RESTORE DATABASE AdventureWorksSample
FROM disk= 'D:\Backup\AdventureWorks\AdventureWorks2019.bak'
WITH MOVE 'AdventureWorks2017' 
TO 'D:\DATA\AdventureWorksSample.mdf',
MOVE 'AdventureWorks2017_Log' 
TO 'D:\LOG\AdventureWorksSample.ldf',
REPLACE
```

## T-SQL

Backup-Restore  

Example : differential backup  
[SQL Server Differential Backup](https://www.sqlservertutorial.net/sql-server-administration/sql-server-differential-backup/)  

Example : log backup  
[SQL Server Transaction Log Backup](https://www.sqlservertutorial.net/sql-server-administration/sql-server-transaction-log-backup/)  

## Detach/Attach Database  
```mssql
USE [master]
GO
EXEC MASTER.dbo.sp_detach_db @dbname = N'MyDatabase'
GO
...
CREATE DATABASE [MyDatabase]  ON 
	(FILENAME ='C:\DATA\MyDatabase.mdf'), 
	(FILENAME = 'C:\DATA\MyDatabase_log.ldf') 
FOR ATTACH; 
```

## SQLCMD  
 -S : server name  
 -E : Trusted Connection  
```mssql
sqlcmd -S 127.0.0.1 -E -i instnwnd.sql -o log/instnwnd.log  
```

Specify UTF-8  
```mssql
> sqlcmd -S 127.0.0.1 -i dml.sql -f 65001
```

## Cumulative Updates 
[sqlperformance](https://sqlperformance.com/latest-builds)
[sqlserverbuilds](https://sqlserverbuilds.blogspot.com/)

