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
$SMOServer.Refresh()
if ($SMOServer.Databases['PSRESTORE']) {
    try {
        "PSRESTORE exists" | Write-Host -ForegroundColor Red
        $SMOServer.Databases["PSRESTORE"].Drop()
        "PSRESTORE dropped" | Write-Host -ForegroundColor Green
    }
    catch {
        $e = $error[0]
        Write-Warning "Unable to drop PSRESTORE database"
        $e.exception.GetBaseException()
    }
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
catch {
    $e = $error[0]
    $e.Exception.GetBaseException()
}

$ErrorActionPreference = $ErrAction
