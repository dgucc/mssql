--https://www.sqlservertutorial.net/sql-server-administration/sql-server-transaction-log-backup/

use master;
-- drop database
if exists(select * from sysdatabases where name='hr') 
begin
	alter database hr set single_user with rollback immediate
	drop database if exists hr;
end
go
-- create database
create database hr;
go
alter database hr set multi_user
-- set recovery mode to FULL
alter database hr set recovery full;

use hr;
go
-- create table
create table People (
	id int identity primary key,
	firstname varchar(50) not null,
	lastname varchar(50) not null
);

insert into People (firstname, lastname) values ('John', 'Doe');
-- create 1st full backup
backup database hr to disk = 'D:\Backup\hr\hr.bak' --5
with init, name='hr-Full database backup';

insert into People (firstname, lastname) values ('Jane', 'Doe');
-- 1st log backup
backup log hr to disk='D:\Backup\hr\hr.bak' --7
with name=N'hr-Transaction log backup';

insert into People (firstname, lastname) values ('Upton', 'Luis');
-- 2d log backup
backup log hr to disk=N'D:\Backup\hr\hr.bak' --9
with name=N'hr-Transaction log backup'
-- 2d full backup
backup database hr to disk=N'D:\Backup\hr\hr.bak' --10
with noinit, name='hr-Full database backup';

insert into People (firstname, lastname) values ('Dash', 'Keon');
-- 3d log backup
backup log hr to disk=N'D:\Backup\hr\hr.bak' --9
with name=N'hr-Transaction log backup'

-- display backup files
restore headeronly from disk=N'D:\Backup\hr\hr.bak';

use master;
go
alter database hr set single_user with rollback immediate;
--1 : drop database
drop database if exists hr;
--2 : restore the last full backup
restore database hr from disk=N'D:\Backup\hr\hr.bak'
with file=4, norecovery;
--3 : restore the following log
restore log hr from disk=N'D:\Backup\hr\hr.bak'
with file=5, recovery;

alter database hr set multi_user
go

use hr;
go
select * from People;