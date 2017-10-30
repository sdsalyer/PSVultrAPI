function Get-VultrAccountInfo {
<#
    .Synopsis
        Gets account info.
        
    .Description
        Retrieve information about the current account from the Vultr API.

    .Parameter $VultrAPIKey
        The Vultr API Key of the user.

    .Example
        Get-VultrAccountInfo -Key (Get-Content api_key.txt)

        # Example Output:
        {
            "balance": "-5519.11",
            "pending_charges": "57.03",
            "last_payment_date": "2014-07-18 15:31:01",
            "last_payment_amount": "-1.00"
        }

    .Inputs
        String representation of the Vultr API key.

    .Outputs
        PSObject is returned, representing the JSON response body from the API. This can be piped to ConvertTo-Json
    
    .Notes
        Path:				/v1/account/info
        API Key Required:	Yes
        Request Type:		GET
        Required Access:	billing
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
            Get-Vultr 'account' 'info' -VultrAPIKey $VultrAPIKey
        }
        catch {
            throw
        }
        finally {
        
        }
        
    }

    end { }
}