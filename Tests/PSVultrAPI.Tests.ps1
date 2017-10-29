$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force


<#
Some things to try:

	GET request with no arguments. 
		curl "https://api.vultr.com/v1/os/list"

	GET request that requires your API key. 
		curl -H 'API-Key: YOURKEY' "https://api.vultr.com/v1/server/list"

	GET request with additional parameters. 
		curl -H 'API-Key: YOURKEY' -G --data "SUBID=12345" "https://api.vultr.com/v1/server/list"

	POST request that requires your API key. 
		curl -H 'API-Key: YOURKEY' --data "SUBID=12345" "https://api.vultr.com/v1/server/start"

	POST request with additional parameters.
		curl -H 'API-Key: YOURKEY' --data "SUBID=12345" --data-urlencode 'label=my server!' "https://api.vultr.com/v1/server/label_set"


	/v1/dns/records (?domain=example.com)
	/v1/dns/list

#>
#describe "$moduleName basic GET requests" {

#	it  "Method: GET, Group: OS, Function: List" {

#		Invoke-VultrAPI -HTTPMethod GET -APIGroup 'os' -APIFunction 'list' | should be 'TODO: an array ? JSON? a Reponse object?'

#	}

#	it "Method: GET, Group: DNS, Function: List" {

#	}


#}