## SQL Backups with PowerShell ...


# easy to do
# but tricky to read ...

# clear out backup target for demo
$BackupFile = "C:\Backups\2016\TestDB.bak"
if ($BackupFile) {Remove-Item $BackupFile}

# some commands are just bad news for readability
Backup-SqlDatabase -BackupSetName "A database Full Backup" -MediaDescription "The daily full backup for our favourite database." -ServerInstance "$env:COMPUTERNAME\sql2016" -Database "TestDB" -BackupFile "C:\Backups\2016\TestDB.bak" -BackupAction "Database" -CompressionOption On -Initialize -FormatMedia



# how do we cope with this?

# use 'splatting'
$Params = @{
    BackupSetName     = "Adventureworks Full Backup" 
    MediaDescription  = "The daily full backup for our favourite database." 
    ServerInstance    = "$env:COMPUTERNAME\sql2016" 
    Database          = "TestDB"
    BackupFile        = $BackupFile
    BackupAction      = "Database" 
    Initialize        = $true
    CompressionOption = "on"
}
Backup-SqlDatabase @Params -PassThru


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

# Remove-Item variable:r

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
#       Either set your location to the proper context, or 
#           use the -Path parameter to specify the location.



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

$BackupMedia | Select-Object LogicalName, PhysicalName

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


# Not only but also

# say we want to get some file info
get-childitem "C:\WINDOWS\system32" | Select-Object Name, FullName, CreationTime, LastAccessTimeUtc, Length, PSIsContainer

# messy, cant Format-Table help us ?
get-childitem "C:\WINDOWS\system32" | Select-Object Name, FullName, CreationTime, LastAccessTimeUtc, Length, PSIsContainer | Format-Table -Wrap

# lets try applying some formatting
get-childitem "C:\WINDOWS\system32" | Select-Object Name, FullName, @{name = "Create Time"; expression = {"{0:yyyyMMdd}" -f $_.CreationTime}} , LastAccessTimeUtc, @{Name = "SizeMB"; expression = {"{0:N3}" -f ($_.Length / 1mb)}}, @{name = "Type"; expression = {if ($_.PSIsContainer) {"Directory"}else {"File"}}} | Format-Table -Wrap

# great.
# but.
# sheer awful to read / maintain - we are back to an huge long command


# take each calculation and put it in a hash table
$fmt = @{}
$fmt.CreationFormat = @{name = "Create Time"; expression = {"{0:yyyyMMdd}" -f $_.CreationTime}}
$fmt.Container = @{name = "Type"; expression = {if ($_.PSIsContainer) {"Directory"}else {"File"}}}
$fmt.Length = @{Name = "SizeMB"; expression = {"{0:N3}" -f ($_.Length / 1mb)}} # @{Name = "SizeMB"; expression = {"{0:N3}" -f (If ($_.Length) {$_.Length / 1mb}else {0})}}

# what does $fmt look like ...
$fmt # the hash table contains 3 hash tables
$fmt.CreationFormat # each hashtable contains a name and expression key. The name is the column name, the expression is the format / logic to apply to the object data

get-childitem "C:\WINDOWS\system32" | Select-Object Name, FullName, $fmt.Length, $fmt.CreationFormat, LastAccessTimeUtc, $fmt.Container -First 5 
get-childitem "C:\WINDOWS\system32" | Select-Object Name, FullName, $fmt.Length, $fmt.CreationFormat, LastAccessTimeUtc, $fmt.Container | Format-Table -Wrap

# WARNING : be careful what logic you add in the formatting - this code runs for every item received from the pipeline so needs to be as efficient as possible
