# Interesting demonstration of performance difference between 
# from https://powershell.org/forums/topic/arraylist-c-vs-powershell-is-it-the-same-thing-or-not/
# there is more that just this performance to consider but the method of measurement is also of interest
function Test-Array {
    Param(
        $Iterations = 20000,
        $OutputEvery = 1000
    )

    $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()

    $Array = @()
    for ($i = 1 ; $i -le $Iterations ; $i++) {
        if (-not ($i % $OutputEvery)) { "{0}`t{1}" -f 'Records processed:', $i }
    
        $Array += $i
    }

    $StopWatch.Stop()

    [PSCustomObject]@{
        ArrayCount      = $Array.Count
        DurationSeconds = [Math]::Round($StopWatch.Elapsed.TotalSeconds, 2)
        MemoryUsageMB   = [Math]::Round((Get-Process -Id $pid).WorkingSet / 1MB, 2)
    }
}

function Test-ArrayList {
    Param(
        $Iterations = 20000,
        $OutputEvery = 1000
    )

    $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()

    $Array = New-Object System.Collections.ArrayList
    for ($i = 1 ; $i -le $Iterations ; $i++) {
        if (-not ($i % $OutputEvery)) { "{0}`t{1}" -f 'Records processed:', $i }
    
        [void]($Array.Add($i))
    }

    $StopWatch.Stop()

    [PSCustomObject]@{
        ArrayCount      = $Array.Count
        DurationSeconds = [Math]::Round($StopWatch.Elapsed.TotalSeconds, 2)
        MemoryUsageMB   = [Math]::Round((Get-Process -Id $pid).WorkingSet / 1MB, 2)
    }
}


Test-Array -Iterations 20000 -OutputEvery 5000
<#
ArrayCount DurationSeconds MemoryUsageMB
---------- --------------- -------------
     20000              18        280.48#>

Test-ArrayList -Iterations 20000 -OutputEvery 5000
<#
ArrayCount DurationSeconds MemoryUsageMB
---------- --------------- -------------
     20000            0.01        280.57#>