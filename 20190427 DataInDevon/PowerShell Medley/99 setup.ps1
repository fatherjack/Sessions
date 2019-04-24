[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | Out-Null 
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMOExtended') | Out-Null 

$Server = "$ENV:COMPUTERNAME\sql2016"
$SMOServer = new-object ('Microsoft.SQLServer.Management.Smo.Server') $Server

# Create TestDB and Drop PSRESTORE
if ($SMOServer.Databases['TestDB']) {
    "TestDB exists" | Write-Host -ForegroundColor Green
}
else {
    "No TestDB"
    $SMOTestDB = new-object 'Microsoft.SQLServer.Management.Smo.Database' ( $SMOServer, "TestDB")
    $SMOTestDB.create()
    "TestDB created"
}

if ($SMOServer.Databases['PSRESTORE']) {
    "PSRESTORE exists" | Write-Host -ForegroundColor Red
    $SMOPSRESTORE = new-object 'Microsoft.SQLServer.Management.Smo.Database' ( $SMOServer, "PSRESTORE")
    $SMOServer.KillAllProcesses("PSRESTORE")
    $SMOPSRESTORE.Drop()
    "PSRESTORE dropped" | Write-Host -ForegroundColor Green
}
else {
    "No PSRESTORE db" | Write-Host -ForegroundColor Green
}

# remove firewall
$ErrAction = $ErrorActionPreference
$ErrorActionPreference = 'silentlycontinue'

try {
    if (Get-NetFirewallRule -DisplayName "Allow SQL Server") {
        Remove-NetFirewallRule -DisplayName "Allow SQL Server"
        "Firewall rule removed" | Write-Host -ForegroundColor Green
    }
    else {
        "Firewall rule doesnt exist" | Write-Host -ForegroundColor Green
    }
}
catch {}

$ErrorActionPreference = $ErrAction
