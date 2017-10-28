function Protect-VultrAPIKey {
<#
	TODO document
#>
	[CmdletBinding()]
	param(
		[parameter( Position = 0, Mandatory=$true, ValueFromPipeline=$true )]
		[alias("Key","APIKey")]
        [string[]]$VultrAPIKey,

		[parameter( Position = 1, Mandatory=$true )]
		[ValidateScript({Test-Path $_ -PathType Container})] 
        [string[]]$Path
	)
	begin {}
	process{
		# TODO: Better way of storing API key securely?
		#	Current recommendation is to use NTFS Access Control Lists on the API key file
		#	see: https://technet.microsoft.com/en-us/library/cc976803.aspx

		#$credential = Get-Credential;
		#$credential | Export-CliXml -Path (Join-Path $Path "\pword_${env:USERNAME}_${env:COMPUTERNAME}.xml");

		## Generate a random AES Encryption Key.
		#$AESKeyFilePath = Join-Path $Path "\PSVultrAPI_${env:USERNAME}_${env:COMPUTERNAME}.key"
		#$AESKey = New-Object Byte[] 32;
		#[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($AESKey);
	
		## Store the AESKey into a file. This file should be protected!  (e.g. ACL on the file to allow only select people to read)
		#Set-Content $AESKeyFilePath $AESKey   # Any existing AES Key file will be overwritten		

		#$key = $passwordSecureString | ConvertFrom-SecureString 
		#Add-Content $Path $Key

		$VultrAPIKey | ConvertTo-SecureString -AsPlainText -Force | Export-CliXml -Path (Join-Path $Path "\PSVultrAPI_${env:USERNAME}_${env:COMPUTERNAME}.xml")
	}
	end{}
}

