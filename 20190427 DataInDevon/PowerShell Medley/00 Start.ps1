function Start-PowershellMedley {
    <#

> decide on 
    session duration
    number of topics to deliver

> open powershell console

> execute following commands

 Set-Location [to location of this file eg #'C:\Users\jonallen\OneDrive\Sessions\PowerShell Medley ]                                               
 & '.\00 Start.ps1'                                                                                                
 start-powershellmedley -SessionDuration 50 -TopicCount 8

> start presentation


    #>
    [CmdletBinding()]
    param (
        # Specifies duration of the session
        [Parameter(HelpMessage = "How long is the session - in minutes.")]
        [ValidateRange(15, 90)]
        [int32]$SessionDuration = 60,
        # Specifies number of topics in the session
        [Parameter(HelpMessage = "How many topics are in the session.")]
        [ValidateRange(1, 8)]
        [int32]$TopicCount = 7,
        # Optional name of speaker 
        [Parameter()]
        [String]$SpeakerName = $null      
    )
    
    begin {
        # we need a spvoice object to get PowerShell to talk
        $s = New-Object -ComObject sapi.spvoice

        # the changetopic interval is the session duration number of divided by the topic count
        $ChangeTopic = [math]::floor($SessionDuration / $TopicCount)

        # are we setting ourselves too much of a challenge?
        if ($ChangeTopic -lt 5) {
            $str = "$TopicCount topics in $SessionDuration minutes $Speaker?"
            $r = $s.speak($str)
            Start-Sleep -Seconds 0.7
            $str = "You dont stand a chance."
            $r = $s.speak($str)
        }
        else {
            # some encouragement to get going
            $str = "Jonathan, you have $changetopic minutes per topic."
            $r = $s.speak($str)
            Start-Sleep -Seconds 0.5
            $str = "You'd better get started hadnt you?"
            $r = $s.speak($str)            
        }


        if ($ChangeTopic -ge 3) {
            [int]$Warning = $ChangeTopic - 3
        }
        else {
            $Warning = 3
        }
        "ChangeTopic : $changetopic" | write-debug
    }
    
    process {
        # check to see if this minute needs to make an announcement
        1..$SessionDuration | % {
            "Minute: $_" | write-debug
            switch ($_) {
                # checking for a modulus of 0 on the minute when compared with the 
                # session length to give a change topic message or check for 3 minutes before that for the warning
                {(($_ -gt 3) -and (($_ % $Warning -eq 0)))} {
                    $str = "Get ready to change topic in 3 minutes."
                    "Warning : $Warning " | write-debug
                    $vw = (($_ % $Warning))
                }
                {$_ % $ChangeTopic -eq 0} {$str = "change topic."}
                # it we dont want a message then null the string so that no message is played
                default {$str = $null}
            }
            # if there is a message - play a tone and then play the message
            if ($str) {
                if ($str -eq "change topic.") {
                    [console]::beep(2000, 900); [console]::beep(3000, 900); [console]::beep(2500, 900)
                }
                else {
                    1..3 | % {[console]::beep(2500, 500); } 
                }
                
                if ($_ -eq $SessionDuration) {
                    1..5 | % {[console]::beep(2700, 500); } 
                    $Str = "That's it, the session is over. I hope you covered everything."
                }
                $r = $s.speak($str)
            }

            # delay for next minute
            start-sleep -Seconds 60
        }
    }
    
    end {
    }
}