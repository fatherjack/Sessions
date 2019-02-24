cls
# sorting values with PowerShell

# perhaps we have a list of things ...
Get-Service | Select-Object Status, StartType, Name

# sorting is easy. right?
# let's sort by Status, then StartType, then Name
Get-Service | Select-Object Name, Status, StartType | Sort-Object Status, StartType, Name



# what if we want them in descending Status order but also Name then StartType order????

# attempt 1. ?
Get-Service | Select-Object Name, Status, StartType | Sort-Object Status -Descending, StartType, Name



#2. for correct syntax -Descending has to go at the end
Get-Service | Select-Object Name, Status, StartType | Sort-Object Status, StartType, Name -Descending 



#3.
Get-Service | Select-Object Name, Status, StartType | Sort-Object @{expression="Status"; Descending = $True}, StartType, Name



#4. - a trailing -Descending affects all columns not affected by a specific Descending=$true
Get-Service | Select-Object Status, Name, StartType | Sort-Object @{expression="Status"; Descending = $True}, StartType, Name -Descending



#5.
Get-Service | Select-Object Status, Name, StartType | Sort-Object @{expression="Status"; Descending = $True}, StartType, @{expression="Name";Descending=$false} -Descending
# Status is explicitly Descending > Running then Stopped
# StartType is Descending by the -Descending at the end
# Name is explicitly Ascending - by specifying Descending = $False
