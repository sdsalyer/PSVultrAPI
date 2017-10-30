function Invoke-VultrOsList {
<#
	.Synopsis
		Gets OS List.
		
	.Description
		Retrieve a list of available operating systems from the Vultr API.
		If the "windows" flag is true, a Windows license will be included with the instance, which will increase the cost.

	.Example
		Invoke-VultrOsList

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

	.Outputs
		PSObject is returned, representing the JSON response body from the API. This can be piped to ConvertTo-Json
	
	.Notes
		Path:				/v1/os/list
		API Key Required:	No
		Request Type:		GET
#>
    [cmdletbinding()]
    param( )
    
	begin { }
	
	process {
	
		try {
			Invoke-VultrAPI -HTTPMethod GET -APIGroup 'os' -APIFunction 'list'
		}
		catch {
			throw
		}
		finally {
		
		}
		
	}

	end { }
}