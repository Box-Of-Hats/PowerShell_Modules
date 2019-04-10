function Process-Clipboard {
    $prev = $null;
    while ($true) {
        $clipBoard = Get-Clipboard
        if ($prev -ne $clipBoard) {
            ## Do processing here ##

            # e.g
            # $clipBoard = $clipBoard.Replace(" , ", " ; ")

            ########################
            Set-Clipboard $clipBoard
            $prev = $clipBoard
        }
        Start-Sleep 1
        Write-Host "$clipBoard"
    }
}