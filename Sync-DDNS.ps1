#Requires -Version 3.0 -Modules PSVultrAPI
<#
.SYNOPSIS
A DDNS update client for the Vultr API.

.DESCRIPTION
Gets the current WAN IP and calls the Vultr API to update the A record.

.PARAMETER <param1 name>
.PARAMETER <param(n) name>
.INPUTS
.OUTPUTS
.EXAMPLE
.EXAMPLE
.LINK
#>
function Sync-DDNS {
	[CmdletBinding()]
	[OutputType([psobject])]
	param()
	begin {
		Write-Output "START: ===========================$(Get-TimeStamp)" | Out-File $logFile -Append -Force;
	}
	process{
		# IP Checking and logging setup
		# TODO: Make these input params?
		$logFile = 'enterprise_ddns.log';
		$ipFile = 'last_ip.json';
		$myIp = Get-WANIP;
		$myLastIp = '';
		
		# Read the json file and set the last known IP
		if (Test-Path $ipFile) {
			$myLastIpJSON = Get-Content -Raw $ipFile | ConvertFrom-Json;
			$myLastIp = $myLastIpJSON.ip_addr
		}

		# Log the current and previous IP
		Write-Output "$(Get-TimeStamp) Last IP: $myLastIp" | Out-File $logFile -Append -Force;
		Write-Output "$(Get-TimeStamp) Curr IP: $myIp" | Out-File $logFile -Append -Force;

		# Exit if no change.
		if($myLastIp -eq $myIp) {
			exit;
		}
		Write-Output @{ ip_addr = $myIp } | ConvertTo-JSON | Out-File $ipFile -Force

		
		# TODO: call the Vultr API here
		# POST Requests
		$apiCall = '/v1/dns/update_record';
		<# 
			domain string Domain name to update record
			RECORDID integer ID of record to update (see /dns/records)
			name string (optional) Name (subdomain) of record
			data string (optional) Data for this record
			ttl integer (optional) TTL of this record
			priority integer (optional) (only required for MX and SRV) Priority of this record (omit the priority from the data)
		#>

		# RECORDID in GET /v1/dns/records?domain=salyercreative.com
		$parameters = @{
		   domain = 'salyercreative.com';
		   RECORDID = '4900476';
		   data = $myIp;
		};
		$method = 'Post';
		$response = Invoke-VultrAPI -Method $method -Call $apiCall -Parameters $parameters

		Write-Output "$(Get-TimeStamp) Response:`n`t$(Out-String -InputObject $response)" | Out-File $logFile -Append -Force;

	}
	end{
		Write-Output "END: =============================$(Get-TimeStamp)" | Out-File $logFile -Append -Force;
	}
}

<#
.SYNOPSIS
Gets a formatted timestamp for logging.

.DESCRIPTION
Returns a formatted string with the date in MM/dd/yy formatted
and the time in HH:mm:ss format, created from the Get-Date cmdlet.

.EXAMPLE
Get-TimeStamp
[10/20/17 17:53:45]

Write-Output "$(Get-TimeStamp) Log this message" | Out-File $myLogFile -Append
This would write:
[10/20/17 17:53:45]  Log this message
to $myLogFile
#>
function script:Get-TimeStamp {
    "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date);
}