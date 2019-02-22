# new medley item

# formatting - with a Pizza
# help from https://ss64.com/ps/syntax-f-operator.html

$PI = 22 / 7

$PI

# Pi
"{0:F2}" -f $PI

# Pizza circumference = Pi * Diameter
"{0:F2}" -f $PI * 10


"{0:F2}" -f ($PI * 10)



###### REGEX FOR ERRORLOGs ######
$Server = "$ENV:COMPUTERNAME\sql2016"
$SMOServer = new-object ('Microsoft.SQLServer.Management.Smo.Server') $Server

foreach ($log in $SMOServer.EnumErrorLogs() | Where-Object {$_.createdate -gt ((get-date).AddDays(-2))}) {
    $content | Where-Object text -match ("Error: \d{3,6}, Severity: \d{2,3}, State*") | Select-Object @{name = "Server"; expression = {$Server}}, logdate, text
}


###### ISNULL ######
$a = "A"
($a -eq $null)

$a = "A"
($a, "Static" -eq $null) # -eq $null doesnt show anything to screen - lets change to -ne

$a = "A"
($a, "Static" -ne $null)


($a, "Static", $null -ne $null)

# but what if $a isnt null ?
$a = "Something"
($a, "Static", $null -ne $null)


# so we simply pick the first element of the output
'# test $a IS NOT null'
$a = "Something"
($a, "Alternate" -ne $null)[0]

'# test $a IS null'
$a = $null
($a, "Alternate" -ne $null)[0]


