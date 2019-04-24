$TempArray = @()
$TempArray = $env:PSModulePath -split ';'
$TempArray | Sort-Object 
# 110 for SQL 2012, 120 for SQL 2014, 130 for SQL 2016
$env:PSModulePath = ($TempArray -notmatch '130') -join ';'  

$env:PSModulePath

$TempArray = $env:PSModulePath -split ';'
$TempArray | Sort-Object 

([appdomain]::CurrentDomain.GetAssemblies() | where {$_.FullName -like "*smo*"}).Location

Get-Module -ListAvailable -Name sqlps
get-command -Module SQLPS | select Name



# search for specific object type and what assemblies are providing it
 [AppDomain]::CurrentDomain.GetAssemblies().GetTypes() | ? FullName -eq Microsoft.SqlServer.Management.Smo.RelocateFile | select Assembly

 [System.AppDomain]::CurrentDomain.ReflectionOnlyGetAssemblies

 