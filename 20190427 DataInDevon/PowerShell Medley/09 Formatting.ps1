# Making output more readable
get-date


# to use in a file name we need all digits, in a specific order
get-date -format "yyyyMMddHHmmssfff"

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
[int]$x ++
$var1 = Get-Date -Format "yyyyMMMddHHmmss"
$var2 = "Step $x"
[int]$var3 +=

$log += "Timestamp: {0}`tName: {1}`tRetry: {2}`r`n" -f $var1, $var2, $var3

$log | Write-Output

# NOTE the {0}, {1}, {2} etc can be used multiple times in the string and dont have to be in any order. 
#       They are simply a reference to the values after the -f operator