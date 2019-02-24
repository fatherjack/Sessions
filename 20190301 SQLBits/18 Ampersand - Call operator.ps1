# create script block variable value
$scriptblock1 = "get-process"
$scriptblock2 = "1+1"
$scriptblock3 = "Get-Service -Name Spooler"

# try using the Call operator (&) to run the script block
& $scriptblock1
& $scriptblock2

# Call operator cannot execute commands with parameters

# use invoke expression ...
Invoke-Expression $scriptblock1


# but wait ...

# if we place the scriptblock into a ps1 file
Set-Content C:\temp\Scriptblock.ps1 -Value $scriptblock

# and then use the Call operator
& "C:\temp\Scriptblock.ps1"

# this works!


get-process -name powershell &


# NOTE:
# new in Powershell 6 (aka PowerShell Core) (pwsh)
# & is also used at the end of a command as a background operator
#################################################################

# launch pwsh - powershell core
invoke-item "C:\Program Files\PowerShell\6\pwsh.exe"

Get-Process &

Get-Job

Receive-Job

Remove-Job

