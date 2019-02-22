# PowerShell doesnt have ISNULL like TSQL ... 

$a = "Something"
$b = $null

# if we create an array we dont see the $null. Who'd have thought eh ?!
($a, $b, "String") | Write-Output

# if we compare a value to $null we get True or False
$a -eq $null
$b -eq $null
"String" -eq $null

# unless we compare an array
$Array = $a, $b, "string"

$Array -eq $null

$Array -ne $null

# so, we can filter out nulls with -ne but again, we cant see that ...
$a, $b, "String" -ne $null


# let's invert the filter for a minute
$a, $b, "String", $null -eq $null
# yep, that sure shows that we filtered out everything except nulls .... 


# lets count the elements in the array to see the effect of the filter
($a, $b, "String", $null).count
($a, $b, "String", $null -eq $null).count



# OK, if we have an array of assorted values and nulls, the -ne $null removes the nulls
($a, $b, "String" -ne $null)

# to get the first not null value we can simply reference the first item
($a, $b, "String" -ne $null)[0]

# if we are referencing the first not null value and we provide the second value then we have something like ISNULL
$a = $null
($a, "Alternate" -ne $null)[0]




# there we have it, a simple way to work like the TSQL ISNULL function
function IsNull {
    param (
        # The test value
        
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The value that is evaluated by IsNull.")]
        $Test,
        # The alternate value
        [Parameter(Mandatory = $true,
            Position = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "The value that is substituted if `$Test is null.")]
            [string]$Alternate
    )
    cls;
    ($Test, $Alternate -ne $null)[0]
};

$Svr = "ComputerNo9"
$Server = IsNull $Svr "[Alternate value]"
Write-Host -BackgroundColor White -ForegroundColor Black "`rThe variable `$Server has the value '$Server'." 


$Svr = $null
$Server = IsNull $Svr "[Alternate value]"
Write-Host -BackgroundColor White -ForegroundColor Black "`rThe variable `$Server has the value '$Server'." 



# This is why we need to evaluate $null in PowerShell in this format - ($null -eq ...) or ($null -ne ...)
($null -ne $null)
($null -ne $a, "Alternate", $null).count
$null -eq $Array

# even if we try to refer to a value by index 
($null -ne $a, "Alternate")[0]

