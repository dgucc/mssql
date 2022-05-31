# SQL Server

## Sample DB

Download backup files :
[AdventureWorks](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak)  

Identify logical filenames contained in a backup set
```sql
use master
go
RESTORE FILELISTONLY FROM DISK = 'D:\Backup\AdventureWorks\AdventureWorks2019.bak' WITH FILE = 1  
```
Restore **AdventureWorks** and rename DB  
```mssql
RESTORE DATABASE AdventureWorksSample
FROM disk= 'D:\Backup\AdventureWorks\AdventureWorks2019.bak'
WITH MOVE 'AdventureWorks2017' 
TO 'N:\DATA\AdventureWorksSample.mdf',
MOVE 'AdventureWorks2017_Log' 
TO 'K:\LOG\AdventureWorksSample.ldf',
REPLACE
```


## Backup - Restore : example

[SQL Server Differential Backup](https://www.sqlservertutorial.net/sql-server-administration/sql-server-differential-backup/)  

[SQL Server Transaction Log Backup](https://www.sqlservertutorial.net/sql-server-administration/sql-server-transaction-log-backup/)  
