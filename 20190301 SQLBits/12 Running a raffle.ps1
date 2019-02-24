# What do we need to run a raffle

# 1 a random number - within a given upper and lower limit

# 2 a way to display this random number

# set up
if (Test-Path "C:\temp\Raffle.html") {Remove-Item "C:\temp\Raffle.html" }
if (!(Test-Path "C:\Temp")) {New-Item -Path "C:\Temp" -ItemType Directory}
$head = Get-Content (Join-Path $env:OneDrive "\Sessions\PowerShell Medley\RaffleHeader.html") # ii $head
$Outfile = "C:\temp\Raffle.html"
[int]$r = $null

# Get-Random - PowerShell has everything!!
$r = Get-Random -Minimum 65 -Maximum 178

# embed our random number in a basic HTML body element containing a table with a closing Body and HTML tags
$frag = 
@"
<H1>The winner of the {prize name} is:</H1>
<TABLE>
    <tr>
        <td style="font-weight:bold; font-size:150px;">
        $($r)
        </td>
    </tr>
</TABLE>
</body>
</html>
"@

# use ConvertTo-HTML to combine the predefined HTML Head content with a custom Title and our Body fragment
ConvertTo-Html -Head $head -Body $frag -Title "Winning raffle ticket" > $Outfile 

# check it out 
Invoke-Item $Outfile

# or perhaps you want to run a lottery ?
########################################
$LuckyNumbers = New-Object System.Collections.ArrayList
do {
    [int]$r = get-random -minimum 1 -maximum 39
    if (!($LuckyNumbers.Contains($r) )) {
        $waste = $LuckyNumbers.Add($r)
    }
}until ($LuckyNumbers.count -ge 6)
$LuckyNumbers.sort() 
write-host $LuckyNumbers
$frag = 
@"
<H1 style="font-weight:bold; font-size:100px;font-family:verdana;">The winner of the SQLBits Lottery is:</H1>
<TABLE style="font-weight:bold; font-size:50px;font-family:verdana;">
    <tr>
        <td >
        $LuckyNumbers
        </td>
    </tr>
</TABLE>
</body>
</html>
"@
ConvertTo-Html -Head $head -Body $frag -Title "Winning lottery ticket" > $Outfile 

# check it out 
Invoke-Item $Outfile

