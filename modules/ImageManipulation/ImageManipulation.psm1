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

<#
.SYNOPSIS
Scale an image.

.DESCRIPTION
Take an image and scale it up or down by a given multiplier. Then save it to a new file.

.PARAMETER ImagePath
The image that should be scaled.

.PARAMETER ScaleFactor
The multiplier to use for the new image size.

.PARAMETER OutImagePath
The path of the image file to be created.

.EXAMPLE
Scale-Image -ImagePath .\4x4.png -ScaleFactor 2 -OutImagePath .\8x8.png
#>
function Resize-Image {
    param (
        [Parameter(Mandatory=$true)]$ImagePath,
        [Parameter(Mandatory=$true)]$ScaleFactor,
        [Parameter(Mandatory=$false)]$OutImagePath = $null
    )
    
    if (-not (Test-Path $ImagePath)){
        Write-Host "Could not find file: $ImagePath" -ForegroundColor Red
        return $null
    }

    $ImagePath = Resolve-Path $ImagePath

    if ($null -eq $OutImagePath){
        $item = Get-ChildItem $ImagePath
        $OutImagePath = $item.BaseName + "_scaled$ScaleFactor" + $item.Extension
    }

    $OutImagePath = Join-Path (Get-Location) $OutImagePath

    if (Test-Path $OutImagePath){
        Write-Host "File already exists: $OutImagePath" -ForegroundColor Red
        return $null
    }

    $image = New-Object -ComObject Wia.ImageFile
    $image.LoadFile($ImagePath)

    $imageProcess = New-Object -ComObject Wia.ImageProcess
    $imageProcess.Filters.Add($imageProcess.FilterInfos("Scale").FilterId)

    $imageProcess.Filters[1].Properties("MaximumWidth").Value = "$([int]::parse($image.Width * $ScaleFactor))"
    $imageProcess.Filters[1].Properties("MaximumHeight").Value = "$([int]::parse($image.Height * $ScaleFactor))"
    $imageProcess.Filters[1].Properties("PreserveAspectRatio").Value = 1

    $scaledImage = $imageProcess.Apply($image)
    $scaledImage.SaveFile($OutImagePath)

}

Export-ModuleMember Resize-Image
Export-ModuleMember Convert-SvgToPng