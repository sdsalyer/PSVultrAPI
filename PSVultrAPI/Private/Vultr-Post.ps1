function Vultr-Post {
<#
    .Synopsis
        Shortcut for POST requests to Invoke-VultrAPI
        
    .Description
        Shortcut for POST requests to Invoke-VultrAPI

    .Parameter $APIGroup

    .Parameter $APIFunction

    .Parameter $VultrAPIKey
        
    .Parameter $RequestBody

    .Example

    .Inputs
        String representation of the Vultr API key.

    .Outputs
        PSObject is returned, representing the JSON response body from the API. This can be piped to ConvertTo-Json
#>
    [CmdletBinding()]
    [OutputType([PSObject])]
    param(
        [parameter( Position=0, Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('Group')]
        [string]$APIGroup,

        [parameter( Position=1, Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('Function', 'Call')]
        [string]$APIFunction,

        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('Key','APIKey')]
        [string]$VultrAPIKey,

        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('Parameters', 'Params', 'Body')]
        [Hashtable]$RequestBody = @{}
    )

    begin {}

    process{
        try {
            Invoke-VultrAPI -HTTPMethod POST -APIGroup $APIGroup -APIFunction $APIFunction -VultrAPIKey $VultrAPIKey -RequestBody $RequestBody
        }
        catch {
            throw
        }
        finally {
        
        }
        
    }

    end { }
}