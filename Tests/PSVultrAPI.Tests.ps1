$Verbose = @{}
if($env:APPVEYOR_REPO_BRANCH -and $env:APPVEYOR_REPO_BRANCH -notlike "master")
{
    $Verbose.add("Verbose",$True)
}

$PSVersion = $PSVersionTable.PSVersion.Major
Import-Module $PSScriptRoot\..\PSVultrAPI -Force -Verbose | Write-Output

#Integration test example
Describe "Vultr-APIBuilt PS$PSVersion Integrations tests" {

    Context 'Strict mode' { 

        Set-StrictMode -Version latest

        It 'should get valid data' {
            $Output = Vultr-APIBuilt
            $Output -contains 'It Works!'
        }
    }
}

# #Unit test example
# Describe "Get-SEObject PS$PSVersion Unit tests" {

    # Mock -ModuleName PSStackExchange -CommandName Get-SEData { $Args }
    # Context 'Strict mode' {

        # Set-StrictMode -Version latest

        # It 'should call Get-SEData' {
            # $Output = Get-SEObject -Object sites
            # Assert-MockCalled -CommandName Get-SEData -Scope It -ModuleName PSStackExchange
        # }

        # It 'should pass the right arguments to Get-SEData' {
            # $Output = Get-SEObject -Object sites
            
            # # Verify Maxresults
            # $Output[3] | Should Be ([int]::MaxValue)

            # # Verify IRMParams
            # # Hard coding this expected value is delicate, will break if default URI or Version parameter values change
            # $Output[1].Uri | Should Be 'https://api.stackexchange.com/2.2/sites'

            # $Output[1].Body.Pagesize | Should Be 30
        # }

    # }
# }