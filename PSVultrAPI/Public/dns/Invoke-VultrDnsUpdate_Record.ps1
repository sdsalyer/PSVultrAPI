function Invoke-VultrDnsUpdate_Record {
<# 
	.PARAMETER $Domain 
		string Domain name to update record
	.PARAMETER $RecordId
		integer ID of record to update (see /dns/records)
	.PARAMETER $Name 
		string (optional) Name (subdomain) of record
	.PARAMETER $Data 
		string (optional) Data for this record
	.PARAMETER $Ttl 
		integer (optional) TTL of this record
	.PARAMETER $Priority 
		integer (optional) (only required for MX and SRV) Priority of this record (omit the priority from the data)
#>

  [CmdletBinding()]
    [OutputType([PSObject])]
    param(
        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('Key','APIKey')]
        [string]$VultrAPIKey,
		
        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [string]$Domain,

        [parameter( Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('ID')]
        [int]$RecordId,

		[string]$Name,
		
        [string]$Data,

        [string]$Ttl,

        [int]$Priority 
    )
    begin {}
    process{
		$params = @{
		
		}
		
		$response = Invoke-VultrAPI -HTTPMethod POST -APIGroup 'dns' -APIFunction 'update_record' -RequestBody $params -VultrAPIKey $VultrAPIKey
		
		($response | ConverTo-String) -eq 200
	}
	end {}
}