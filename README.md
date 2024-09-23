# SQL Server
![Avatar](https://github.com/dgucc/sandbox/blob/main/tips/images/avatar.gif)  
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
## SQL Express

Start|Stop SQL Express :  SqlLocalDB.exe [start|stop] [instance] [-i nowait|-k kill]  
`> "C:\Program Files\Microsoft SQL Server\150\Tools\Binn\SqlLocalDB.exe" stop "MSSQLLocalDB" -i `  
`> "C:\Program Files\Microsoft SQL Server\150\Tools\Binn\SqlLocalDB.exe" stop "MSSQLLocalDB" -k `  
`> "C:\Program Files\Microsoft SQL Server\150\Tools\Binn\SqlLocalDB.exe" start "MSSQLLocalDB" `  

## DBeaver
**How to recover db previous passwords**  
DBeaver v23.2.5.202311191730  

**Get Key from github + python :**  
[go to github](https://github.com/dbeaver/dbeaver/blob/d69a75e63bf0a00e37f6b4ab9c9aa4fcaa0ded23/plugins/org.jkiss.dbeaver.model/src/org/jkiss/dbeaver/model/impl/app/DefaultSecureStorage.java#L32
)  
```
public class DefaultSecureStorage implements DBASecureStorage {
    private static final byte[] LOCAL_KEY_CACHE = new byte[] { -70, -69, 74, -97, 119, 74, -72, 83, -55, 108, 45, 101, 61, -2, 84, 74 };
[...]
```

**Decrypt** 
```python
$ python
>>> import struct
>>> struct.pack('<16b', -70, -69, 74, -97, 119, 74, -72, 83, -55, 108, 45, 101, 61, -2, 84, 74).hex()
'babb4a9f774ab853c96c2d653dfe544a'
```

**Decrypt previous stored passwords**  
```json
openssl aes-128-cbc -d \
  -K babb4a9f774ab853c96c2d653dfe544a \
  -iv 00000000000000000000000000000000 \
  -in " %APPDATA%\DBeaverData\workspace6\General\.dbeaver\.credentials-config.json.bak" | \
  dd bs=1 skip=16 2>/dev/null | jq
  

 {
  "db2-18bdd50d52b-3539a17d1da04651": {
    "#connection": {
      "user": "username",
      "password": "***"
    }
  },
  "db2-18bf61fac40-6a96b1f60ae10d76": {
    "#connection": {
      "user": "username",
      "password": "***"
    }
  },
  "db2-18c01312201-65b47a439b371c6c": {
    "#connection": {
      "user": "username",
      "password": "***"
    }
  },
  "db2-18c02137976-55f5c4f7710a5855": {
    "#connection": {
      "user": "username",
      "password": "***"
    }
  },
  "db2-18ee61c48e0-3865c77a810af7cc": {
    "#connection": {
      "user": "username",
      "password": "***"
    }
  }
}
```


## Cumulative Updates 
[sqlperformance](https://sqlperformance.com/latest-builds)
[sqlserverbuilds](https://sqlserverbuilds.blogspot.com/)

