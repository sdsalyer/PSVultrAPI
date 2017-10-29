function Invoke-VultrAPI {
<#
    .SYNOPSIS
    Invoke the Vultr API

    .DESCRIPTION

    .PARAMETER $HTTPMethod

    .PARAMETER $APIGroup

    .PARAMETER $APIFunction

    .PARAMETER $VultrAPIKey
\		
    .PARAMETER RequestBody

    .PARAMETER $Uri
    
    .PARAMETER $Version 

    .OUTPUTS
        The Vultr API returns JSON or an HTTP Status code. 

    .EXAMPLE  
        # GET request with no arguments.
        # curl "https://api.vultr.com/v1/os/list"
        Invoke-VultrAPI -HTTPMethod GET -APIGroup 'os' -APIFunction 'list'

    .EXAMPLE
        # GET request that requires your API key.
        # curl -H 'API-Key: YOURKEY' "https://api.vultr.com/v1/server/list"
        Invoke-VultrAPI -HTTPMethod GET -APIGroup 'server' -APIFunction 'list' -VultrAPIKey YOURKEY

    .EXAMPLE
        # GET request with additional parameters.
        # curl -H 'API-Key: YOURKEY' -G --data "SUBID=12345" "https://api.vultr.com/v1/server/list"
        Invoke-VultrAPI -HTTPMethod GET -APIGroup 'server' -APIFunction 'list' -RequestBody @{SUBID = 12345} -VultrAPIKey YOURKEY

    .EXAMPLE
        # POST request that requires your API key.
        # curl -H 'API-Key: YOURKEY' --data "SUBID=12345" "https://api.vultr.com/v1/server/start"
        Invoke-VultrAPI -HTTPMethod POST -APIGroup 'server' -APIFunction 'start' -RequestBody @{SUBID = 12345} -VultrAPIKey YOURKEY

    .EXAMPLE
        # POST request with additional parameters.
        # curl -H 'API-Key: YOURKEY' --data "SUBID=12345" --data-urlencode 'label=my server!' "https://api.vultr.com/v1/server/label_set"        
        Invoke-VultrAPI -HTTPMethod POST -APIGroup 'server' -APIFunction 'label_set' -RequestBody @{SUBID = 12345, label = 'my server!'} -VultrAPIKey (Get-Content -Path ..\Path\To\vultr_api_key.txt)
 
    .EXAMPLE
        # Extended example
        $key = Get-Content 'c:\path\to\api_key.txt'
        $group = 'dns'
        $getRecordFn = 'records'
        $updtRecrodFn = 'update_record'
        $myDomain = 'example.com'
        $myIpAddress = '0.0.0.0'

        $recordId = (Invoke-VultrAPI -HTTPMethod GET -APIGroup $group -APIFunction $getRecordFn -RequestBody @{ domain = $myDomain } -VultrAPIKey $key
            | ConvertTo-Json ).RECORDID

        $updtParams = @{
           domain = $myDomain,
           RECORDID = $recordId,
           data = $myIp
        }

        Invoke-VultrAPI -HTTPMethod POST -APIGroup $group -APIFunction $updtRecordFn -RequestBody $updtParams -VultrAPIKey $key
#>
    [CmdletBinding()]
    [OutputType([PSObject])]
    param(

        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [ValidateSet('GET', 'POST')]
        [alias('Method')]
        [string]$HTTPMethod,

        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('Group')]
        [string]$APIGroup,

        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('Function', 'Call')]
        [string]$APIFunction,

        [parameter( Mandatory=$false, ValueFromPipelineByPropertyName =$true )]
        [alias('Key','APIKey')]
        [string]$VultrAPIKey,
        #[System.Security.SecureString]$VultrAPIKey, # TODO: Debated using secure string, but not sure it's useful in any way 

        [alias('Parameters', 'Params', 'Body')]
        [Hashtable]$RequestBody = @{},

        [string]$Uri = 'https://api.vultr.com',

        [string]$Version = '1'
    )
    begin {}
    process{
        # Begin assembling the request URI
        $APIRequestUri = "$Uri/v$Version/$APIGroup/$APIFunction";

        #Write-Debug $APIRequestUri;

        # Not all API functions require a key
        if($VultrAPIKey) {
            $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]";
            $headers.Add("API-Key", $VultrAPIKey);
        }
            
        # Write-Debug "Request:`n`tURI: $uri`n`tMethod: $method`n`tHeaders: $(Out-String -InputObject $headers)`n`tParameters: $(Out-String -InputObject $parameters)";

        switch ($HTTPMethod) { 
            'GET' {
                # Parameterless GET requests
                #$apiCall = '/v1/account/info'; 
                #$apiCall = '/v1/dns/list';
                #$apiCall = '/v1/dns/records?domain=salyercreative.com';
                #$parameters = '';
                #$method = 'Get'; 

                # I suppose this isn't true after all
                # GET doesn't supply a body, but sometimes pases in URL parameters
                #if ($RequestBody.Count -gt 0) {
                #	$APIRequestUri + "?$($RequestBody -join '&')";
                #}

                # Write-Debug "Invoke-RestMethod -Method $HTTPMethod -Uri $APIRequestUri -Header $(Out-String -InputObject $headers)";
            } 
            'POST' {

                
                ##POST Requests
                # $apiCall = '/v1/dns/update_record';
                # <# 
                    # domain string Domain name to update record
                    # RECORDID integer ID of record to update (see /dns/records)
                    # name string (optional) Name (subdomain) of record
                    # data string (optional) Data for this record
                    # ttl integer (optional) TTL of this record
                    # priority integer (optional) (only required for MX and SRV) Priority of this record (omit the priority from the data)
                ##>
                # $parameters = @{
                   # domain = 'salyercreative.com';
                   # RECORDID = '4900476';
                   # data = $myIp;
                # };
                # $method = 'Post';

                # Write-Debug "Invoke-RestMethod -Method $HTTPMethod -Uri $APIRequestUri -Header $(Out-String -InputObject $headers) -Body $(Out-String -InputObject $RequestBody)";

            } 
            default {
                Write-Error 'No HTTP Method determined.';
            }
        }

        
        # Invoke the API
        try {
            $response = Invoke-RestMethod -Method $HTTPMethod -Uri $APIRequestUri -Header $headers -Body $RequestBody;
        }
        catch [System.Net.WebException]{
            # Handle HTTP Response Codes:

            [string]$errorMessage = '';
            switch ([int]$_.Exception.Response.StatusCode) {
                #Code	Description
                200{$errorMessage = 'Function successfully executed.'																   }
                400{$errorMessage = 'Invalid API location. Check the URL that you are using.'										   }
                403{$errorMessage = 'Invalid or missing API key. Check that your API key is present and matches your assigned key.'	   }
                405{$errorMessage = 'Invalid HTTP method. Check that the method (POST|GET) matches what the documentation indicates.'  }
                412{$errorMessage = 'Request failed. Check the response body for a more detailed description.'						   }
                500{$errorMessage = 'Internal server error. Try again at a later time.'												   }
                503{$errorMessage = 'Rate limit hit. API requests are limited to an average of 2/s. Try your request again later.'	   }
            }

            Write-Error ([string]::Format("PSVultrAPI Error : {0}", $errorMessage))
        }

        #Response is a PSObject representing JSON, so it can be converted using ConvertTo-Json
        $response | ConvertTo-Json;
    }
    end{}
}
