

Get-Process -Name powershell &

Start-Job -ScriptBlock {Get-Process -Name pwsh}

Receive-Job 1

Get-Process -Name powershell &