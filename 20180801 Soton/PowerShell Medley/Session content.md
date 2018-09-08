# Soton UG meeting Aug 2018

## sysinternals

- useful tools for server management and troubleshooting
- desktops
- process explorer
- zoomit
- hex2dec
- RAMMap
- TCPView

Ref - https://docs.microsoft.com/en-us/sysinternals/

Tools download - https://live.sysinternals.com/

Updater - https://gist.github.com/fatherjack/2636b2f32de6115c8a95a17c5f83aaad

## PowerShell

### Working with Windows Firewall

````powershell # general details
get-NetFirewallProfile | Format-Table -AutoSize

# checking what rules are created
Get-NetFirewallRule | select -first 5 | Format-Table -AutoSize

# we only want enabled rules ...
Get-NetFirewallRule | Where-Object Enabled -eq 'true' | select -first 5 | Format-Table -AutoSize

# if troubleshooting failed connections then we only really want inbound block rules
Get-NetFirewallRule | Where-Object {$_.Enabled -eq 'true' -and $_.Action -eq 'Block' -and $_.Direction -eq 'Inbound'} | select -first 5 | Format-Table -AutoSize

# if troubleshooting a specific app (SQL) connections - is there a specific rule that mentions the service by name
Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*sql*"} | select -first 5 | Format-Table -AutoSize

# lets see what ports the Mirroring rule is allowing
$Rule = Get-NetFirewallRule | Where-Object { $_.DisplayName -eq 'SQL Server Mirroring'}
$Rule | select * # hmmm, no port details

# the ports are found with a different function...
$Rule | Get-NetFirewallPortFilter | select @{n = "RuleName"; e = {$rule.ElementName}}, @{n = "Rule Enabled"; e = {$rule.Enabled}}, @{n = "Profile"; e = {$rule.Profile}}, @{n = "Rule Action"; e = {$rule.Action}}, LocalPort | Format-Table -AutoSize

# what about looking for ports that are part of a rule?
Get-NetFirewallPortFilter | Where-Object LocalPort -Match 5023

$RulesWithPort = Get-NetFirewallPortFilter | Where-Object LocalPort -Match 5023
Get-NetFirewallRule | ? CreationClassName -EQ $RulesWithPort.CreationClassName | select DisplayName, Description, Action, Enabled | Format-Table -AutoSize
````


### customise your prompt

"https://gist.github.com/fatherjack/9c005403b2ffcd95ce5c30d1dc5213d6"



### Database connection string creator
````powershell set-location "C:\Users\jonallen\OneDrive\Scripts\PowerShell\ProfileFunctions"

& ."\get-connectionstring.ps1"
````

https://gist.github.com/fatherjack/3dd2fad5d4928c976e88d1f372965c44

```` powershell
#splatting

backup-sqldatabase 

restore-database
````

## Markdown

Cheatsheet - (https://duckduckgo.com/?q=markdown+cheat+sheet&atb=v5&ia=answer&iax=1)

## VSCode

### Snippets