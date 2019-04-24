# Howe to find smallest +ve number that is exactly  divisible by all integers between 1 and 9 inclusive.

# the modulo operator will get us the result we need

# modulo is the value remaining after a division has been done. The value 'left over'
10 % 2

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
1..6000 | ForEach-Object {
    if ($_ % 2 -eq 0) {
        if ($_ % 3 -eq 0) {
            if ($_ % 4 -eq 0) {
                if ($_ % 5 -eq 0) {
                    if ($_ % 6 -eq 0) {
                        if ($_ % 7 -eq 0) {
                            if ($_ % 8 -eq 0) {
                                if ($_ % 9 -eq 0) {
                                    Write-Host "$_ is divisible by all" -ForegroundColor Green
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


# but can we be smarter? - attempt #1 
# idea - if we test in reverse order some digits remove need to test for smaller values
# original tests 2520 values for 2; 1260 for 3; 
$x = 0
10..6000 | ForEach-Object {
    if ($_ % 9 -eq 0) {
        # this will also check 3
        if ($_ % 8 -eq 0) {
            # this will check 4 and 2 also
            if ($_ % 7 -eq 0) {
                if ($_ % 6 -eq 0) {
                    if ($_ % 5 -eq 0) {
                        Write-Host "$_ is divisible by all" -ForegroundColor Green  
                        break
                    }
                }
            }
        }
    }
} # this tests 2511 at 9; 279 at 8; 35 at 7; 5 at 6

# turns out to be marginal

# but can we be smarter? - attempt #2
# idea - only testing values that are known to be multiples of 9 * 8
$tests = foreach ($n in $(1..50)) {9 * 8 * $n}
$tests | foreach-object {
    if ($_ % 7 -eq 0) {
        if ($_ % 6 -eq 0) {
            if ($_ % 5 -eq 0) {
                Write-Host "$_ is divisible by all" -ForegroundColor Green  
                break
            }
        }
    }
}
# This tests starts with only 35 values to test for 7 ... 
# occasional executions are sub 20ms

