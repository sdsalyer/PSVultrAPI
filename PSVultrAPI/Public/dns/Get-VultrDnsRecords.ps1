function Get-VultrDnsRecords {
<#
    .Synopsis
        Gets DNS records for a domain.
        
    .Description
        Retrieve DNS record information for the specified domain from the Vultr API.

    .Parameter $VultrAPIKey
        string The Vultr API Key of the user.

    .Example
        Get-VultrDnsRecords -Key (Get-Content api_key.txt) -Domain example.com

        # Example Output:
		[
			{
				"type": "A",
				"name": "",
				"data": "127.0.0.1",
				"priority": 0,
				"RECORDID": 1265276,
				"ttl": 300
			},
			{
				"type": "CNAME",
				"name": "*",
				"data": "example.com",
				"priority": 0,
				"RECORDID": 1265277,
				"ttl": 300
			}
		]

    .Inputs
        String representation of the Vultr API key.

    .Outputs
        PSObject is returned, representing the JSON response body from the API. This can be piped to ConvertTo-Json
    
    .Notes
        Path:				/v1/dns/records
        API Key Required:	Yes
        Request Type:		GET
		Required Access:	dns
#>
    [cmdletbinding()]
    param(
        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true, ValueFromPipeline=$true )]
        [alias('Key','APIKey')]
        [string]$VultrAPIKey,

        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('Domain')]
        [string]$DomainName
    )

    begin { }
    
    process {
    
        try {
			$params = @{
				domain = $DomainName
			}

            Get-Vultr 'dns' 'records' -VultrAPIKey $VultrAPIKey -RequestBody $params
        }
        catch {
            throw
        }
        finally {
        
        }
        
    }

    end { }
}