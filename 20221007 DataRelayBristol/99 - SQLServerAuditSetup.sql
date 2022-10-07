/*
SETUP / RESET
*/
USE MASTER
GO
-- DROP DATABASE
if exists (select 1 from sys.databases where name = 'AuditDemoDB')
begin
	ALTER DATABASE AuditDemoDB
	SET SINGLE_USER 
	WITH ROLLBACK IMMEDIATE;

	DROP DATABASE IF EXISTS AuditDemoDB

	print 'Database AuditDemoDB dropped'
end
GO

-- AuditDataAccess and AUDIT-DATABASE_ROLE_MEMBER_CHANGE_SPECIFICATION
ALTER SERVER AUDIT SPECIFICATION [AUDIT-DATABASE_ROLE_MEMBER_CHANGE_SPECIFICATION]
WITH (STATE=OFF);

DROP SERVER AUDIT SPECIFICATION [AUDIT-DATABASE_ROLE_MEMBER_CHANGE_SPECIFICATION];
go
alter server audit [AUDIT-DATABASE_ROLE_MEMBER_CHANGE]
with (state=off)
go
DROP SERVER AUDIT [AUDIT-DATABASE_ROLE_MEMBER_CHANGE];
go
ALTER SERVER AUDIT [AuditDataAccess]
WITH (STATE=OFF);
go
DROP SERVER AUDIT [AuditDataAccess];

-- AUDIT-SQLAUDITACCESS and Monitor-fn_get_audit_file access
ALTER DATABASE AUDIT SPECIFICATION [Monitor-fn_get_audit_file access]
WITH (STATE = OFF);

DROP DATABASE AUDIT SPECIFICATION [Monitor-fn_get_audit_file access];

ALTER SERVER AUDIT [AUDIT-SQLAUDITACCESS]
WITH (STATE=OFF);

DROP SERVER AUDIT [AUDIT-SQLAUDITACCESS];


-- Delete all sqlaudit files
----------------------------
exec sp_configure 'allow updates', 0
reconfigure with override;
exec sp_configure 'show advanced options',1
reconfigure with override;
exec sp_configure 'xp_cmdshell',1
reconfigure with override;

exec xp_cmdshell 'DEL C:\temp\SQLAudits\*.sqlaudit /F'
print 'Deleted all SQL Audit files'
exec sp_configure 'xp_cmdshell',0
reconfigure
exec sp_configure 'show advanced options',0
reconfigure
