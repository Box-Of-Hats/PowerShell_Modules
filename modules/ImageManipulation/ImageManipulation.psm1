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
Take an image and scale it up or down by a given multiplier OR set the image to be a given dimension.
Set one dimension to scale the image while maintaining the same aspect ratio.
Then save it to a new file.

.EXAMPLE
Scale-Image -ImagePath .\4x4.png -OutImagePath .\8x8.png -ScaleFactor 2

Scale-Image -ImagePath .\4x4.png -OutImagePath .\1x1.png -ScaleFactor 0.25

Scale-Image -ImagePath .\4x4.png -OutImagePath .\16x16.png -Height 16

Scale-Image -ImagePath .\4x4.png -OutImagePath .\20x30.png -Height 30 -Width 20

#>
function Resize-Image {
    param (
        [Parameter(Mandatory = $true)][string]$ImagePath,
        [Parameter(Mandatory = $false)][float]$ScaleFactor = 0,
        [Parameter(Mandatory = $false)][string]$OutImagePath = $null,
        [Parameter(Mandatory = $false)][int]$Height = 0,
        [Parameter(Mandatory = $false)][int]$Width = 0
    )
    
    if (-not (Test-Path $ImagePath)) {
        Write-Host "Could not find file: $ImagePath" -ForegroundColor Red
        return $null
    }

    $ImagePath = Resolve-Path $ImagePath

    if ([string]::IsNullOrWhiteSpace($OutImagePath)) {
        $item = Get-ChildItem $ImagePath
        Write-Host "item $item"
        $currentTime = [datetime]::Now.Ticks
        $OutImagePath = $item.BaseName + "_scaled_$currentTime" + $item.Extension
    }
    
    $OutImagePath = Join-Path (Get-Location) $OutImagePath

    if (Test-Path $OutImagePath) {
        Write-Host "File already exists: $OutImagePath" -ForegroundColor Red
        return $null
    }

    $image = New-Object -ComObject Wia.ImageFile
    $image.LoadFile($ImagePath)
    $imageProcess = New-Object -ComObject Wia.ImageProcess
    $imageProcess.Filters.Add($imageProcess.FilterInfos("Scale").FilterId)


    if ($ScaleFactor -ne 0) {
        #Increase size of image by a uniform multiplier
        Write-Host "Changing scale of image by $($ScaleFactor)x"
        $imageProcess.Filters[1].Properties("MaximumWidth").Value = "$([math]::Floor($image.Width * $ScaleFactor))"
        $imageProcess.Filters[1].Properties("MaximumHeight").Value = "$([math]::Floor($image.Height * $ScaleFactor))"
        $imageProcess.Filters[1].Properties("PreserveAspectRatio").Value = 1
    }
    else {
        #Scale the image to a specific size
        if ($Height -eq 0 -and $Width -eq 0) {
            Write-Host "Width and height not set" -ForegroundColor Red
            return $null
        }

        if ($Height -ne 0) {
            Write-Host "Setting Height to: $($Height)px"
            $imageProcess.Filters[1].Properties("MaximumHeight").Value = "$Height"
            $imageProcess.Filters[1].Properties("MaximumWidth").Value = "10000"
        }

        if ($Width -ne 0) {
            Write-Host "Setting Width to: $($Width)px"
            $imageProcess.Filters[1].Properties("MaximumWidth").Value = "$Width"
            $imageProcess.Filters[1].Properties("MaximumHeight").Value = "10000"
        }

        if ($Width -ne 0 -and $Height -ne 0) {
            $imageProcess.Filters[1].Properties("PreserveAspectRatio").Value = 0
        }
    }

    $scaledImage = $imageProcess.Apply($image)
    if ($null -eq $scaledImage) {
        Write-Host "Error processing image." -ForegroundColor Red
        return $null
    }
    $scaledImage.SaveFile($OutImagePath)
    Write-Host "Saved to: $OutImagePath"

}


function Convert-Image {
    param(
        [Parameter(Mandatory = $true)] [string] $ImagePath,
        [Parameter(Mandatory = $true)] [string] $OutputFile
    )

    if (@("jpeg", "jpg", "gif", "png", "tiff") -contains $OutputFile.Split(".")[$OutputFile.Split(".").Length - 1]) {
        # $image = New-Object -ComObject Wia.ImageFile
        # $image.LoadFile($ImagePath)

        # $imageProcess = New-Object -ComObject Wia.ImageProcess
        # $imageProcess.Filters.Add($imageProcess.FilterInfos("Convert").FilterId)

        # #$imageProcess.Filters[1].Properties("FormatId").Value = # Set image type here

        # $outImage = $imageProcess.Apply($image)
        # $outImage.SaveFile($OutputFile)
    }
    else {
        Write-Host "Unable to convert to file type: $($OutputFile.Split(".")[$OutputFile.Split(".").Length-1])" -ForegroundColor Red
        return $null
    }
}

Export-ModuleMember Convert-Image
Export-ModuleMember Resize-Image
Export-ModuleMember Convert-SvgToPng