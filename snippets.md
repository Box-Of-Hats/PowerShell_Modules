# Snippets


## Get all colors in a directory

```powershell
$directory = "."

Get-ChildItem -Recurse  |
    Where-Object { $_.FullName -notlike "*\node_modules\*" } |
    Get-Content -ErrorAction SilentlyContinue |
    Select-String -Pattern "(#[0-9a-fA-F]{6})" |
    Select-Object -ExpandProperty Matches |
    Select-Object Value
```


## Process clipboard selection

Need to copy lots of items from one place to another but the format isn't quite right? You can modify the clipboard selection on-the-fly!

```powershell

function Process-Clipboard {
    $prev = $null;
    while ($true) {
        $clipBoard = Get-Clipboard
        if ($prev -ne $clipBoard) {
            ### Do processing here ##

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
```
