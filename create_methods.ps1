
$path = "$PSScriptRoot\vultr_api_list.txt"
$reader = [System.IO.File]::OpenText($path)

while($null -ne ($line = $reader.ReadLine())) { 
	$line -match '/v1/(?<group>\w+)/(?<func>\w+)'
	
	$group = (Get-Culture).textinfo.totitlecase( $Matches.group )
	$func = (Get-Culture).textinfo.totitlecase( $Matches.func)
	$fileName = "Invoke-Vultr$group$func.ps1"
	
	#Write-Output $fileName

	New-Item -ItemType File -Force -Path ".\PSVultrAPI\Public\$group\$fileName" -Value "# TODO: $fileName"
}