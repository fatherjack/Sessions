/*
To visualise the hierarchy of SQL Server Audit Events and their parent groups

I think this was originally on the Microsoft official SQL Server Books online and it possibly still is. I can however never 
find it when I need it so I have taken an adjusted version and pasted it here for easy access.

Thanks to unknown Microsoft employee that got their head around the CTE and Event relationships logic to come up with this.
*/

WITH datas (EventLevel, EventParent, EventName, EventType)
AS (SELECT 0 AS [t_Level],
           enet.parent_type,
           CONVERT(VARCHAR(255), enet.type_name),
           enet.[type]
    FROM sys.event_notification_event_types AS enet
    WHERE enet.parent_type IS NULL
    UNION ALL
    SELECT d.EventLevel + 1,
           enet2.parent_type,
           CONVERT(VARCHAR(255), REPLICATE('|____ ', d.EventLevel + 1) + enet2.type_name),
           enet2.type
    FROM sys.event_notification_event_types AS enet2
        INNER JOIN [datas] AS d
            ON enet2.parent_type = d.EventType)
SELECT COALESCE(d_p.EventParent, 0) AS EventParent,
       d_p.EventName,
       d_p.EventType
FROM [datas] AS d_p;