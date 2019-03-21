function Process-Clipboard {
    $prev = $null;
    while ($true) {
        $clipBoard = Get-Clipboard
        if ($prev -ne $clipBoard) {
            ## Do processing here ##

            # e.g
            # $clipBoard = "My name is $clipBoard"

            ########################
            Set-Clipboard $clipBoard
            $prev = $clipBoard
        }
        sleep 1
        Write-Host "$clipBoard"
    }
}