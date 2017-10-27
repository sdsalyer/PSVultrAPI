$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force

describe "$moduleName works" {

  it  "Vultr-APIBuilt is imported and invoked" {

  Vultr-APIBuilt | should be 'It Works!'

  }

}