# customising your PowerShell prompt

# specific to each session

# when created, a custom prompt function - lives in your Function provider
Get-Item function:\prompt

Get-Command prompt

Get-Help prompt -ShowWindow

(get-item Function:\prompt).ScriptBlock

# lets wipe the current one and add something new
function prompt {}

# lets have a > for each level we are in the current directory
function prompt {
    $level = ($PWD.Path.Split('\')).count
    
    if ($level -gt 2) {
        "SQLBITS " + (">" * $level)
    }
    else {
        "SQLBITS >"
    }
}

Set-location c:\
Set-Location $Home\downloads

# to persist a custom function you need to define it in your profile
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



<# restore my custom profile#> # . "C:\Users\Jonathan\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1"
