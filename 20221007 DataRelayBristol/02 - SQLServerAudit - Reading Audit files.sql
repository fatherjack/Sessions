
-- reviewing the contents of the audit file
-- All .SQLAUDIT files in the specified location
select * 
FROM FN_GET_AUDIT_FILE('C:\TEMP\SQLAudits\*.SQLAUDIT', 
		DEFAULT,
		DEFAULT);  
GO

-- All .SQLAUDIT files for a specified audit in the specified location
select * 
FROM FN_GET_AUDIT_FILE('C:\TEMP\SQLAudits\AUDIT-DATABASE_ROLE_MEMBER_CHANGE_*.SQLAUDIT',  
		NULL, 
		NULL);  
GO

SELECT	*, CAST(ADDITIONAL_INFORMATION AS XML) AS ADDITIONALINFO
FROM FN_GET_AUDIT_FILE('C:\TEMP\SQLAudits\AUDIT-DATABASE_ROLE_MEMBER_CHANGE_*.SQLAUDIT',DEFAULT,DEFAULT);  
GO


SELECT 
	a.EVENT_TIME,
	a.action_id,
	daa.name as [ActionDesc],
	dactm.class_type_desc as ActionName,
	a.SESSION_ID,
	a.object_id,
	a.CLASS_TYPE,
	dactm.class_type_desc as [ClassTypeDesc],
	a.SESSION_SERVER_PRINCIPAL_NAME,
	a.SERVER_PRINCIPAL_NAME,
	a.SERVER_PRINCIPAL_SID,
	a.DATABASE_PRINCIPAL_NAME,
	a.TARGET_SERVER_PRINCIPAL_NAME,
	a.TARGET_DATABASE_PRINCIPAL_NAME,
	a.SERVER_INSTANCE_NAME,
	a.DATABASE_NAME,
	a.SCHEMA_NAME,
	a.OBJECT_NAME,
	a.STATEMENT,
	CAST(a.ADDITIONAL_INFORMATION AS XML) AS ADDITIONALINFO
FROM FN_GET_AUDIT_FILE('C:\TEMP\SQLAudits\AUDIT-*.SQLAUDIT',DEFAULT,DEFAULT) as a
inner join sys.dm_audit_class_type_map as dactm -- to get class type description
on a.class_type = dactm.class_type
inner join sys.dm_audit_actions as daa -- to get action id description
on daa.action_id = a.action_id;  
GO



-- disable an audit
USE MASTER
GO
ALTER SERVER AUDIT [AUDIT-DATABASE_ROLE_MEMBER_CHANGE]
WITH (STATE = OFF)
GO

-- disable an audit specification
ALTER SERVER AUDIT SPECIFICATION [AUDIT-DATABASE_ROLE_MEMBER_CHANGE_SPECIFICATION] 
WITH (STATE = OFF);
GO

-- if either are OFF then the events taking place will not be audited

-- reenable an audit
USE MASTER
GO
ALTER SERVER AUDIT [AUDIT-DATABASE_ROLE_MEMBER_CHANGE]
WITH (STATE = ON)
GO

-- reenable an audit specification
ALTER SERVER AUDIT SPECIFICATION [AUDIT-DATABASE_ROLE_MEMBER_CHANGE_SPECIFICATION] 
WITH (STATE = ON);
GO
-- when the audit / audit specification are restarted they will be logging to a new file


-- SSMS (both types)
-- Server | Security | Audits | [right click chosen audit] | View Audit Logs
-- File | Open | Merge Audit Files

-- Powershell ( for the event log)
-- Get-WinEvent -FilterHashtable @{logname='security'; id=33205}

-- Windows Event Viewer (event log)

-- FN_GET_AUDIT_FILE
-- C:\PROGRAM FILES\MICROSOFT SQL SERVER\MSSQL13.SQL2016\MSSQL\LOG\
-- Audit Name: AUDIT-DATABASE_ROLE_MEMBER_CHANGE
-- Audit GUID: 3D39630C-32DF-4330-AA96-B9E1246C0434
-- C:\PROGRAM FILES\MICROSOFT SQL SERVER\MSSQL13.SQL2016\MSSQL\LOG\AUDIT-DATABASE_ROLE_MEMBER_CHANGE_3D39630C-32DF-4330-AA96-B9E1246C0434.SQLAUDIT
