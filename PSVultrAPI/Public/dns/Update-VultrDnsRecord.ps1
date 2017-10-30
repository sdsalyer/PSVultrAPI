function Update-VultrDnsRecord {
<# 
    .Synopsis
        Updates DNS records for a domain.
        
    .Description
        Updates DNS record information for the specified domain in the Vultr API.

	.Parameter $DomainName
		string Domain name to update record

	.Parameter $RecordId
		integer ID of record to update (see /dns/records)

	.Parameter $SubDomain 
		string (optional) Name (subdomain) of record

	.Parameter $RecordData 
		string (optional) Data for this record

	.Parameter $TimeToLive
		integer (optional) TTL of this record

	.Parameter $Priority 
		integer (optional) (only required for MX and SRV) Priority of this record (omit the priority from the data)

   .Example
        Update-VultrDnsRecord -Key (Get-Content api_key.txt) -DomainName example.com -RecordId 123456 -Data 192.0.2.99

        # Example Output:
		$true or $false

    .Inputs
        String Vultr API key
		String Domain Name
		String DNS Record ID

    .Outputs
        Boolean value with True indicating success and False indicating failure.
    
	.Link
		Get-VultrDnsRecords

    .Notes
        Path:				/v1/dns/update_record
        API Key Required:	Yes
        Request Type:		POST
		Required Access:	dns
#>

    [cmdletbinding()]
    param(
        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true, ValueFromPipeline=$true )]
        [alias('Key','APIKey')]
        [string]$VultrAPIKey,
		
        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('Domain')]
        [string]$DomainName,

        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('Id', 'Record')]
        [int]$RecordId,

		[alias('Name')]
		[string]$SubDomain,
		
		[alias('Data')]
        [string]$RecordData,

		[alias('Ttl')]
        [string]$TimeToLive,

        [int]$Priority 
    )

    begin {}

    process{
		# Set up the output
		[bool]$result = $false;

		# TODO: How to supply optional parameters -- this way seems to overwrite with empty/default values...
		try {
			$params = @{
				#domain string Domain name to update record
				domain = $DomainName

				#RECORDID integer ID of record to update (see /dns/records)
				RECORDID = $RecordId

				#name string (optional) Name (subdomain) of record
				name = $SubDomain

				#data string (optional) Data for this record
				data = $RecordData

				#ttl integer (optional) TTL of this record
				ttl = $TimeToLive

				#priority integer (optional) (only required for MX and SRV) Priority of this record (omit the priority from the data
				priority = $Priority
			}
		
			$response = Set-Vultr 'dns' 'update_record' -VultrAPIKey $VultrAPIKey -RequestBody $params

			$result = ($response -eq '200')
        }
        catch {
            throw
        }
        finally {
			$result
        }
	}

	end {}
}