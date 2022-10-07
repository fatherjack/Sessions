-- Seeing what audits are configured on your servers
----------------------------------------------------
use master
go

-- SERVER audit information
select * from sys.server_audits
select * from sys.server_audit_specifications
select * from sys.server_audit_specification_details
select * from sys.server_file_audits

-- DATABASE audit information
select * from sys.database_audit_specifications
select * from sys.database_audit_specification_details

-- general information
select dsas.name, dsas.status_desc , dsas.status_time, dsas.audit_file_path, dsas.audit_file_size
from sys.[dm_server_audit_status] as dsas

-- current server audits
select sa.name, 
	sa.is_state_enabled, 
	sa.[type_desc], 
	sa.on_failure_desc, 
	isnull(sa.[predicate],'') as [Predicate], 
 	sa.create_date, 
	ISNULL((sfa.log_file_path + '\' + sfa.log_file_name),sa.[type_desc]) as [Audit file]
from sys.server_audits as sa
left join sys.server_audit_specifications as sas
on sa.audit_guid = sas.audit_guid
left join sys.server_file_audits as sfa
on sa.audit_guid = sfa.audit_guid

-- current database audit specifications
select das.name, 
	das.create_date, 
	das.modify_date, 
	das.is_state_enabled, 
	dasd.audit_action_name, 
	dasd.class_desc, 
	dasd.audited_result
from sys.database_audit_specifications as das
inner join sys.database_audit_specification_details dasd
on das.database_specification_id = dasd.database_specification_id


-- Combined information
select sa.[name], 
	sa.[is_state_enabled], 
	sa.[type_desc], 
	sa.[on_failure_desc], 
	isnull(sa.[predicate],'') as [Predicate], 
 	sa.[create_date], 
	das.[name], 
	das.create_date,
	das.modify_date, 
	das.is_state_enabled, 
	dasd.audit_action_name,
	dasd.class_desc,
	dasd.audited_result,
	ISNULL((sfa.log_file_path + '\' + sfa.log_file_name),sa.[type_desc]) as [Audit file]
from sys.server_audits as sa
left join sys.server_audit_specifications as sas
on sa.audit_guid = sas.audit_guid
left join sys.server_file_audits as sfa
on sa.audit_guid = sfa.audit_guid
left join sys.database_audit_specifications as das
on das.audit_guid = sa.audit_guid
left join sys.database_audit_specification_details dasd
on das.database_specification_id = dasd.database_specification_id