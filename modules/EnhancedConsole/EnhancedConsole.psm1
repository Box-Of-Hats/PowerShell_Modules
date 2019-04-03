<#
.DESCRIPTION
Copy the current location in the terminal.

.EXAMPLE
>Copy-Location
>>> E:\dev\test\
#>
function Copy-Location {
    $currentLocation = Get-Location | Select-Object -ExpandProperty Path
    Write-Host "Copied to clipboard: $currentLocation" -ForegroundColor Green
    $currentLocation | clip.exe
    return $currentLocation
}


<#
.DESCRIPTION
Change directory and list the contents similtaniously

.PARAMETER Location
The location to move to.
#>
function Set-LocationAndGetChildItem {
    param(
        [Parameter(Mandatory = $true)][string]$Location
    )
    Set-Location $Location
    Get-ChildItem
}

#Alias
New-Alias -Name cdl -Value Set-LocationAndGetChildItem
New-Alias -Name cl -Value Copy-Location

#Exports
Export-ModuleMember -Alias *

Export-ModuleMember Copy-Location
Export-ModuleMember Set-LocationAndGetChildItem