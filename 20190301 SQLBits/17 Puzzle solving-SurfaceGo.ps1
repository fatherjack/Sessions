# Howe to find smallest +ve number that is exactly  divisible by all integers between 1 and 9 inclusive.

# the modulo operator will get us the result we need

# module is the value remaining after a division has been done. The value 'left over'
10 % 1

10 % 3

10 % 7

# so, lets evaluate some integers

# every number is divisible by 1 so no need to test that
50 % 2
50 % 3
50 % 4
50 % 5
50 % 6
50 % 7
50 % 8
50 % 9

# a mix of 0's and 1's, 2's and a 5 ...

# it's going to be a long day if we have to type in every number to test it. we need to look at looping through a set of values
# we could create a file with all the numbers in it and read that into our script but PowerShell has something neater to use.

# next we generate a range of values with ..
1..10

-5..5

10..5

10.1..11.1 # only integers

# Now we can send a range of values that need evaluating into our test
1..3000 | ForEach-Object {
            if ($_ % 2 -eq 0) {
                if ($_ % 3 -eq 0) {
                    if ($_ % 4 -eq 0) {
                        if ($_ % 5 -eq 0) {
                            if ($_ % 6 -eq 0) {
                                if ($_ % 7 -eq 0) {
                                    if ($_ % 8 -eq 0) {
                                        if ($_ % 9 -eq 0) {
                                            # Write-Host "$_ is divisible by all" -ForegroundColor Green
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        

# but can we be smarter?
    1..3000 | ForEach-Object {
        if ($_ % 9 -eq 0) {# this will also check 3
            if ($_ % 8 -eq 0) {# this will check 4 and 2 also
                if ($_ % 7 -eq 0) {
                    if ($_ % 6 -eq 0) {
                        if ($_ % 5 -eq 0) {
                            # Write-Host "$_ is divisible by all" -ForegroundColor Green  
                        break
                        }
                    }
                }
            }
        }
    }

    # turns out only a little

1..3000 | ForEach-Object {
    switch ($_) {
        {$_ % 9 -ne 0} {"a";} # will also do 3
        {$_ % 8 -ne 0} {"b";} # will also do 4 and 2
        {$_ % 7 -ne 0} {"c";} 
        {$_ % 6 -ne 0} {"d";} 
        {$_ % 5 -ne 0} {"e";}
        default {
            # write-host "$_ : is divisible by 1,2,3,4,5,6,7,8, and 9" -ForegroundColor Green
        break
        }
    }
}

[float]1..9 | ForEach-Object {Write-Output "$find / $_ = $($find/$_)"}

1..6000 | ForEach-Object {
    [int]$pass = $null
    Write-Host "$_-" -nonewline
    switch ($_) {
        {$_ % 9 -eq 0} {$pass += 1} # will also do 3
        {$_ % 8 -eq 0} {$pass += 10} # will also do 4 and 2
        {$_ % 7 -eq 0} {$pass += 100} 
        {$_ % 6 -eq 0} {$pass += 1000} 
        {$_ % 5 -eq 0} {$pass += 10000}
    }
    if ($pass -eq 11111) {
        $find = $_
        write-host "$_ : is divisible by 1,2,3,4,5,6,7,8, and 9" -ForegroundColor Green
        [float]1..9 | ForEach-Object {Write-Output "$find / $_ = $($find/$_)"}
        break
    }
    else {
        Write-Host "$pass :  is not divisible" -foregroundcolor red
    }    
}

# 'Production' version

1..6000 | ForEach-Object {
    [int]$pass = $null
    switch ($_) {
        {$_ % 9 -eq 0} {$pass += 1 } # will also do 3
        {$_ % 8 -eq 0} {$pass += 10} # will also do 4 and 2
        {$_ % 7 -eq 0} {$pass += 100} 
        {$_ % 6 -eq 0} {$pass += 1000} 
        {$_ % 5 -eq 0} {$pass += 10000}
    }
    if ($pass -eq 11111) {
        $find = $_
        Write-Output "$_ : is divisible by 1,2,3,4,5,6,7,8, and 9"
        [float]1..9 | ForEach-Object {Write-Output "$find / $_ = $($find/$_)"}
        break
    }
    else {
        Write-Verbose "$pass :  is not divisible"
    }    
}



[array]$t = @(1, 2, 3, 4, 5)

1..3 | % {$_ * ($t[0..-1])}

3*$t[0..($t.count-1).value]

$t = @{
    "1"=1
    "2"=2
    "3"=3
    "4"=4
    "5"=5
}


ForEach-Object {10..3000} -pv Left | 
    foreach {9, 8, 7, 6, 5; $Test = 5} -pv Right | 
        foreach {
            #write-host $Test -foregroundcolor Blue
            $count = 0
            if($Left % $Right -eq 0){
                $count ++
            }
            if($count -eq $Test){
                Write-Verbose "`$count is $count"
                Write-Verbose "`$test is $test"
                Write-Verbose "`$right is $right"
                $Result = $Left
                $Count = 0
                break
            }
        }
        "$Result is divisible by all numbers 1..9"
