# Use the more functions to control output where it scrolls by way too fast
###########################################################################

# perhaps we are working in a directory with a lot of files / sub-directories
Set-Location "C:\WINDOWS\System32"

# and we have to list them all 
Get-ChildItem 

# that's a lot of files ...
(Get-ChildItem).count


# isnt it easier if we pause the stream of items as it is displayed ....
Get-ChildItem | Where-Object {$_.Length -gt 1MB} | sort-object name | more

