
# Ref - https://docs.microsoft.com/en-us/sysinternals/

# Tools download - https://live.sysinternals.com/

#requires -runasadministrator

get-childitem C:\Tools\sysinternals

(get-childitem C:\Tools\sysinternals -Filter *.exe).count

# Process Explorer
Start-Process "C:\Tools\sysinternals\procexp64.exe"

# PSList - Process Information Lister 
Start-Process "C:\Tools\sysinternals\pslist.exe" 

$list = Start-Process "C:\Tools\sysinternals\pslist.exe" 

$list

$list = Start-Process "C:\Tools\sysinternals\pslist.exe" -PassThru

$list

$list = & "C:\Tools\sysinternals\pslist.exe"

$list

# how to keep them up to date
Get-ChildItem "C:\Tools\sysinternals\autoruns.exe"

$IE = "C:\Program Files\internet explorer\iexplore.exe"
$arg = '\\live.sysinternals.com\tools'
start-process  $IE $arg

$Sysinternals = '\\live.sysinternals.com\tools'

# Create PSDrive to do tools comparison and copy from
if (!(Get-PSDrive | Where-Object {$_.root -eq $sysinternals})) {
    New-PSDrive -Name SysInternals -PSProvider FileSystem -Root $sysinternals
}

# Update function available at - https://gist.github.com/fatherjack/

Update-SysInternals


<# SQL Server 2017 #> mmc C:\Windows\SysWOW64\SQLServerManager15.msc
<# SQL Server 2016 #> mmc C:\Windows\SysWOW64\SQLServerManager13.msc
<# SQL Server 2014 #> mmc C:\Windows\SysWOW64\SQLServerManager12.msc
<# SQL Server 2012 #> mmc C:\Windows\SysWOW64\SQLServerManager11.msc
