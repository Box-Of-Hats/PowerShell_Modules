# Script to add a directory containing a .psm1 file to the Powershell modules directory

Param(
    # The directory containing the .psm1 file you want to install
    [Parameter(Mandatory = $true)]
    [string]
    $ModuleDirectory
)

$modulesDir = $ENV:PSModulePath.Split(";")[0]

if ($false -eq (Test-Path $ModuleDirectory)) {
    Write-Host "Could not find path: $ModuleDirectory" -ForegroundColor Red
    return
}

if ((Get-ChildItem $ModuleDirectory\*psm1).Count -lt 1) {
    Write-Host "Could not find .psm1 file inside of directory: $ModuleDirectory" -ForegroundColor Red
    return
}

if ($false -eq (Test-Path $modulesDir)) {
    Write-Host "Could not find path: $modulesDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $modulesDir -Confirm
    if ($false -eq (Test-Path $modulesDir)) {
        Write-Host "Could not find path: $modulesDir" -ForegroundColor Red
        return
    }
}

Write-Host "Found Powershell modules directory: '$modulesDir'"

Copy-Item $ModuleDirectory $modulesDir -Recurse -Force

Write-Host "Installed module:" ((Get-ChildItem $ModuleDirectory\*.psm1) | Select-Object -ExpandProperty Name | Split-Path -Leaf) -ForegroundColor Green

Write-Host "Added commands:"
$exportedCommands = ((Get-Content (Get-ChildItem $ModuleDirectory\*.psm1)) -match "^Export-ModuleMember[\s]+(.*)$")
foreach ($command in $exportedCommands) {
    Write-Host " " ($command -replace "Export-ModuleMember", "").TrimStart()
}
