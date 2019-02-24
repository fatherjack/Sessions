

Get-Process -Name powershell &

$job = Start-Job -ScriptBlock {Get-Process -Name pwsh}

Receive-Job 3

Get-Process -Name powershell &

get-job Stop-Job 3