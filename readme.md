# Powershell Snippets

## Process clipboard selection

Need to copy lots of items from one place to another but the format isn't quite right? You can modify the clipboard selection on-the-fly!

```Powershell
function Process-Clipboard {
    while ($true) {
        $cb = Get-Clipboard 
        if ($prev -ne $cb) {
            #Do processing here
            #($cb.Replace("[", "").Replace("]", "")) | Set-Clipboard
            $prev = $cb
        }
        sleep 1
        write-host "'$cb'"
    }
}
```