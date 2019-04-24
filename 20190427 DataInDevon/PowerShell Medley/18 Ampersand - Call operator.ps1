# create script block variable value
$scriptblock = "Get-Service -Name Spooler"
$scriptblock = "1+1"

# use Call operator '&' to run the script block
&$scriptblock

# Call operator cannot execute commands with parameters

# use invoke expression
Invoke-Expression $scriptblock


# but wait ..
set-content C:\temp\Scriptblock.ps1 -Value $scriptblock

&"C:\temp\Scriptblock.ps1"

# this works!

# NOTE:
# new in pwsh (PowerShell Core)
###############################

pwsh 
