function Get-ConfigFile {
    $configPaths = (
        "$PSScriptRoot\\config.user.json",
        "$PSScriptRoot\\config.json"
    )
    if ([string]::IsNullOrEmpty($ConfigFile)) {
        foreach ($path in $configPaths) {
            if (Test-Path -Path $path -PathType Leaf) {
                return $path
            }   
        }
    }
    
    Write-Host "Could not find a config file. Checked locations: "
    foreach ($path in $configPaths) {
        Write-Host $path
    }
    return $false
}

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
        [Parameter(Mandatory = $false)]$Directory = $false,
        [Parameter(Mandatory=$false)]$MaxColumnCount = $null,
        [Parameter(Mandatory=$false)]$ConfigFile = $null
    )
    if (-not $Directory) {
        $Directory = "."
    }
    
    if ([string]::IsNullOrEmpty($ConfigFile)) {
        $configFile = Get-ConfigFile
    }
    
    if (-not $configFile) {
        Write-Host "Could not find config." -ForegroundColor Red
        return
    }

    $config = (Get-Content $configFile | ConvertFrom-Json)
    $propColors = $config.prop_colors
    $extensionColors = $config.extension_colors
    $configMaxColumnCount = $config.column_count;

    if ($null -ne $configMaxColumnCount){
        $MaxColumnCount = $configMaxColumnCount
    }

    if ($null -eq $MaxColumnCount){
        $MaxColumnCount = 4
    }


    $maxColumnWidth = [math]::Min([math]::Floor($Host.UI.RawUI.WindowSize.Width / $MaxColumnCount), 40)

    $children = Get-ChildItem $Directory

    $colCount = 0
    foreach ($item in $children) {
        $colCount++

        $fileName = $item | Select-Object -ExpandProperty Name

        #Determine what colour to display the name in
        $color = $propColors.default
        
        $extension = $item.Extension
        if ($null -ne $extensionColors.$extension){
            $color = $extensionColors.$extension
        }
        
        if (Test-Path $item -PathType Container){
            $color = $propColors.is_container
        } elseif ($item.IsReadOnly){
            $color = $propColors.is_read_only
        }
        if ($color -notin @("Black", "DarkBlue", "DarkGreen", "DarkCyan", "DarkRed",
                                "DarkMagenta", "DarkYellow", "Gray", "DarkGray", "Blue",
                                "Green", "Cyan", "Red", "Magenta", "Yellow", "White")){
            $color = "White"
        }
        
        
        #Truncate the filename if necessary
        if ($fileName.Length -ge $maxColumnWidth) {
            $truncator = "..."
            $fileName = "$($fileName.SubString(0, $maxColumnWidth-$truncator.Length-$item.Extension.Length-1))$($truncator)$($item.Extension)"
        }

        #Output the name
        $fileName = $fileName.PadRight($maxColumnWidth, " ")
        Write-Host $fileName -NoNewline -ForegroundColor $color
        
        #Add whitespace or a newline char
        if ($colCount -ge $MaxColumnCount) {
            Write-Host ""
            $colCount = 0
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