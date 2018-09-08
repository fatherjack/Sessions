#$Servers = get-content "C:\Scripts\Powershell\Lookups\Servers.txt" 
$Server = "$ENV:COMPUTERNAME\sql2016"
$SMOServer = new-object ('Microsoft.SQLServer.Management.Smo.Server') $Server

$DatabaseName = "PSRESTORE"
$dataFolder = "C:\test"
$logFolder = "C:\test"

$backupDeviceItem = new-object Microsoft.SqlServer.Management.Smo.BackupDeviceItem "C:\Backups\2016\TestDB.bak", 'File';

$restore = new-object 'Microsoft.SqlServer.Management.Smo.Restore';
$restore.Database = $DatabaseName;
$restore.Devices.Add($backupDeviceItem);

# Build the relocate files
foreach ($file in $restore.ReadFileList($smoserver)) {
    $relocateFile = new-object 'Microsoft.SqlServer.Management.Smo.RelocateFile';
    $relocateFile.LogicalFileName = $file.LogicalName;

    if ($file.Type -eq 'D') {
        if ($dataFileNumber -ge 1) {
            $suffix = "_$dataFileNumber";
        }
        else {
            $suffix = $null;
        }

        $relocateFile.PhysicalFileName = "$dataFolder\$DatabaseName$suffix`_data.mdf";

        $dataFileNumber ++;
    }
    else {
        $relocateFile.PhysicalFileName = "$logFolder\$DatabaseName`_log.ldf";
    }
    $restore.RelocateFiles.Add($relocateFile) | out-null;
}

# RESTORE the database
$restore.SqlRestore($smoserver)

# test the restore
$SMODB = $SMOServer.Databases['PSRESTORE']
$SMODB | select name, status, createdate