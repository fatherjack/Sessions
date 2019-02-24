# Making output more readable
Get-Date


# to use in a file name we need all digits, in a specific order
Get-Date -format "yyyyMMdd_HHmmssfff"

# placing variable values in a string can be a pain
(Get-Date).DayOfWeek

$var1 = (Get-Date).DayOfWeek

"It is $var1 today" | Write-Output 

$var1 = Get-Date
"It is $var1 today" | Write-Output 

"It is $var1.dayofweek today" | Write-Output 

"It is $($var1.dayofweek) today" | Write-Output 

"It is {0} today" -f $var1.dayofweek | Write-Output 


# where can we use it ? how about logging script progress
[int]$x = 1
$var1 = Get-Date -Format "yyyyMMMddHHmmss"
$var2 = "Step $x"
[int]$var3 = $x + 1

$log += "Timestamp: {0}`tName: {1}`tRetry: {2}`r`n" -f $var1, $var2, $var3

$log | Write-Output

# NOTE the {0}, {1}, {2} etc can be used multiple times in the string and dont have to be in any order. 
#       They are simply a reference to the values after the -f operator

[int]$WorktoDo = 280
[int]$CurrentStep = 59

"The process is in step {0}, it is {1:P} complete." -f $CurrentStep, ($CurrentStep / $WorktoDo)

<# Format options
:c      Currency format (for the current culture)
:d	    Decimal. (:dP precision=number of digits); if needed, leading zeroes are added to the beginning of the number. { "{0:d4}" -f 12 }
:e	    Scientific (exp) notation
:f	    Fixed point {:f5 = fix to 5 places}
:g	    Most compact format, fixed or sci {:g5 = 5 significant digits}
:n	    Number (:nP precision=number of decimal places), includes culture separator for thousands 1,000.00
:p	    Percentage
:r	    Reversible Precision
:x	    Hex format
:hh \
:mm  =   Convert a DateTime to a 2 digit Hour/minute/second {"{0:hh}:{0:mm}:{0:ss}" -f (get-date)}
:ss	| 

:HH	    Hour in 24 Hour format
:dd	    Day of Month
:ddd	Convert a DateTime to Day of the Week
:dddd	Full name of Day of Week
:yyyy	Full year
#	    Digit Place Holder { "{0:####.##}" -f 123.45678 }
}

from https://ss64.com/ps/syntax-f-operator.html
#>

# alternately use the static type Format method
$Greeting = "Welcome to"
$name = "SQLBits"
$what = "Europe's largest data conference"
$message = [string]::Format("{0} {1} {2}", $greeting, $name, $what)

Write-Host $message