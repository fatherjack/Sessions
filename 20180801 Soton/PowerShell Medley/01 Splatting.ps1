## SQL Backups with PowerShell ...


# easy to do
# but tricky to read ...

# some commands are just bad news for readability
Backup-SqlDatabase -BackupSetName "A database Full Backup" -MediaDescription "The daily full backup for our favourite database." -ServerInstance "$env:COMPUTERNAME\sql2016" -Database "TestDB" -BackupFile "C:\Backups\2016\TestDB.bak" -BackupAction "Database" -Initialize

# how do we cope with this?

# use 'splatting'
$Params = @{
    BackupSetName       = "Adventureworks Full Backup" 
    MediaDescription    = "The daily full backup for our favourite database." 
    ServerInstance      = "$env:COMPUTERNAME\sql2016" 
    Database            = "TestDB"
    BackupFile          = "C:\Backups\2016\TestDB.bak"
    BackupAction        = "Database" 
    Initialize          = $true
}
Backup-SqlDatabase @Params 


# and to see results/output - use -Passthru
# want to use multiple files? 

$Params = @{}
$Params = @{
    BackupSetName    = "Adventureworks Full Backup" 
    MediaDescription = "The daily full backup for our favourite database." 
    ServerInstance   = "$env:COMPUTERNAME\sql2016" 
    Database         = "TestDB"
    BackupFile       = "C:\Backups\2016\TestDB1.bak" , "C:\Backups\2016\TestDB2.bak" 
    BackupAction     = "Database" 
    Initialize       = $true
}
$r = Backup-SqlDatabase @Params -PassThru 
ri variable:r
$r | Get-Member

$r | Select-Object database, mediadescription, databasefiles

# Want a Differential backup? use Incremental parameter
$Params = @{
    BackupSetName    = "Adventureworks Full Backup" 
    MediaDescription = "The daily full backup for our favourite database." 
    ServerInstance   = "$env:COMPUTERNAME\sql2016" 
    Database         = "TestDB"
    BackupFile       = "C:\Backups\2016\TestDB1.bak" , "C:\Backups\2016\TestDB2.bak" 
    BackupAction     = "Database" # or Log
    Initialize       = $true
    Incremental      = $true
}
$r = Backup-SqlDatabase @Params -PassThru 

## forget the @ sign and use $ instead and you get :
#       Either set your location to the proper context, or use the -Path parameter to specify the location.



# Restores - while we are here ...

# really not intuitive
$headeronly = 
@"
RESTORE HEADERONLY FROM DISK = N'C:\backups\2016\testdb.bak'
"@

$BackupHeader = @{}
$BackupHeader = Invoke-Sqlcmd -ServerInstance "$env:COMPUTERNAME\sql2016" -Database master -Query $headeronly

$BackupHeader | Out-GridView


$filelistonly = 
@"
RESTORE FILELISTONLY FROM DISK = N'C:\backups\2016\testdb.bak'
"@

$BackupMedia = @{}
$BackupMedia = Invoke-Sqlcmd -ServerInstance "$env:COMPUTERNAME\sql2016" -Database master -Query $filelistonly

$BackupMedia | Out-GridView -PassThru

$BackupMedia | select LogicalName, PhysicalName

# restore over the existing database
Restore-SqlDatabase -ServerInstance "$env:COMPUTERNAME\sql2016" -Database TestDB -BackupFile 'C:\Backups\2016\testdb.bak' -ReplaceDatabase -RestoreAction Database

# restore a side-by-side database
# yeah, not so simple
$NewDBName = "PSRESTORE"
Restore-SqlDatabase -ServerInstance "$env:COMPUTERNAME\sql2016" -Database $NewDBName -BackupFile 'C:\Backups\2016\testdb.bak' -ReplaceDatabase -RestoreAction Database

# we need RelocateFiles - SMO objects that hold the logical name from the backup and the new physical name for the new database
$RelocateFiles = @()
foreach ($file in $BackupMedia) {

    $objfile = New-Object "Microsoft.SqlServer.Management.Smo.RelocateFile, Microsoft.SqlServer.SMOExtended, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" ($($file.LogicalName), $($file.PhysicalName).replace("testdb", "PSRESTORE"))
    $RelocateFiles += $objfile
}

$RelocateFiles

$RelocateFiles.GetType().FullName

$RelocateFiles[1].GetType().FullName

$RestoreParams = @{
    ServerInstance  = "$env:COMPUTERNAME\sql2016"
    Database        = $NewDBName 
    BackupFile      = 'C:\Backups\2016\testdb.bak'
    ReplaceDatabase = $true 
    RelocateFile    = @($RelocateFiles) 
    Script          = $true
}
Restore-SqlDatabase @RestoreParams


