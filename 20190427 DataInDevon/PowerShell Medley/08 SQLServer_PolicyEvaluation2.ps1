<#
Evaluating SQL Server Policy Based Management policies without using SSMS
#>

Import-Module sqlps -DisableNameChecking 

$Server = "$ENV:COMPUTERNAME\sql2016"

# where are the SQL Server policies located?
$PolicyLocation = "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Policies\DatabaseEngine\1033"

# how many do we have?
(Get-ChildItem $PolicyLocation).Count


# what do they cover?
Get-ChildItem $PolicyLocation | Select-Object Name


# evaluate a policy by providing the location to the policy definition
Invoke-PolicyEvaluation -TargetServerName $Server -Policy (join-path $PolicyLocation "Windows Event Log Storage System I_O Timeout Error.xml")



# evaluating multiple policies is as simple as picking the policies we want
Get-ChildItem $PolicyLocation -Filter "*mail*" | ForEach-Object {    
        Invoke-PolicyEvaluation -TargetServerName $Server -Policy (join-path $PolicyLocation $_.name)
}

# doing this on multiple servers isn't a big step
$Servers = @("$ENV:COMPUTERNAME\sql2014","$ENV:COMPUTERNAME\sql2016")
$Policies = Get-ChildItem $PolicyLocation -Filter "*password*"

ForEach ($Server in $Servers){
    "Checking $Server" | Write-Output
    ForEach($Policy in $Policies) {
        Invoke-PolicyEvaluation -TargetServerName $Server -Policy (join-path $PolicyLocation $Policy.name)
    }
}


# not so tidy as we wanted with the server name breaking into the output



$Policies = Get-ChildItem $PolicyLocation -Filter "*log*"
$output = @()
ForEach ($Server in $Servers) {
    "Checking $Server" | Write-Output
    ForEach ($Policy in $Policies) {
        $r = Invoke-PolicyEvaluation -TargetServerName $Server -Policy (join-path $PolicyLocation $Policy.name) | Select-Object @{name = 'server'; expression = {$server}}, *
        $output += $r
    }
}

$output | Select-Object server, policyname, result

#   whats in the policy xml?

$policy = "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Policies\DatabaseEngine\1033\Guest Permissions.xml"
[xml]$doc = get-content $policy

$name = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.name
$desc = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.description

"`r`nName:`r`n$($name.InnerText)" | Write-Output
"`r`nDescription:`r`n$($desc.InnerText)" | Write-Output

# let's get the description of each of our policies
$output = @()
Get-ChildItem $PolicyLocation | ForEach-Object {
    [xml]$doc = get-content $_.FullName
    $name = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.name
    $desc = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.description
    $r = $doc | Select-Object @{name="Name";expression={$name.InnerText}},@{name="Desc";expression={$desc.InnerText}}
    $output += $r
}
$output

# What else is in the XML?
# How about a policy category

$Category = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.PolicyCategory

"`r`n$($category.InnerText)" | Write-Output

# lets find all the categories

$PolicyLocation = "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Policies\DatabaseEngine\1033"

$output = @()
Get-ChildItem $PolicyLocation | ForEach-Object {
    [xml]$doc = get-content $_.FullName
    $name = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.name
    $Category = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.PolicyCategory
    $r = $doc | Select-Object @{name = "Name"; expression = {$name.InnerText}}, @{name = "Category"; expression = {$Category.InnerText}}
    $output += $r
}
$output | Sort-Object -Property Category, Name

# What categories are in use?
$output | Select-Object Category -Unique

# What policies are in a category?
$PolCat = "Microsoft Best Practices: Performance"
$output = @()
Get-ChildItem $PolicyLocation | ForEach-Object {
    [xml]$doc = get-content $_.FullName
    $x = $_
    $Category = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.PolicyCategory
    if ($Category.InnerText -eq $PolCat) {
        $name = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.name
        $r = $doc | Select-Object @{name = "Name"; expression = {$name.InnerText}}, @{name = "PolicyFile"; expression = {$x.Name}}
        $output += $r
    }
}
$output


# How about a policy help link?
($doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.HelpLink).InnerText | Write-Output

$PolicyLocation = "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Policies\DatabaseEngine\1033"

$output = @()
Get-ChildItem $PolicyLocation | ForEach-Object {
    [xml]$doc = get-content $_.FullName
    $name = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.name
    $Help = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.HelpLink
    $r = $doc | Select-Object @{name = "Name"; expression = {$name.InnerText}}, @{name = "HelpURL"; expression = {$Help.InnerText}}
    $output += $r
}
$output | Sort-Object -Property Name, HelpURL

# Let's make this presentable and accessible
$PoliciesPage = "c:\temp\Policies.htm"

$output = @()

Get-ChildItem $PolicyLocation | ForEach-Object {
    [xml]$doc = get-content $_.FullName
    $name = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.name
    $Help = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.HelpLink
    $Category = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.PolicyCategory
    $desc = $doc.model.bufferSchema.definitions.document.data.schema.bufferData.instances.document.data.policy.description

    $r = $doc | Select-Object @{name = "Name"; expression = {$name.InnerText}}, @{name = "HelpURL"; expression = {$Help.InnerText}}, @{name = "Category"; expression = {$Category.InnerText}}, @{name = "Desc"; expression = {$desc.InnerText}}
    $output += $r
}

$output | ConvertTo-Html -Title "SQL Server Policies" -Body (get-date) > $PoliciesPage; Invoke-Item $PoliciesPage

# not much use without a clickable link ..
$output | Select-Object name, @{name = "Help URL"; expression = {"<a target=`"_blank`" href=`"$_.HelpURL`">$_.HelpURL<\a>"}} | ConvertTo-Html -Fragment

$safehtml = $output | Select-Object name, category, desc, @{name = "Help URL"; expression = {"<a target=`"_blank`" href=`"$($_.HelpURL)`"> $($_.HelpURL)</a>"}}  | ConvertTo-Html -Title "SQL Server Policies"  -Head "SQL Server policies available"

Add-Type -AssemblyName System.Web
$webhtml = [System.Web.HttpUtility]::HtmlDecode($safehtml) 

set-content -Path $PoliciesPage -Value $webhtml

Invoke-Item $PoliciesPage


