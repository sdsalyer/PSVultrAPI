function Remove-EmptyParams {
<#
    .Synopsis
        Cleans up empty params.
        
    .Description
        Removes any null or empty values in the hashtable passed in.

    .Example
        @{ prop1='a' ; prop2='b' } | Remove-EmptyParams

    .Inputs
        Hashtable of parameters for a Vultr API HTTP request.

    .Outputs
        Hashtable with empty values removed.
#>
    [CmdletBinding()]
    [OutputType([PSObject])]
    param(
        [parameter( Position=0, Mandatory=$true, ValueFromPipelineByPropertyName =$true, ValueFromPipeline=$true )]
        [alias('Parameters', 'Params', 'Body')]
        [Hashtable]$RequestBody = @{}
    )

    begin {}

    process{
        try {
            [Hashtable]$cleaned = @{}

			$cleaned = $RequestBody.GetEnumerator() | Where-Object Value | ForEach { $cleaned[$_.Name] = $_.Value }

			$cleaned
        } catch {

        }
        finally {

        }
    }

    end { }
}