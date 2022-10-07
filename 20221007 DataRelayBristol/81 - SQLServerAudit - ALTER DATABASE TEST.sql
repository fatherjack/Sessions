/*
Auditing SQL Server

*/
USE [MASTER]
GO
-- To capture permissions changes
-- create a server audit 
ALTER SERVER AUDIT [Audit-20170514-201735]
TO FILE 
(	FILEPATH = N'C:\temp\SQLAudits\'
	,MAXSIZE = 2 MB
	,MAX_FILES = 1
	,RESERVE_DISK_SPACE = OFF
)
WITH
(	QUEUE_DELAY = 1000
	,ON_FAILURE = FAIL_OPERATION
)
ALTER SERVER AUDIT [Audit-20170514-201735] WITH (STATE = ON)
GO

select * from sys.dm_os_ring_buffers where ring_buffer_type = 'RING_BUFFER_XE_LOG'

-- create server audit specification
CREATE SERVER AUDIT SPECIFICATION [ServerAuditSpecification-20170514-201927]
FOR SERVER AUDIT [Audit-20170514-201735]
ADD (DATABASE_CHANGE_GROUP)
WITH (STATE = ON)
GO

-- make an auditable change
USE [MSDB]
GO
ALTER DATABASE Adventureworks2016
SET RECOVERY SIMPLE
GO 1000

select * 
FROM FN_GET_AUDIT_FILE('C:\TEMP\SQLAudits\AUDIT-20170514*.SQLAUDIT',  
		NULL, 
		NULL);  

