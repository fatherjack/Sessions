### Event Logs
##############

# Get-WinEvent
$Filter = @{
    LogName   = 'Application' 
    StartTime = '2019-Apr-10'
}
Get-WinEvent -FilterHashtable $filter

$FilterTime = (Get-Date).AddHours(-1)
$Filter = @{
    LogName   = 'Application' 
    StartTime = $FilterTime
}
Get-WinEvent -FilterHashtable $filter

<#
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
Get-WinEvent -FilterHashtable $filter | Select-Object -First 100


# faster way to filter is to use an xml filter
$filterxml = @'
    <QueryList>
    <Query Id="0" Path="Application">
    <Select Path="Application">*[System[Provider[@Name='MSSQL$SQL2012'] ]]</Select>
    </Query>
    </QueryList>
'@
Get-WinEvent -FilterXml $Filterxml

#but that can be hard to write from memory ... how can we possibly get that right?

# Windows Event Viewer to the rescue
$filterxml = @'
   
'@
Get-WinEvent -FilterXml $Filterxml


### SQL Log File - and Regex :)

Get-ChildItem "C:\Program Files\Microsoft SQL Server\MSSQL13.SQL2016\MSSQL\LOG\ERRORLOG*" | Select-Object name, length | Sort-Object -Property name
$LogContent = Get-Content "C:\Program Files\Microsoft SQL Server\MSSQL13.SQL2016\MSSQL\LOG\ERRORLOG*"

# IP v4 port
([Regex]::match($logContent, "<ipv4> (\d+)"))

([Regex]::match($logContent, "<ipv4> (\d+)")).groups[1]

([Regex]::match($logContent, "<ipv4> (\d+)")).groups[1].value

# physical RAM available 
[Regex]::Match($logContent, "Detected (\d+) MB of RAM")


# Build no
([Regex]::match($logContent, "\d{1,2}.\d{1,2}.\d{3,4}.\d*"))
([Regex]::match($logContent, "(\d{1,2}.\d{1,2}.\d{3,4}.\d*)")).groups[1].value
([Regex]::match($logContent, "(\d{1,2}.\d{1,2}.\d{3,4}.\d*)")).groups[1].value


$LogContent | Select-Object -last 20
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | Out-Null 
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMOExtended') | Out-Null 


# Build no
([Regex]::match($logContent, "(\d{1,2}.\d{1,2}.\d{3,4}.\d*)")).groups[1].value

$LogContent | Select-Object -last 20

#$Servers = get-content "C:\Scripts\Powershell\Lookups\Servers.txt" 
$Server = "$ENV:COMPUTERNAME\sql2016"
$SMOServer = New-Object ('Microsoft.SQLServer.Management.Smo.Server') $Server


$t = $SMOServer.ReadErrorLog() | Where-Object { $_.Text -match 'failed|error|testdb' -and $_.ProcessInfo -like 'backup' } 

$t.GetType().fullname
$t | Get-Member

$t.logdate.GetType().fullname
