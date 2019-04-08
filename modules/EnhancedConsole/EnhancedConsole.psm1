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

<#
.DESCRIPTION
Output files in the current directory, similar to "ls" command on linux.
#>
function Get-ChildItemGridView {
    Param(
        [Parameter(Mandatory = $false)]$Directory = $false
    )
    if (-not $Directory) {
        $Directory = "."
    }
    $children = Get-ChildItem $Directory

    $maxColCount = 3
    $colCount = 0
    foreach ($item in $children) {
        $colCount++

        $fileName = $item | Select-Object -ExpandProperty Name

        #Determine what colour to display the name in
        if ($fileName.EndsWith(".ps1")) {
            $color = "Blue"
        } elseif (Test-Path $item -PathType Container){
            $color = "Gray"
        } elseif ($item.IsReadOnly){
            $color = "DarkGray"
        } else {
            $color = "White"
        }

        #Truncate the filename if necessary
        if ($fileName.Length -ge 36) {
            $fileName = $fileName.SubString(0, 35) + "…"
        }

        #Output the name
        Write-Host $fileName -NoNewline -ForegroundColor $color
        
        #Add whitespace or a newline char
        $spacesRequired = 40 - $fileName.Length
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