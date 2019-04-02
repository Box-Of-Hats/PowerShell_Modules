<#
.DESCRIPTION
    Requires: Inkscape

#>



<#
.DESCRIPTION
    Retrieve the json configuration file, in order of preference.
.OUTPUTS
    Path of the config file to use
#>
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


function ConvertToPng {
    Param(
        [string] $InputPath = '.',
        [string] $OutputPath = $null
    )
    if ([string]::IsNullOrWhiteSpace($OutputPath)) {
        $targetName = $InputPath -replace ".svg", ".png";  
    }
    else {
        $targetName = $OutputPath
    }

    $InputPath = Resolve-Path $InputPath

    Write-Output "Converting $InputPath => $targetName" 
    
    $argumentList = "-z `"$InputPath`" -e `"$targetName`""

    Write-Host "Converting $InputPath => $targetName" -ForegroundColor Green
    Start-Process "`"$InkscapeLocation`"" -ArgumentList $argumentList

    return $targetName
}

<#
.DESCRIPTION
    Convert an image from SVG format to PNG.
.INPUT
    Can take either a file path or a directory.
#>
function Convert-SvgToPng {
    param( 
        [string] $InputPath = '.',
        [string] $OutputPath = $null,
        [string] $ConfigFile = $null
    ) 

    if ([string]::IsNullOrEmpty($ConfigFile)) {
        $configFile = Get-ConfigFile
    }

    if (-not $configFile) {
        Write-Host "Could not find config." -ForegroundColor Red
        return
    }

    $InkscapeLocation = (Get-Content $configFile | ConvertFrom-Json).InkscapeLocation

    if ($null -eq $InkscapeLocation -or -not (Test-Path $InkscapeLocation)) {
        Write-Host "Could not find Inkscape at: $InkscapeLocation" -ForegroundColor Red
        return
    }

    if (Test-Path $InputPath -PathType Container) {
        Get-ChildItem $InputPath | Select-Object -ExpandProperty FullName | ForEach-Object { Convert-SvgToPng -InputPath $_ -OutputPath $null $_ -ConfigFile $ConfigFile }
    }


    if ([IO.Path]::GetExtension($InputPath) -eq ".svg" ) { 
        ConvertToPng $InputPath $OutputPath | Out-Null
    }
    
}

Export-ModuleMember Convert-SvgToPng