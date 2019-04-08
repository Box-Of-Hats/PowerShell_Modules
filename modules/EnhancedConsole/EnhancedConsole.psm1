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

function Get-ChildItemGridView {
    $children = Get-ChildItem | Select-Object -ExpandProperty Name

    $maxColCount = 3
    $colCount = 0
    foreach ($item in $children) {
        $colCount++

        
        if ($item.Length -ge 36) {
            $item = $item.SubString(0, 35) + "…"
        }

        Write-Host $item -NoNewline
        
        $spacesRequired = 40 - $item.Length
        
        if ($colCount -ge $maxColCount) {
            Write-Host ""
            $colCount = 0
        }
        else {
            for ($i = 0; $i -lt $spacesRequired; $i++) {
                Write-Host " " -NoNewline
            }
        }
    }
    Write-Host ""
}

#Alias
New-Alias -Name cdl -Value Set-LocationAndGetChildItem
New-Alias -Name cl -Value Copy-Location
New-Alias -Name lsl -Value Get-ChildItemGridView
#Exports
Export-ModuleMember -Alias *

Export-ModuleMember Copy-Location
Export-ModuleMember Set-LocationAndGetChildItem
Export-ModuleMember Get-ChildItemGridView