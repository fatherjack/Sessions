### Working with Windows Firewall

# general firewall details
get-NetFirewallProfile | Out-GridView

# checking what rules are created
Get-NetFirewallRule | Out-GridView
(Get-NetFirewallRule).count

# we only want enabled rules ...
Get-NetFirewallRule | Where-Object Enabled -eq 'true' | Select-Object -first 5 | Format-Table -AutoSize
(Get-NetFirewallRule | Where-Object Enabled -eq 'true').count

# if troubleshooting failed connections then we only really want inbound block rules
Get-NetFirewallRule | Where-Object {$_.Enabled -eq 'true' -and $_.Action -eq 'Block' -and $_.Direction -eq 'Inbound'} | Select-Object -first 5 | Format-Table -AutoSize
(Get-NetFirewallRule | Where-Object {$_.Enabled -eq 'true' -and $_.Action -eq 'Block' -and $_.Direction -eq 'Inbound'}).count 

# if troubleshooting a specific app (SQL) connections - is there a specific rule that mentions the service by name
Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*sql*"} | Select-Object -first 5 | Format-Table -AutoSize

# lets see what ports the Mirroring rule is allowing
$Rule = Get-NetFirewallRule | Where-Object { $_.DisplayName -eq 'SQL Server Mirroring'}
$Rule | Select-Object * # hmmm, no port details

# the ports are found with a different function...
$Rule | Get-NetFirewallPortFilter | Select-Object @{n = "RuleName"; e = {$rule.ElementName}}, @{n = "Rule Enabled"; e = {$rule.Enabled}}, @{n = "Profile"; e = {$rule.Profile}}, @{n = "Rule Action"; e = {$rule.Action}}, LocalPort | Format-Table -AutoSize

# what about looking for ports that are part of a rule?
# we can get the portfilter based on the port
Get-NetFirewallPortFilter | Where-Object LocalPort -Match 56178

# and then use the CreationClassName to identify FW rules that are active on our chosen port
$RulesWithPort = Get-NetFirewallPortFilter | Where-Object LocalPort -Match 56178
Get-NetFirewallRule | Where-Object CreationClassName -EQ $RulesWithPort.CreationClassName | Select-Object DisplayName, Description, Action, Enabled | Format-Table -AutoSize

# want to add a new rule
$FWParams = @{
    DisplayName     = "Allow SQL Server"
    Direction       = "Outbound" 
    Program         = "C:\Users\Jonathan\Downloads\SQL\SQL2017CTP2\x64\Setup\sql_engine_core_inst_msi\PFiles\SqlServr\MSSQL.X\MSSQL\Binn\sqlservr.exe" 
    RemoteAddress   = "LocalSubnet"
    Action          = "Allow"
}
New-NetFirewallRule @FWParams

# check the rule is there
Get-NetFirewallRule | Where-Object { $_.DisplayName -like "*sql*"} | Format-Table -AutoSize

# remove firewall rule
Remove-NetFirewallRule -DisplayName "Allow SQL Server"