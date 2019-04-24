# protecting ourselves from running destructive code

# we can stop a service very easily from PowerShell
Stop-Service BITS 

# we can also see what *would* happen by using the -WhatIf parameter
Stop-Service BITS -WhatIf

# we can add this ability to our own scripts with only a few steps

# First we need to reference the [CmdletBinding()]
<# from PowerShell Help

TOPIC
    about_Functions_CmdletBindingAttribute

SHORT DESCRIPTION
    Describes the attribute that makes a function work like a
    compiled cmdlet.
#>

# CmdletBinding does two things:
# - enables the $Cmdlet builtin variable for access
# - allow specification of ConfirmImpact or SupportsShouldProcess 

function Invoke-Changes {
    <#
    .Description
    Does something really dangerous, be careful how you use it

    .Example
    '127.0.0.1', 'localhost' | Invoke-Changes -packets 1 
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [parameter(ValueFromPipeline = $true)][string]$Computername = $null,
        [int]$packets = 2
    )
 
    Process {
        Write-Verbose 'Function Process block - about to stop BITS service' #Stop-Service BITS 
        
        # if we call our function with -WhatIf then a 'built-in' command that natively accepts -WhatIf will execute its WhatIf output
        Start-Service BITS -Computername $Computername
        
        # If we want to provide custom WhatIf functionality to code that doesn't already have a -WhatIf parameter 
        # then we need to use IF logic to test the $PSCmdlet.ShouldProcess property. 
        
        if ( $PSCmdlet.ShouldProcess($Computername, "Sending $packets Ping packets" )) {
            Write-Verbose "Processing Ping step"
            # even if the code is non-destructive we get the -WhatIf functionality
            Test-Connection $Computername
        }
    }
}
# double safe - ask for confirmation and only tell me what would happen
Invoke-Changes -Computername $env:COMPUTERNAME -Confirm -WhatIf 

# safe - no changes, only tell me what would happen
Invoke-Changes -Computername $env:COMPUTERNAME -Verbose -WhatIf 

# safe - ask me before making any changes
Invoke-Changes -Computername $env:COMPUTERNAME -Confirm

# running with scissors
Invoke-Changes -Computername $env:COMPUTERNAME -Verbose


<#
This example is not intended to be run as a single script. Read and understand the function definition and then run that code 
to create the function Invoke-Changes in your PowerShell session and then run the last for calls to the function one at a time 
to see the difference to the way the function responds to the parameters.

Please note this function also potentially affects the status of the BITS service. Do not run this script on a computer where
 this service is important and always remember to reset the service status to its original value once the testing has been completed.
#>