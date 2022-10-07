Clear-Host

# connect to the server / instance / database you want
$Server = '.\sql2017'
$SMOServer = New-Object microsoft.sqlserver.management.smo.server $Server
$SMODB = $SMOServer.Databases['TestDB']

# Server object has an Audits and Auditspecifications collections
$SMOServer.Audits | Out-GridView
$SMOServer.ServerAuditSpecifications | Out-GridView

# Database object has the Auditspecification collection
$SMODB.DatabaseAuditSpecifications | Out-GridView

# Finding which databases have audits configured
Clear-Host
foreach ($DB in $SMOServer.Databases ) {
    if ($DB.DatabaseAuditSpecifications.Count -gt 0) {
        "$($DB.name) has a Database Audit Specification" | Write-Output
    }
}

# Gathering information about the Server audits
foreach ($SMOAudit in $SMOServer.Audits) {
    [pscustomobject] @{
        name            = $SMOAudit.name
        enabled         = $SMOAudit.enabled
        onfailure       = $SMOAudit.onfailure
        DestinationType = $SMOAudit.DestinationType
    }
}


# or of course you could use dbatools !
Get-DbaInstanceAudit foundry\sql2017 | Out-GridView
Get-DbaInstanceAuditSpecification foundry\sql2017 | Out-GridView

# what other commands are there...
Get-Command -Module dbatools *audit*

Get-DbaInstanceAudit
# Gets SQL Security Audit information for each instance(s) of SQL Server.
Get-DbaInstanceAuditSpecification
# Gets SQL Security Audit Specification information for each instance(s) of SQL Server.

Copy-DbaInstanceAudit
# Copy-DbaInstanceAudit migrates server audits from one SQL Server to another.
Copy-DbaInstanceAuditSpecification
# Copy-DbaInstanceAuditSpecification migrates server audit specifications from one SQL Server to another.
Read-DbaAuditFile

# Read Audit details from inactive sqlaudit files.
Read-DbaAuditFile "C:\temp\SQLAudits\AUDIT-DATABASE_ROLE_MEMBER_CHANGE_33FC6C86-9893-41E0-8FFB-F6B262CE1559_0_133092978595040000.sqlaudit"
Read-DbaAuditFile "C:\TEMP\SQLAudits\AUDIT-SQLAUDITACCESS_76F9FC83-48BD-41FB-9C43-1D6F72E3F78D.sqlaudit"

Read-DbaAuditFile "C:\temp\SQLAudits\AUDIT-DATABASE_ROLE_MEMBER_CHANGE_33FC6C86-9893-41E0-8FFB-F6B262CE1559_0_133092978595040000.sqlaudit"
Read-DbaAuditFile "C:\temp\SQLAudits\AUDIT-DATABASE_ROLE_MEMBER_CHANGE_33FC6C86-9893-41E0-8FFB-F6B262CE1559_0_133092966855280000.sqlaudit"
Read-DbaAuditFile "C:\temp\SQLAudits\AUDIT-DATABASE_ROLE_MEMBER_CHANGE_33FC6C86-9893-41E0-8FFB-F6B262CE1559_0_133092986028990000.sqlaudit"

# how can this be a bit more slick?
# get all sqlaudit files
$AuditFiles = Get-ChildItem -Path "C:\temp\SQLAudits" -File *.sqlaudit
# pass them through Read-DbaAuditFile and pick out the info we want
$AuditOutput = foreach ($File in $AuditFiles) {
    try {
        Read-DbaAuditFile $File.FullName | ForEach-Object {
            [PSCustomObject]@{
                name                           = $_.name
                timestamp                      = $_.timestamp
                event_time                     = $_.event_time
                object_name                    = $_.object_name
                statement                      = $_.statement
                succeeded                      = $_.succeeded
                server_instance_name           = $_.server_instance_name
                database_name                  = $_.database_name
                application_name               = $_.application_name
                server_principal_id            = $_.server_principal_id
                server_principal_name          = $_.server_principal_name
                database_principal_id          = $_.database_principal_id
                database_principal_name        = $_.database_principal_name
                target_server_principal_id     = $_.target_server_principal_id
                target_server_principal_name   = $_.target_server_principal_name
                target_database_principal_id   = $_.target_database_principal_id
                target_database_principal_name = $_.target_database_principal_name
                client_ip                      = $_.client_ip
                session_server_principal_name  = $_.session_server_principal_name
                server_principal_sid           = [string]$_.server_principal_sid
                target_server_principal_sid    = [string]$_.target_server_principal_sid
                schema_name                    = $_.schema_name
                additional_information         = $_.additional_information
            }
        }
    }
    catch {
        $e = $Error[0]
        $e.Exception.InnerException
    }
}
# smoosh the collected information into an Excel document
$Outfile = (Join-Path "C:\temp\SQLAudits" "$Server`_AuditData.xlsx")
$splatExcel = @{
    path       = "$Outfile"
    tablestyle = "medium15"
    autosize   = $true
    ClearSheet = $true
}

$AuditOutput -ne $null | Export-Excel @splatExcel -WorksheetName "AuditData" -TableName "AuditData"
# Yes the above is a code smell for a bad equality comparison but we want to use the filtering functionality to remove $null elements

# open the excel file
Invoke-Item $outfile
