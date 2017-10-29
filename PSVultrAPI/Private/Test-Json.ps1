#
# Test-Json.ps1
#
try {
    $powershellRepresentation = ConvertFrom-Json $text -ErrorAction Stop;
    $validJson = $true;
} catch {
    $validJson = $false;
}

if ($validJson) {
    Write-Host "Provided text has been correctly parsed to JSON";
} else {
    Write-Host "Provided text is not a valid JSON string";
}