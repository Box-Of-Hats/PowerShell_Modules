function Convert-SvgToPng {

    param( 
        [string]$path = '.', 
        [string]$exec = "`"C:\Program Files\Inkscape\inkscape.exe`""
    ) 
    

    
    foreach ($filename in Get-ChildItem $path) { 
        if ($filename.toString().EndsWith('.svg')) { 
            
            $targetName = $filename.BaseName + ".png";  
            Write-Output "Converting $filename ..." 
            
            $argumentList = "-z `"$filename`" -e `"$targetName`""

            Start-Process $exec -ArgumentList $argumentList
        } 
    } 
}

Export-ModuleMember Convert-SvgToPng