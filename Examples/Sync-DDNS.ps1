#Requires -Version 3.0 -Modules PSVultrAPI
function Sync-DDNS {
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
    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName =$true, ValueFromPipeline=$true )]
        [alias('Key','APIKey')]
        [string]$VultrAPIKey,

        [parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('Domain')]
        [string]$DomainName,

        [parameter(Position=2, Mandatory=$true, ValueFromPipelineByPropertyName =$true )]
        [alias('Name')]
        [string]$SubDomain
    )
    begin {
        Write-Log "START: ==========================="
    }
    process{
        # IP Checking
        $ipFile = 'last_ip.json'
        $myIp = Get-WANIP
        $myLastIp = ''
        
        # Read the json file and set the last known IP
        if (Test-Path $ipFile) {
            $myLastIpJSON = Get-Content -Raw $ipFile | ConvertFrom-Json
            $myLastIp = $myLastIpJSON.ip_addr
        }

        # Log the current and previous IP
        Write-Log "Last IP   : $myLastIp"
        Write-Log "Current IP: $myIp"

        # Exit if no change. Otherwise, write the IP to file.
        if($myLastIp -eq $myIp) {
            exit
        }
        Write-Output @{ ip_addr = $myIp } | ConvertTo-JSON | Out-File $ipFile -Force

        # Set up the API call
        $parameters = @{
            VultrApIKey = $VultrAPIKey
            DomainName = $DomainName
			#TODO: This isn't right :(
            RecordId = (Get-VultrDnsRecords $VultrAPIKey $DomainName | Where-Object -Property Content -EQ $SubDomain).RECORDID
            SubDomain = $SubDomain
            RecordData = $myIp
        }
        $response = Update-VultrDnsRecord @Parameters

        Write-Log "Response:`n`t$(Out-String -InputObject $response)"

        if($resopnse) {
            Write-Log "Successfully updated DNS Record."
        }
        else {
            Write-Log "ERROR updating DNS Record."
        }

    }
    end{
        Write-Log "END: ============================="
    }
}

function script:Get-TimeStamp {
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

    "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

function script:Get-WANIP {
<#
.SYNOPSIS
Gets the current WAN IP address.

.DESCRIPTION
Gets the current WAN IP address by querying the ifconfig.me website.

.OUTPUTS
The current IP address of the machine.

.EXAMPLE
Get-WANIP
123.12.12.123
#>

    $myIpJSON = (Invoke-WebRequest ifconfig.me/all.json).Content | ConvertFrom-Json
    $myIpJSON.ip_addr
}

function script:Write-Log([string] $line, [string]$logFile = 'ddns.log') {
     Write-Output "[$(Get-TimeStamp)$line]" | Out-File $logFile -Append -Force
}
