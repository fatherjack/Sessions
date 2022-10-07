
--- Auditing data access (ie SELECT, UPDATE, etc)
-------------------------------------------------
use master
go
drop database if exists TestDB
go
CREATE DATABASE TestDB;  
GO  
USE TestDB;  
GO  
CREATE SCHEMA DataSchema;  
GO  
CREATE TABLE DataSchema.GeneralTable (ID INT IDENTITY PRIMARY KEY, GeneralData varchar(50) NOT NULL);  
GO  
CREATE TABLE DataSchema.ImportantTable (ID INT IDENTITY PRIMARY KEY, SensitiveData varchar(50) NOT NULL);  
GO  
insert DataSchema.GeneralTable(GeneralData) values ('Andrew'),('Brenda'),('Clive'),('Denise'),('Edward'),('Fiona'),('Gregory'),('Harriet')
insert DataSchema.ImportantTable(SensitiveData) values ('Ian'),('Julie'),('Ken'),('Lucy'),('Mike'),('Nell'),('Orlando'),('Patricia')

-- Create the server audit in the master database  
USE MASTER;  
GO  
CREATE SERVER AUDIT AuditDataAccess  
    TO SECURITY_LOG
WITH
(	QUEUE_DELAY = 1000 /* milliseconds */
	,ON_FAILURE = CONTINUE /* FAILOPERATION / SHUTDOWN */
) 
	WHERE object_name = 'ImportantTable';  
GO  

ALTER SERVER AUDIT AuditDataAccess WITH (STATE = ON);  
GO  

-- if this fails then the SQLServer Service account has to be configured to create event log entries

-- Msg 33222, Level 16, State 1, Line 127
-- Audit 'AuditDataAccess' failed to start . For more information, see the SQL Server error log.

-- SQL Server Audit failed to access the security log. 
-- Make sure that the SQL service account has the required permissions to access the security log.

-- via PS or CMD
-- auditpol /set /subcategory:"application generated" /success:enable /failure:enable

-- via secpol.msc 
-- Local Policies | User Rights Assignment | Generate Security Audits
-- Local Security Setting ... Add User or Group ... Add SQL Server Service Account
-- AND
-- Local Policies | Audit Policy
-- Audit object access ... select Success and Failure

-- Create the DATABASE audit specification in the AuditDemoDBdatabase  
USE TestDB;  
GO  
CREATE DATABASE AUDIT SPECIFICATION [FilterForSensitiveData]  
FOR SERVER AUDIT [AuditDataAccess]   
-- we want to capture SELECT statements
ADD (SELECT ON SCHEMA::[DataSchema] BY [public])  
WITH (STATE = ON);  
GO  

-- Trigger the audit event by selecting from tables  
SELECT ID, GeneralData FROM DataSchema.GeneralTable;  
SELECT ID, SensitiveData FROM DataSchema.ImportantTable; 
go

-- to change the specification to include UPDATES 
-- we hve to disable the Specification
ALTER DATABASE AUDIT SPECIFICATION [FilterForSensitiveData]
WITH (STATE=OFF);
go

-- make the change by adding the UPDATE
ALTER DATABASE AUDIT SPECIFICATION [FilterForSensitiveData]  
FOR SERVER AUDIT [AuditDataAccess]   
ADD (UPDATE ON SCHEMA::[DataSchema] BY [public])  
GO

-- then turn on the specification again
ALTER DATABASE AUDIT SPECIFICATION [FILTERFORSENSITIVEDATA]
WITH (STATE=ON);
GO

-- make some data changes that chould be audited
INSERT DATASCHEMA.ImportantTable(SensitiveData) VALUES('JONATHAN');

UPDATE DATASCHEMA.ImportantTable SET SensitiveData = 'ANNETTE' WHERE ID = 1;

UPDATE DATASCHEMA.ImportantTable SET SensitiveData = 'ANNETTE' WHERE 1/0 = 1;
GO  

-- what about where a process tries to access data that is secured 
-- within SQL Server - ie a user has no access to a table?

USE TestDB
GO

CREATE USER RestrictedUser WITHOUT LOGIN;

GRANT IMPERSONATE ON USER::RestrictedUser to [foundry\Jonathan];

ALTER ROLE [db_datareader] ADD MEMBER [RestrictedUser]
GO

-- test the user out
execute as user = 'RestrictedUser';

select * from DataSchema.GeneralTable;

select * from DataSchema.ImportantTable;
go

revert;
go

use [TestDB]
GO
DENY SELECT ON [DataSchema].[importanttable] TO [RestrictedUser]
GO


-- test the user out now
execute as user = 'RestrictedUser';

select * from DataSchema.GeneralTable;

select * from DataSchema.ImportantTable;
go

revert;
go

-- Important points to consider with Auditing

-- File sizes and location.

-- What is the audit for?
-- How long will you retain the data? 
-- Should you retain the data? 
-- What rules will apply to the data?

-- what if an audit shuts down down my instance? Will the audit stop my instance starting too?
-- Failure to write to the audit output can have one of 3 consequences
--	1 - Conitinue - the event will take place but the audit of the event will be lost.
--	2 - Fail - the attempted action will be failed because we cant audit the event taking place
--	3 - Shutdown - If we cant audit the event then the SQL Servive will be shutdown
--	If the service shutsdown and then restarts and cant write to the audit then we could be in a problem.
--	we have to use specific startup flags to start with the audit disabled

-- how might an audit stop?
--	admin user intervention. full destination

-- Windows Event Log settings
--	size / rollover settings probably need changing from default

-- what happens if I restore a database that had a database audit to a server where there is no server audit?


-- how secure is the audit data when logged?
--	file target - ACLs will be only defence. File can be edited in Notepad etc
--	log target - Sysadmin permission may be able to wipe/clear data etc

