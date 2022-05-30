--https://www.sqlservertutorial.net/sql-server-administration/sql-server-differential-backup/
use master;
if exists(select * from sysdatabases where name='hr') begin
     alter database hr set single_user with rollback immediate
     drop database if exists hr;
end
go

create database hr;
go
alter database hr set multi_user
alter database hr set recovery full;

use hr;
go

create table People (
     id int identity primary key,
     firstname varchar(50) not null,
     lastname varchar(50) not null
);

insert into People (firstname, lastname) values ('John', 'Doe');

-- full backup #1
backup database hr to disk = 'D:\Backup\hr\hr_diff.bak'
with INIT, name='hr-Full database backup';

insert into People (firstname, lastname) values ('Jane', 'Doe');

-- differential backup #1
backup database hr to disk='D:\Backup\hr\hr_diff.bak'
with DIFFERENTIAL, name=N'hr-Differential database backup';

insert into People (firstname, lastname) values ('Upton', 'Luis');

-- differential backup #2
backup database hr to disk=N'D:\Backup\hr\hr_diff.bak'
with DIFFERENTIAL, name=N'hr-Differential database backup'

-- full backup #2
backup database hr to disk = 'D:\Backup\hr\hr_diff.bak'
with NOINIT, name='hr-Full database backup';

insert into People (firstname, lastname) values ('Dash', 'Keon');

-- differential backup #3
backup database hr to disk=N'D:\Backup\hr\hr_diff.bak'
with DIFFERENTIAL, name=N'hr-Differential database backup'

-- display backup files
restore headeronly from disk=N'D:\Backup\hr\hr_diff.bak';

use master;
go
alter database hr set single_user with rollback immediate;
--1 : drop database
drop database if exists hr;
--2 : restore the last full backup
restore database hr from disk=N'D:\Backup\hr\hr_diff.bak'
with file=4, NORECOVERY;
--3 : restore the last differential backup restore database hr from disk=N'D:\Backup\hr\hr_diff.bak'
restore database hr from disk=N'D:\Backup\hr\hr_diff.bak'
with file=5, RECOVERY;

alter database hr set multi_user
go


use hr;
go
select * from People;

