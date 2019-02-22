<#
get info from Netstat and parse it

# help for netstat
 netstat /?


#>

# retrieve netstat results into variable
$a = netstat -no

# check details - we need to remove top few rows
$a[1..10]

# convertfrom-string is our friend
$a[4..20] | ConvertFrom-String 

# now we can choose the columns we want
$a[4..20] | ConvertFrom-String | Select-Object p2, p3, p4, p5, p6 

# place all of this into a new variable (also add filter - we dont want connections held by pid 0)
$ns = $a[4..$a.count] | ConvertFrom-String | Select-Object p2, p3, p4, p5, p6 | Where-Object p6 -ne 0

# group the info
$ns | Group-Object p6 

# which processes have the most connections
$ns | Group-Object p6 | Sort-Object count -Descending 

# if we expand the Group information we can use it ...
$ns | Group-Object p6 | Sort-Object count -Descending | Select-Object -first 3 -ExpandProperty group

# send the process ID from Netstat for highest number of connections to Get-Process so we can pick the right application to blame
$ns | Group-Object p6 | Sort-Object count -Descending | Select-Object -first 3 -ExpandProperty group | Select-Object p6 -Unique | ForEach-Object {get-process -id $_.p6}

# find processes that have a status that is like *WAIT*
# this isnt 'quite' what we want because the pipeline swallows the status value as a heading
$ns | Where-Object p5 -like *wait* | Select-Object -unique p5, p6 | ForEach-Object {get-process -id $_.p6 | Select-Object ProcessName, $_.p5}

# ... so we need to use a pipeline variable to 'carry' the p5 value from the first Select-Object cmdlet to the second one 
# line breaks after a | are used to make this more readable.
$ns | Where-Object p5 -like *wait* | 
    Select-Object -unique p5, p6 -PipelineVariable p5p6 |
        ForEach-Object {
            get-process -id $_.p6 | Select-Object ProcessName, @{name = "Status"; expression = {$p5p6.p5}} 
        }
