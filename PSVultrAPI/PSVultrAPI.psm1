Write-Verbose "Importing Functions"

# Import everything in these folders
foreach($folder in @('Private', 'Public', 'Classes'))
{
    
    $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
    if(Test-Path -Path $root)
    {
        Write-Verbose "processing folder $root"
        $files = Get-ChildItem -Path $root -Filter *.ps1 -Recurse

        # dot source each file
        $files | where-Object{ $_.name -NotLike '*.Tests.ps1'} | 
            ForEach-Object{Write-Verbose $_.name; . $_.FullName}
    }
}

Export-ModuleMember -function (Get-ChildItem -Path "$PSScriptRoot\Public\" -Filter *.ps1 -Recurse).basename