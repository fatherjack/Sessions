
# Ref - https://docs.microsoft.com/en-us/sysinternals/

# Tools download - https://live.sysinternals.com/

get-childitem C:\Tools\sysinternals

(get-childitem C:\Tools\sysinternals -Filter *.exe).count

# Process Explorer
Start-Process "C:\Tools\sysinternals\procexp.exe"

# PSList / PSKill
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

# Updater - https://gist.github.com/fatherjack/2636b2f32de6115c8a95a17c5f83aaad

Update-SysInternals
