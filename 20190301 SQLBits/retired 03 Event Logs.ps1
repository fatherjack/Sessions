### Event Logs
##############

# Get-WinEvent
# What logs are there?
Get-WinEvent -ListLog * -ErrorAction SilentlyContinue

# Filtering available logs by name
Get-WinEvent -ListLog *firewall* -ErrorAction SilentlyContinue

# specify a log and we get log content
Get-WinEvent -LogName Application -MaxEvents 20

# to have the best chance of filtering we should use a hashtable
$Filter = @{
    LogName   = 'Application' 
    StartTime = '2019-Jan-29'
}
Get-WinEvent -FilterHashtable $filter

<#
What can we filter on?
Key name	    type	    wildcard
LogName	        <String[]>	 Yes
ProviderName	<String[]>	 Yes
Path	        <String[]>	 No
Keywords	    <Long[]>	 No
ID      	    <Int32[]>	 No
Level   	    <Int32[]>	 No
StartTime   	<DateTime>	 No
EndTime	        <DataTime>	 No
UserID	        <SID>	     No
Data    	    <String[]>	 No
#>
Get-WinEvent -LogName Application | Select-Object -First 10


# want to check backups - use the backup event IDs
$Filter = @{
    LogName      = 'Application' 
    ProviderName = 'MSSQL$SQL2016'
    ID           = (3014, 18265)

}
Get-WinEvent -FilterHashtable $filter | select -First 100

# the best way to build the hash table
C:\WINDOWS\system32\eventvwr.msc

$XMLFilter = ''

Get-WinEvent -FilterXml $XMLFilter

### SQL Log File - and Regex :)

Get-ChildItem "C:\Program Files\Microsoft SQL Server\MSSQL13.SQL2016\MSSQL\LOG\ERRORLOG*"  | Select-Object name, length | Sort-Object -Property name
$LogContent = get-content "C:\Program Files\Microsoft SQL Server\MSSQL13.SQL2016\MSSQL\LOG\ERRORLOG*"

# IP v4 port
([Regex]::match($LogContent, "<ipv4> (\d+)"))

([Regex]::match($LogContent, "<ipv4> (\d+)")).groups[1]

([Regex]::match($LogContent, "<ipv4> (\d+)")).groups[1].value

# physical RAM available 
[Regex]::Match($LogContent, "Detected (\d+) MB of RAM")

[Regex]::Match($LogContent, "Detected (\d+) MB of RAM").groups[1].value

# SQL Build no
([Regex]::match($logContent, "\d{1,2}.\d{1,2}.\d{3,4}.\d+"))
([Regex]::match($logContent, "(\d{1,2}.\d{1,2}.\d{3,4}.\d+)")).groups[1].value

