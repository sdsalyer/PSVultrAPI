function Get-VultrDnsList {
<#
    .Synopsis
        Gets DNS list.
        
    .Description
        Retrieve DNS information from the Vultr API.

    .Parameter $VultrAPIKey
        The Vultr API Key of the user.

    .Example
        Get-VultrDnsList -Key (Get-Content api_key.txt)

        # Example Output:
		[
			{
				"domain": "example.com",
				"date_created": "2014-12-11 16:20:59"
			}
		]

    .Inputs
        String representation of the Vultr API key.

    .Outputs
        PSObject is returned, representing the JSON response body from the API. This can be piped to ConvertTo-Json
    
    .Notes
        Path:				/v1/dns/list
        API Key Required:	Yes
        Request Type:		GET
		Required Access:	dns
#>
    [cmdletbinding()]
    param(
        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true, ValueFromPipeline=$true )]
        [alias('Key','APIKey')]
        [string]$VultrAPIKey
    )

    begin { }
    
    process {
    
        try {
            Vultr-Get 'dns' 'list' -VultrAPIKey $VultrAPIKey
        }
        catch {
            throw
        }
        finally {
        
        }
        
    }

    end { }
}