function Invoke-VultrAPI {
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
	[OutputType([psobject])] # http response object ?
	param()
	begin {}
	process{
		#TODO: input parameters -- should apiKey be secured?
		$apiUrl = 'https://api.vultr.com';
		$apiKey = ''; #TODO: load from [encrypted] file?

		# Configure the headers
		$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]";
		$headers.Add("API-Key", $apiKey)

		# Parameterless GET requests
		#$apiCall = '/v1/account/info'; 
		#$apiCall = '/v1/dns/list';
		#$apiCall = '/v1/dns/records?domain=salyercreative.com';
		#$parameters = '';
		#$method = 'Get'; 

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

		$uri = "$apiUrl$apiCall";

		Write-Debug "Request:`n`tURI: $uri`n`tMethod: $method`n`tHeaders: $(Out-String -InputObject $headers)`n`tParameters: $(Out-String -InputObject $parameters)";

		if($method -eq 'Get') {
			#$response = Invoke-RestMethod -Method $method -Uri $uri -Header $headers;
			Write-Debug "Invoke-RestMethod -Method $method -Uri $uri -Header $headers";
		}
		elseif ($method -eq 'Post')  {
			#$response = Invoke-RestMethod -Method $method -Uri $uri -Header $headers -Body $parameters;
			Write-Debug "Invoke-RestMethod -Method $method -Uri $uri -Header $headers -Body $parameters";
		}
		else {
			# TODO: what to return here
			#$response = 'Invalid request method';
			Write-Debug "$response = 'Invalid request method'";
		}
		
		$response;
	}
	end{}
}