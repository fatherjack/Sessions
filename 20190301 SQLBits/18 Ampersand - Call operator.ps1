# create script block variable value
$scriptblock = "Get-Service -Name Spooler"
$scriptblock = "1+1"

# try using the Call operator (&) to run the script block
& $scriptblock

# Call operator cannot execute commands with parameters

# use invoke expression
Invoke-Expression $scriptblock


# but wait ...

# if we place the scriptblock into a ps1 file
Set-Content C:\temp\Scriptblock.ps1 -Value $scriptblock

# and then use the Call operator
& "C:\temp\Scriptblock.ps1"

# this works!

# NOTE:
# new in pwsh (PowerShell Core)
###############################

pwsh 
