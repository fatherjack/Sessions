
# 
function Function8 {
    param($val)
    $a = gl 
    $b = "List.txt"
    $a | ac $b -Force 
    $val
}
Function8 "hello"


# expand aliases
function Function8 {
    param($val)
    $a = Get-Location
    $b = "List.txt"
    $a | Add-Content $b -Force 
    $val
}
Function8 "hello"


# useful variable names
function Function8 {
    param($Completed_message)
    $Location = Get-Location
    $OutputFilename = "List.txt"
    $Location | Add-Content $OutputFilename -Force     
    $Completed_message
}
Function8 "hello"



# have reasonable breaks in code sections 
# If your code editor has a code format function - use it
# use Write-Output
function Function8 {
    param($Completed_message)

    $Location = Get-Location
    $OutputFilename = "List.txt"
    
    $Location | Add-Content $OutputFilename -Force     
    
    Write-Output  $Completed_message  
}
Function8 "hello"


# use Begin, Process, and End blocks
function Function8 {
    param($Completed_message)

    Begin {
        $Location = Get-Location
        $OutputFilename = "List.txt"
    }
    
    Process {
        $Location | Add-Content $OutputFilename -Force     
    }
    
    End {
        $Completed_message
    }
}

Function8 "hello"

# add common comment block using command_help snippet
function Function8 {
    <#
    .SYNOPSIS
        Places current location into a text file
    .DESCRIPTION
        Places current location into a text file. Returns optional string parameter as confirmation of function completion
    .EXAMPLE
        function8 

        results in file created 

    .EXAMPLE
        function8 "It's all over"

        results in file created and message "It's all over" at the host
        
    #>
    param($Completed_message)

    begin {
        $Location = Get-Location
        $OutputFilename = "List.txt"
    }
    
    process {$Location | Add-Content $OutputFilename -Force     }
    
    end {
        $Completed_message
    }
}
Function8 "hello"

get-help Function8 -Examples

# function cmdlet binding to make it work like a compiled  c#-like cmdlet
<#
    ConfirmImpact
    DefaultParameterSetName
    HelpURI
    SupportsPaging
    SupportsShouldProcess
    PositionalBinding
#>
function Function8 {
    <#
    .SYNOPSIS
        Places current location into a text file
    .DESCRIPTION
        Places current location into a text file. Returns optional string parameter as confirmation of function completion
    .EXAMPLE
        function8 

        results in file created 

    .EXAMPLE
        function8 "It's all over"

        results in file created and message "It's all over" at the host
        
    #>
    [cmdletbinding(SupportsShouldProcess = $True)]
    param($Completed_message)

    begin {
        $Location = Get-Location
        $OutputFilename = "List.txt"
    }
    
    process {$Location | Add-Content $OutputFilename -Force     }
    
    end {
        $Completed_message
    }
}

get-help Function8

get-help Function8 -Examples

get-help Function8 -ShowWindow

# SupportsShouldProcess lets us try out the function without risk of making changes
Function8 -whatif


$ErrorActionPreference = continue
# define the parameters accurately to increase chances of success
function Function8 {
    <#
    .SYNOPSIS
        Places current location into a text file
    .DESCRIPTION
        Places current location into a text file. Returns optional string parameter as confirmation of function completion
    .EXAMPLE
        function8 

        results in file created 

    .EXAMPLE
        function8 "It's all over"

        results in file created and message "It's all over" at the host
        
    #>
    [cmdletbinding(SupportsShouldProcess = $True)]
    param(

        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "PrimarySet",
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "the message to be displayed when complete")]
        [Alias("Msg")]
        [ValidateNotNullOrEmpty()]
        [string]$Completed_message,
        
        # A parameter with a specific range of values
        [Parameter(Mandatory = $True)]
        [ValidateRange(1, 20)]
        [int]$MyInt,

        # A parameter with a fixed set of values
        [Parameter(Mandatory = $True)]
        [Validateset('Mars', 'Milky Way', 'Twix')]
        [string]$MySet
    )
    # Specifies a path to one or more locations.

    begin {
        $Location = Get-Location
        $OutputFilename = "List.txt"
    }
    
    process {$Location | Add-Content $OutputFilename -Force     }
    
    end {
        $Completed_message
    }
}

function8 

function8 -Completed_message "test" -MyInt 45 -MySet "Milky Way"

function8 -Completed_message "test" -MyInt 15 -MySet "Twix"


# finally - use a sensible function name that follows the Verb-Noun convention 

# Function8 is a ridiculous name

