ri "C:\temp\Raffle.html"
$head = Get-Content "C:\Users\Jonathan\OneDrive\Sessions\PowerShell Medley\RaffleHeader.html"
$Outfile = "C:\temp\Raffle.html"

[int]$r = $null
$r = Get-Random -Minimum 164 -Maximum 178

$frag = 
@"
<H1>The winner of the AMAZON voucher is:</H1>
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

ConvertTo-Html -Head $head -Body $frag -Title "Winning raffle ticket" > $Outfile


Start-Process iexplore $Outfile

