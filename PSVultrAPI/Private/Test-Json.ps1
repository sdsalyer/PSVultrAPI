function Test-Json {
<#
    .Synopsis
        Test if JSON data is valid.
        
    .Description
        Test if JSON data is valid.

    .Parameter $JSONObject
        PSObject containing JSON data.

    .Example
        @{ prop1='a' ; prop2='b' } | ConvertTo-Json | Test-Json

    .Inputs
        PSObject containing JSON data.

    .Outputs
        Boolean - true if valid JSON, false otherwise.
#>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [parameter( Position=0, Mandatory=$true, ValueFromPipelineByPropertyName =$true, ValueFromPipeline=$true )]
        [alias('JSON')]
        [PsObject]$JSONObject
    )

    begin {}

    process{
        [bool]$validJson = $false

        try {
            $powershellRepresentation = ConvertFrom-Json $JSONObject -ErrorAction Stop
            $validJson = $true
        } catch {
            Write-Debug "Something went wrong in Test-Json"
            $validJson = $false
        }
        finally {
            
            if ($validJson) {
                Write-Verbose "Provided text has been correctly parsed to JSON"
            } else {
                Write-Verbose "Provided text is not a valid JSON string"
            }

            $validJson
        }
    }

    end { }
}