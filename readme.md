# Powershell Snippets

## Process clipboard selection

Need to copy lots of items from one place to another but the format isn't quite right? You can modify the clipboard selection on-the-fly!

```Powershell
function Process-Clipboard {
    $prev = $null;
    while ($true) {
        $cb = Get-Clipboard 
        if ($prev -ne $cb) {
            #Do processing here

            $prev = $cb
            Write-Host "Clipboard: '$cb'"
        }
        sleep 1
        Write-Host "." -NoNewLine
    }
}
```