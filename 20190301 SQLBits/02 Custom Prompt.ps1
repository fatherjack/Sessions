# customising your PowerShell prompt
function prompt {$null}

Get-Help about_Profiles  -showwindow

<# Current User, Current Host#> code $Home\Documents\WindowsPowerShell\Profile.ps1
<# Current User, All Hosts   #> code $Home\Documents\Profile.ps1
<# All Users, Current Host   #> code $PsHome\Microsoft.PowerShell_profile.ps1
<# All Users, All Hosts      #> code $PsHome\Profile.ps1

$Home       # C:\Users\Jonathan
$PsHome     # C:\Users\Jonathan\OneDrive\Scripts\PowerShell\ProfileFunctions

code "C:\Users\Jonathan\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"
code "C:\Users\Jonathan\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

code $profile
code "C:\Users\Jonathan\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1"


(get-item Function:\prompt).ScriptBlock
