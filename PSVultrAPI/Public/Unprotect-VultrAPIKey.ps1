function Unprotect-VultrAPIKey {
<#
	TODO document
#>
	[CmdletBinding()]
	param(
		[parameter( Position = 0, Mandatory=$true, ValueFromPipeline=$true )]
		[ValidateScript({Test-Path $_ -PathType Container})] 
        [string[]]$Path
	)
	begin {}
	process{
		$VultrAPIKey = Import-CliXml -Path (Join-Path $Path "\PSVultrAPI_${env:USERNAME}_${env:COMPUTERNAME}.xml") | ConvertTo-SecureString
	}
	end{}
}

