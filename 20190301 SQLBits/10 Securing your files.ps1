<#
from https://blogs.technet.microsoft.com/dataplatform/2018/06/26/keeping-your-important-files-safe-and-secure/

#>
# get the file hash of an installer 
Get-FileHash -Path D:\ISO\2016/en_sql_server_2016_service_pack_1_x64_dvd_9542248.iso | Format-List
# 
Get-ChildItem D:\HashTest | Get-FileHash
# 
$IsoHash = Get-ChildItem D:\HashTest | Get-FileHash -Algorithm MD5

$IsoHash[2].Hash # 33B324D311FDFC68A9A3E3405B8CD222

$IsoHash[2].Path # D:\ISO\en_sql_server_2016_service_pack_1_x64_dvd_9542248.iso

$IsoHash[2].Algorithm# MD5

# 
$FileToConfirm = "en_sql_server_2016"
$r = $IsoHash.path -match $FileToConfirm
if ($r) {
    "$r found" | Write-Output
}
else {
    "No details found for $FileToConfirm" | Write-Output
}
# D:\HashTest\en_sql_server_2016_service_pack_1_x64_dvd_9542248.iso found

# 
# export to a file
$IsoHash | Export-csv -Path "D:\HashTest\ISOArchive.csvh"


# # read hash from file and compare with newly calculated hash
$ISOArchive = @()
$ISOArchive = Import-csv -path "D:\hashtest\ISOArchive.csvh"

# choose the file we want to verify and get the hash of it right now
$FileToCheck = "D:\hashtest\en_sql_server_2016_service_pack_1_x64_dvd_9542248.iso"
$NewFileHash = Get-FileHash $FileToCheck -Algorithm MD5

# check if the new hash is found in the archive
$match = ($ISOArchive.hash) -match [regex]::Escape($NewFileHash.Hash)
if ($match) {
    "The hash for $($match.path) matches the archive value. It is safe to use." | Write-Output
}
else {
    # check if the file is found in the archive
    $exists = (($ISOArchive.path) -match [regex]::Escape($NewFileHash.Path)) -and (($ISOArchive.algorithm) -match [regex]::Escape($NewFileHash.Algorithm))
    if ($exists) {
        # if the file exists and the hash wasn’t found then the file has changed
        "The hash for $($match.path) does NOT match the archive value. It is NOT safe." | Write-Warning
    }
    else {
        # if the file isn’t found then we don’t have a hash that we can compare with
        if (!((($ISOArchive.path) -match [regex]::Escape($NewFileHash.Path)))) {
            "It doesn't look like there is a hash value for $($Newfilehash.path) in the archive." | Write-Output
        }
        else {
            # we have to compare hashes generated with the same algorithm
            "Please re-test $($newfilehash.path) using the correct hash algorithm" | Write-Output
        }
    }
}

