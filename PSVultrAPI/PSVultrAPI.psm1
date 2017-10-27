Write-Verbose "Importing Functions"

# Import everything in these folders
foreach($folder in @('Private', 'Public', 'Classes'))
{
    
    $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
    if(Test-Path -Path $root)
    {
        Write-Verbose "processing folder $root"
        $files = Get-ChildItem -Path $root -Filter *.ps1

        # dot source each file
        $files | where-Object{ $_.name -NotLike '*.Tests.ps1'} | 
            ForEach-Object{Write-Verbose $_.name; . $_.FullName}
    }
}

Export-ModuleMember -function (Get-ChildItem -Path "$PSScriptRoot\public\*.ps1").basename

# The below from PSStackExchange didn't work for me...
##Get public and private function definition files.
#    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
#    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

##Dot source the files
#    Foreach($import in @($Public + $Private))
#    {
#        Try
#        {
#            . $import.fullname
#        }
#        Catch
#        {
#            Write-Error -Message "Failed to import function $($import.fullname): $_"
#        }
#    }

## Here I might...
#    # Read in or create an initial config file and variable
#    # Export Public functions ($Public.BaseName) for WIP modules
#    # Set variables visible to the module and its functions only

#Export-ModuleMember -Function $Public.Basename