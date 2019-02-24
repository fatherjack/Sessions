# an alterantive to consider when doing a lot of string manipulation


# often we see looping structures that compile a list
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | Out-Null 
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMOExtended') | Out-Null 

$Server = "$ENV:COMPUTERNAME\sql2016"
$SMOServer = new-object ('Microsoft.SQLServer.Management.Smo.Server') $Server

$TableScript = ""
foreach ($DB in $SMOServer.databases) {
    foreach ($Table in $db.tables) {
        $TableScript += "$($Table.name)`t$($Table.Script())`r`n"
    }
}
$TableScript
    
[System.Text.StringBuilder]$SBTableScript = ""
foreach ($DB in $SMOServer.databases) {
    foreach ($Table in $db.tables) {
        $SBTableScript.AppendLine("$($Table.name)`t$($Table.Script())") | Out-Null
    }
}
$SBTableScript.ToString()

# making changes to substring patterns is very similar
# change varchar to nvarchar with Replace()
$n = $TableScript.Replace('[varchar]', '[nvarchar]')
$n = $SBTableScript.Replace('[varchar]', '[nvarchar]')

# CREATE to CREATE OR ALTER with Replace()
$n = $TableScript.Replace('[CREATE]', '[CREATE OR ALTER]') 
$n = $SBTableScript.Replace('[CREATE]', '[CREATE OR ALTER]')

# Inserting values into a string
[System.Text.StringBuilder]$SBString = "[]"

$SBString.Insert(1, "hello") | Out-Null
$SBString.ToString()

$SBString.Insert(1, "hello", 2)
$SBString.ToString()

$SBString.Insert(16, "`r`nWhat's going on here then?")
$SBString.ToString()

# inserting needs a little care
(6, 12, 18) | ForEach-Object {
    $SBString.Insert($PSItem, " ")
}
$SBString.ToString()


# converting between [string] and [System.Text.StringBuilder]
# String to StringBuilder
$String = "To infinity, and beyond."
[System.Text.StringBuilder]($NewSB) = $String
$NewSB.GetType()

#StringBuilder to String
$NewString = $NewSB.ToString()
$NewString.GetType()


# evaluate both and compare planned uses and impact on performance and resources
#  - depends on manipulation processes taking place
# USE           Reason/Scenario
# String        if you are searching. StringBuilder has no IndexOf(), Contains() or StartsWith() methods
# StringBuilder when you are making lots of changes to the string




