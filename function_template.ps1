function Invoke-Vultr<group><function> {
<#
	.Synopsis
		Gets account info.
		
	.Description
		Retrieve information about the current account from the Vultr API.

	.Parameter $VultrAPIKey
		The Vultr API Key of the user.

	.Example
		Invoke-VultrAccountInfo

		# Example Output:
			{
				"127": {
					"OSID": "127",
					"name": "CentOS 6 x64",
					"arch": "x64",
					"family": "centos",
					"windows": false
				},
				"148": {
					"OSID": "148",
					"name": "Ubuntu 12.04 i386",
					"arch": "i386",
					"family": "ubuntu",
					"windows": false
				}
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
    param( )
    
	begin { }
	
	process {
	
		try {
			# Invoke-VultrAPI -HTTPMethod GET -APIGroup 'os' -APIFunction 'list'
		}
		catch {
			throw
		}
		finally {
		
		}
		
	}

	end { }
}