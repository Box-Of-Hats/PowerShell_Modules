function Expand-Cab {
    Param (
        [Parameter(Mandatory = $true)] [string] $CabFile,
        [Parameter(Mandatory = $true)] [string] $OutDirectory
    )
    mkdir $OutDirectory
    expand.exe $CabFile $OutDirectory -F:*
}

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