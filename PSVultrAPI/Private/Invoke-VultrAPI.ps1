function Invoke-VultrAPI {
<#
    .Synopsis
        Invoke the Vultr API

    .Description

    .Parameter $HTTPMethod

    .Parameter $APIGroup

    .Parameter $APIFunction

    .Parameter $VultrAPIKey
        
    .Parameter $RequestBody

    .Parameter $Uri
    
    .Parameter $Version 

    .Outputs
        PsObject - A custom PsObject with a StatusCode and a JSON object.

    .Example 
        # GET request with no arguments.
        # curl "https://api.vultr.com/v1/os/list"
        Invoke-VultrAPI -HTTPMethod GET -APIGroup 'os' -APIFunction 'list'

    .Example
        # GET request that requires your API key.
        # curl -H 'API-Key: YOURKEY' "https://api.vultr.com/v1/server/list"
        Invoke-VultrAPI -HTTPMethod GET -APIGroup 'server' -APIFunction 'list' -VultrAPIKey YOURKEY

    .Example
        # GET request with additional parameters.
        # curl -H 'API-Key: YOURKEY' -G --data "SUBID=12345" "https://api.vultr.com/v1/server/list"
        Invoke-VultrAPI -HTTPMethod GET -APIGroup 'server' -APIFunction 'list' -RequestBody @{SUBID = 12345} -VultrAPIKey YOURKEY

    .Example
        # POST request that requires your API key.
        # curl -H 'API-Key: YOURKEY' --data "SUBID=12345" "https://api.vultr.com/v1/server/start"
        Invoke-VultrAPI -HTTPMethod POST -APIGroup 'server' -APIFunction 'start' -RequestBody @{SUBID = 12345} -VultrAPIKey YOURKEY

    .Example
        # POST request with additional parameters.
        # curl -H 'API-Key: YOURKEY' --data "SUBID=12345" --data-urlencode 'label=my server!' "https://api.vultr.com/v1/server/label_set"        
        Invoke-VultrAPI -HTTPMethod POST -APIGroup 'server' -APIFunction 'label_set' -RequestBody @{SUBID = 12345, label = 'my server!'} -VultrAPIKey (Get-Content -Path ..\Path\To\vultr_api_key.txt)
 
    .Example
        # Extended example
        $key = Get-Content 'c:\path\to\api_key.txt'
        $group = 'dns'
        $getRecordFn = 'records'
        $updtRecrodFn = 'update_record'
        $myDomain = 'example.com'
        $myIpAddress = '0.0.0.0'

        $recordId = (Invoke-VultrAPI -HTTPMethod GET -APIGroup $group -APIFunction $getRecordFn -RequestBody @{ domain = $myDomain } -VultrAPIKey $key
            | ConvertTo-Json ).RECORDID

        $updtParams = @{
           domain = $myDomain,
           RECORDID = $recordId,
           data = $myIp
        }

        Invoke-VultrAPI -HTTPMethod POST -APIGroup $group -APIFunction $updtRecordFn -RequestBody $updtParams -VultrAPIKey $key
#>
    [CmdletBinding()]
    [OutputType([PsObject])]
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

        [alias('Parameters', 'Params', 'Body')]
        [Hashtable]$RequestBody = @{},

        [string]$Uri = 'https://api.vultr.com',

        [string]$Version = '1'
    )
    begin {}
    process{
		# Set up the response object
		$VultrResponse = New-Object -TypeName PsObject -Property @{ 
			StatusCode = [int]$null
			Message    = [string]$null
			Content    = [PsObject]$null
		} | Add-Member -MemberType ScriptMethod -Name ToString -Value {
			$(If ($this.Content) {$this.Content} Else {$this.StatusCode})
		} -PassThru -Force

        # An error message if we need it
        $errorMessage = ''
		$errorStatus = 0

        # Begin assembling the request URI
        $APIRequestUri = "$Uri/v$Version/$APIGroup/$APIFunction"

        # Not all API functions require a key
        if($VultrAPIKey) {
            $headers = New-Object -TypeName System.Collections.Generic.Dictionary[[String],[String]]
            $headers.Add("API-Key", $VultrAPIKey)
        }

        # Potentially handle other REST methods
        switch ($HTTPMethod) { 
            'GET' {
				# GET processing
            } 
            'POST' {
				# POST processing

            } 
            default {
                $errorMessage = handleStatusCode($errorStatus)
                
				Write-Error "PSVultrAPI Error: $errorMessage"
				
				$VultrResponse.StatusCode = $errorStatus
				$VultrResponse.Message = $errorMessage
            }
        }

        
        # Invoke the API
        try {
			$response = Invoke-WebRequest -Method $HTTPMethod -Uri $APIRequestUri -Header $headers -Body $RequestBody
			
			$VultrResponse.StatusCode = $response.StatusCode
			$VultrResponse.Message = handleStatusCode($response.StatusCode)
			$VultrResponse.Content = $response.Content
        }
        catch [System.Net.WebException]{
			$errorStatus = [int]$_.Exception.Response.StatusCode
			$errorMessage = handleStatusCode($errorStatus)
            
			Write-Error "PSVultrAPI Error: $errorMessage"
			
			$VultrResponse.StatusCode = $errorStatus
			$VultrResponse.Message = $errorMessage
        }
		finally {
			$VultrResponse
		}
    }
    end{}
}


# Get the Vultr message for the Response status code
function script:handleStatusCode ($statusCode) {
	[string]$message = ''

    switch ($statusCode) {
		      0 {$message = 'No HTTP Method determined.'																     }
            200 {$message = 'Function successfully executed.'																 }
            400 {$message = 'Invalid API location. Check the URL that you are using.'										 }
            403 {$message = 'Invalid or missing API key. Check that your API key is present and matches your assigned key.'	 }
            405 {$message = 'Invalid HTTP method. Check that the method (POST|GET) matches what the documentation indicates.'}
            412 {$message = 'Request failed. Check the response body for a more detailed description.'						 }
            500 {$message = 'Internal server error. Try again at a later time.'												 }
            503 {$message = 'Rate limit hit. API requests are limited to an average of 2/s. Try your request again later.'	 }
		default {$message = 'An unhandled error occurred.'; $statusCode = -1;                                                }
    }

	[string]::Format("[{0}] {1}", $statusCode, $message)
}