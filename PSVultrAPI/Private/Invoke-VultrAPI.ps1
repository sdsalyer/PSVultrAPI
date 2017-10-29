Function Invoke-VultrAPI {
<#
	.SYNOPSIS
	Invoke the Vultr API

	.DESCRIPTION
	.PARAMETER <param1 name>
	.PARAMETER <param(n) name>
	.INPUTS
	.OUTPUTS
	.EXAMPLE
	.EXAMPLE
	.LINK
#>
	[CmdletBinding()]
	#[OutputType([psobject])] # http response object ?
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

# 400
#Invoke-VultrAPI -HTTPMethod GET -APIGroup 'os' -APIFunction 'derp'

# 200
#Invoke-VultrAPI -HTTPMethod GET -APIGroup 'os' -APIFunction 'list'

# /v1/dns/records (?domain=example.com)
# /v1/dns/list
#Invoke-VultrAPI -HTTPMethod GET -APIGroup 'dns' -APIFunction 'list' -VultrAPIKey (Get-Content -Path D:\dev\powershell\PSVultrAPI\Examples\vultr_api_key.txt)

Invoke-VultrAPI -HTTPMethod GET -APIGroup 'dns' -APIFunction 'records' -RequestBody @{domain = 'salyercreative.com'} -VultrAPIKey (Get-Content -Path D:\dev\powershell\PSVultrAPI\Examples\vultr_api_key.txt)

