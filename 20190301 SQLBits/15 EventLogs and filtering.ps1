# Getting information from a huge event log efficiently

# What sort object does Get-WinEvent return, what Methods and Properties are there?
Get-WinEvent -LogName application | Select-Object -first 1 | Get-Member

# whats the Get-WinEvent syntax
get-command get-winevent -Syntax

# list all the parameters
get-command get-winevent | Select-Object -ExpandProperty parameters

# Check out the details of parameter ProviderName
get-help get-winevent -parameter ProviderName
# Check out the details of parameter ProviderName
get-help get-winevent -Examples

# so we can specify a ProviderName - it even takes wildcards
Get-WinEvent -ProviderName "*SQL2016"

# we can get all possible ProviderName values
(Get-WinEvent -ListLog Application).ProviderNames | Where-Object {$_ -like "*mssql*"}

# or use the -ListProvider parameter
$providers = Get-WinEvent -ListProvider * -ErrorAction SilentlyContinue | select name
$providers

# or another alternative route to see all possible providers in an event log
$EventSession = [System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession
$EventSession.GetProviderNames() 
$SQLEventProviderNames = $EventSession.GetProviderNames() | Where-Object {$_ -like "mssql*"} # will filter list to SQL Server (database engine) providers
$SQLEventProviderNames 

# but this doesnt work
Get-WinEvent -LogName Application -ProviderName 'MSSQL$SQL2016', 'MSSQL$SQL2012', 'MSSQL$SQL2014', 'MSSQL$SQL2016', 'MSSQL$VNXT01'
# we cant combine -LogName and -ProviderName
Get-WinEvent -LogName Application
Get-WinEvent -ProviderName 'MSSQL$SQL2016', 'MSSQL$SQL2012', 'MSSQL$SQL2014', 'MSSQL$SQL2016', 'MSSQL$VNXT01'

# unless we use an XMLFilter
# filter application log for Error, Warning and Critical events from specified Provider names
$Filter_Application = @'
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[Provider[@Name='MSSQL$SQL2012' 
                                                  or @Name='MSSQL$SQL2014' 
                                                  or @Name='MSSQL$SQL2016' 
                                                  or @Name='MSSQL$VNXT01'] 
                                                and (Level=1  or Level=2 or Level=3) 
                                                and TimeCreated[timediff(@SystemTime) &lt;= 86400000]]]</Select>
  </Query>
</QueryList>
'@

Get-WinEvent -FilterXML $Filter_Application

# filter System event log for event IDs 1205 or 1562 or 1069
$Filter_System = @'
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">*[System[(EventID=1205 or EventID=1562 or EventID=1069)]]</Select>
  </Query>
</QueryList>
'@
Get-WinEvent -FilterXML $Filter_System

# filter Application log for event ID 833
$Filter_Application = @'
<QueryList>
  <Query Id="0" Path="application">
    <Select Path="System">*[System[(EventID=833)]]</Select>
  </Query>
</QueryList>
'@
Get-WinEvent -FilterXML $Filter_Application

# filter the System log for 1205 or 1562 or any ID in range 1060 to 1069
$Filter_Range = @'
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(EventID=1205 or EventID=1562 or  (EventID &gt;= 1060 and EventID &lt;= 1069) )]]</Select>
  </Query>
</QueryList>
'@

# filter for no results
$Filter_Empty = @'
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(EventID=1205)]]</Select>
  </Query>
</QueryList>
'@

# how do we get a 'clean' output from Get-WinEvent then ?
try {
    $r = Get-WinEvent -FilterXML $Filter_Application -ErrorAction SilentlyContinue
}
catch {
    Write-Warning $Error[0].Exception.Message
}
finally {
    if ($r.Count -eq 0) {
        Write-Information "No events found that match your filter" -InformationAction Continue
    }
}

# easiest way to build the XML Filter that you need
C:\WINDOWS\system32\eventvwr.msc

<#
Log         ID      Message
***         **      *******
Application 833     IO taking longer that 15s
System      1205    Cluster failed to bring service online
System      1562    File share witness failed health check
System      1069    Service can only come online when necessary resources are online

#>

