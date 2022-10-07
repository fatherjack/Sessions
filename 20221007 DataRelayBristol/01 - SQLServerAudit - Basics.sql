/*
Auditing SQL Server

*/
USE [MASTER]
GO
-- To capture permissions changes
-- create a server audit 
CREATE SERVER AUDIT [AUDIT-DATABASE_ROLE_MEMBER_CHANGE]
TO FILE /* APPLICATION_LOG / SECURITY_LOG */
(	FILEPATH = N'C:\TEMP\SQLAudits\' -- \\C:\TEMP\SQLAudits\
	,MAXSIZE = 30 MB
	,MAX_FILES = 4
	,RESERVE_DISK_SPACE = ON
)
WITH
(	QUEUE_DELAY = 1000 /* milliseconds */
)
GO

-- create server audit specification
CREATE SERVER AUDIT SPECIFICATION [AUDIT-DATABASE_ROLE_MEMBER_CHANGE_SPECIFICATION]
FOR SERVER AUDIT [AUDIT-DATABASE_ROLE_MEMBER_CHANGE]
ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP)
GO

-- turn the audit on !
USE MASTER
GO
ALTER SERVER AUDIT [AUDIT-DATABASE_ROLE_MEMBER_CHANGE]
WITH (STATE = ON)
go

-- yep, we have to start the Audit specification too ...
ALTER SERVER AUDIT SPECIFICATION [AUDIT-DATABASE_ROLE_MEMBER_CHANGE_SPECIFICATION] 
WITH (STATE = ON);

-- make an auditable change
USE [MSDB]
GO
ALTER ROLE [SQLAGENTOPERATORROLE] ADD MEMBER [DATABASEMAILUSERROLE]
GO


-- default location == C:\PROGRAM FILES\MICROSOFT SQL SERVER\MSSQL13.SQL2016\MSSQL\LOG

-- Notes

--	Audit files will be created in the specified location as 
--		- a .sqlaudit file type
--		- The file name will start with the name of the SQL Server Audit name

-- the active Audit file has the size of the Reserve_Disk_Space value but when the audit is dropped 
--		from the server the file size drops to just the size required for the data written


