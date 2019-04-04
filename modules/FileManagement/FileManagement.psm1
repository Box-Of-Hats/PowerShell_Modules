
<#
.DESCRIPTION
Expand the contents of a .cab file into a directory;

.PARAMETER CabFile
The path of the existing .cab file.

.PARAMETER OutDirectory
The directory to output the files. This will be created if it doesn't exist.

.EXAMPLE
> Expand-Cab outDirectory.cab .\myDirectory 
#>

function Expand-Cab {
    Param (
        [Parameter(Mandatory = $true)] [string] $CabFile,
        [Parameter(Mandatory = $true)] [string] $OutDirectory
    )
    if (-not (Test-Path -Path $OutDirectory -PathType Container)){
        New-Item $OutDirectory -ItemType Directory
    }
    expand.exe $CabFile $OutDirectory -F:*
}

<#
.DESCRIPTION
Compress a directory into a .cab file.

.PARAMETER DirectoryToCompress
The directory to compress.

.PARAMETER OutCabFile
The path of the .cab file to be created.

.EXAMPLE
> Compress-ToCab .\myDirectory outDirectory.cab
#>

function Compress-ToCab {
    param(
        [Parameter(Mandatory = $true)] [string] $DirectoryToCompress,
        [Parameter(Mandatory = $true)] [string] $OutCabFile
    )
    $ddf = ".OPTION EXPLICIT
	.Set CabinetNameTemplate=$OutCabFile
	.Set DiskDirectory1=.
	.Set CompressionType=MSZIP
	.Set Cabinet=on
	.Set Compress=on
	.Set CabinetFileCountThreshold=0
	.Set FolderFileCountThreshold=0
	.Set FolderSizeThreshold=0
	.Set MaxCabinetSize=0
	.Set MaxDiskFileCount=0
	.Set MaxDiskSize=0
	"
    $dirfullname = (Get-Item $DirectoryToCompress).fullname
    $ddfpath = ($env:TEMP + "\temp.ddf")
    $ddf += (Get-ChildItem -recurse $DirectoryToCompress | Where-Object { !$_.PSIsContainer } | Select-Object -ExpandProperty FullName | ForEach-Object { '"' + $_ + '" "' + $_.SubString($dirfullname.length) + '"' }) -join "`r`n"
    $ddf
    $ddf | Out-File -Encoding UTF8 $ddfpath
    makecab.exe /F $ddfpath
    Remove-Item $ddfpath
    Remove-Item setup.inf
    Remove-Item setup.rpt
}

#Exports
Export-ModuleMember Compress-ToCab
Export-ModuleMember Expand-Cab