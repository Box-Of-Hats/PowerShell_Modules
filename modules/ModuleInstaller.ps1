# Script to add a directory containing a .psm1 file to the Powershell modules directory

#region Params

Param(
    # The directory containing the .psm1 file you want to install
    [Parameter(Mandatory = $false)]
    [string]
    $ModuleDirectory = $false,
    # Switch, used to indicate that all modules should be installed
    [Parameter(Mandatory = $false)]
    [switch]
    $InstallAllModules
)

#endregion

#region Functions

function Install-ModuleFromDirectory {
    param(
        $ModuleDirectory,
        $ModulesDirectory = $false
    )
    if ($false -eq (Test-Path $ModuleDirectory)) {
        Write-Host "Could not find path: $ModuleDirectory" -ForegroundColor Red
        return
    }
    
    if ((Get-ChildItem $ModuleDirectory\*psm1).Count -lt 1) {
        Write-Host "Could not find .psm1 file inside of directory: $ModuleDirectory" -ForegroundColor Red
        return
    }
    
    if ($false -eq (Test-Path $ModulesDirectory)) {
        Write-Host "Could not find path: $ModulesDirectory" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $ModulesDirectory -Confirm
        if ($false -eq (Test-Path $ModulesDirectory)) {
            Write-Host "Could not find path: $ModulesDirectory" -ForegroundColor Red
            return
        }
        Write-Host "Found Powershell modules directory: '$ModulesDirectory'"
    }
    
    
    Copy-Item $ModuleDirectory $ModulesDirectory -Recurse -Force -Exclude "*.user.*"
    
    Write-Host "Installed module:" ((Get-ChildItem $ModuleDirectory\*.psm1) | Select-Object -ExpandProperty Name | Split-Path -Leaf) -ForegroundColor Green
    
    Write-Host "Added commands:" -ForegroundColor Green
    $exportedCommands = ((Get-Content (Get-ChildItem $ModuleDirectory\*.psm1)) -match "^Export-ModuleMember[\s]+(.+-.+)$")
    foreach ($command in $exportedCommands) {
        Write-Host " " ($command -replace "Export-ModuleMember", "").TrimStart() -ForegroundColor Cyan
    }
}

#endregion

#region Execution

$modulesDir = $ENV:PSModulePath.Split(";")[0]

Write-Host "Installing to Modules directory: '$modulesDir'"

if ($ModuleDirectory -eq $false -and -not $InstallAllModules) {
    Write-Host "Specify a module to install." -ForegroundColor Red
    Write-Host "Otherwise, use flag '-InstallAllModules' to install all modules." -ForegroundColor Red
    Write-Host "> .\ModuleInstaller.ps1 -InstallAllModules" -ForegroundColor Red
    return
}

if ($ModuleDirectory -eq $false -and $InstallAllModules) {
    Write-Host "Installing all modules..."
    Get-ChildItem | Where-Object PsIsContainer | ForEach-Object { Install-ModuleFromDirectory -ModuleDirectory $_ -ModulesDirectory $modulesDir }
    return
}


Install-ModuleFromDirectory -ModuleDirectory $ModuleDirectory -ModulesDirectory $modulesDir

#endregion
