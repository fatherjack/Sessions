-- How to see what can be audited - sys.dm_audit_actions

--  sys.dm_audit_actions holds all events that can be audited
select * from sys.dm_audit_actions

-- Server audit events
select * from sys.dm_audit_actions
where parent_class_desc = 'server'

-- Database audit events
select * from sys.dm_audit_actions
where parent_class_desc = 'database'

-- All the Database Audit Actions
select distinct daa.name
from sys.dm_audit_actions as daa
where parent_class_desc = 'database'

-- What classes have specific actions
select distinct name, daa.class_desc, daa.covering_parent_action_name
from sys.dm_audit_actions as daa
where daa.name in ('SELECT','INSERT','UPDATE','DELETE')
order by daa.class_desc

-- If we audit a group, what will that include
select daa.action_id, daa.name, daa.class_desc, daa.covering_action_name, daa.parent_class_desc 
from sys.dm_audit_actions as daa
where daa.covering_action_name = 'DATABASE_CHANGE_GROUP';


select daa.action_id, daa.[name], daa.class_desc
from sys.dm_audit_actions as daa
where action_id = 'R';

-- Finding Actions by filtering on group name
select daa.[name], 
	daa.class_desc, daa.containing_group_name
from sys.dm_audit_actions as daa
where containing_group_name like '%permission%';


select * from sys.dm_audit_actions 
where action_id in ('UP','SL', 'DL','IN')

-- Class type names are the same as securable names except for these
select * from sys.dm_audit_class_type_map as dactm
where dactm.class_type_desc <> dactm.securable_class_desc

