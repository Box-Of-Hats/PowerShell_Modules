[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)][string]$VsCodeThemeJson,
    [Parameter(Mandatory = $true)][string]$ThemeName
)

if (-not (Test-Path $VsCodeThemeJson)) {
    Write-Error "Could not find file at path: $VsCodeThemeJson"
    return
}

$fileFormat = (Get-Item $VsCodeThemeJson).Extension
if ($fileFormat -ne ".json") {
    Write-Error "Input file was not in JSON format. Found format: $fileFormat"
    return
}

$content = [string]::Join("`n", (Get-Content $VsCodeThemeJson | Where-Object { $_ -NotLike "*//*" } )) -replace ",\s+}", "}" | ConvertFrom-Json

$background = $content.colors.'editor.background'[0..6] -join "";
$foreground = $content.colors.'editor.foreground'[0..6] -join "";

$purple = $content.colors.'terminal.ansiMagenta'[0..6] -join "";
$brightPurple = $content.colors.'terminal.ansiBrightMagenta'[0..6] -join "";

$black = $content.colors.'terminal.ansiBlack'[0..6] -join "";
$brightBlack = $content.colors.'terminal.ansiBrightBlack'[0..6] -join "";

$green = $content.colors.'terminal.ansiGreen'[0..6] -join "";
$brightGreen = $content.colors.'terminal.ansiBrightGreen'[0..6] -join "";

$white = $content.colors.'terminal.ansiWhite'[0..6] -join "";
$brightWhite = $content.colors.'terminal.ansiBrightWhite'[0..6] -join "";

$blue = $content.colors.'terminal.ansiBlue'[0..6] -join "";
$brightBlue = $content.colors.'terminal.ansiBrightBlue'[0..6] -join "";

$cyan = $content.colors.'terminal.ansiCyan'[0..6] -join "";
$brightCyan = $content.colors.'terminal.ansiBrightCyan'[0..6] -join "";

$red = $content.colors.'terminal.ansiRed'[0..6] -join "";
$brightRed = $content.colors.'terminal.ansiBrightRed'[0..6] -join "";

$yellow = $content.colors.'terminal.ansiYellow'[0..6] -join "";
$brightYellow = $content.colors.'terminal.ansiBrightYellow'[0..6] -join "";

$selectionBackground = $content.colors.'editor.selectionHighlightBackground'[0..6] -join "";

return $template = @"
{
    "name": "$ThemeName",

    "background": "$background",
    "foreground": "$foreground",
    "selectionBackground": "$selectionBackground",

    "purple": "$purple",
    "brightPurple": "$brightPurple",
    "black": "$black",
    "brightBlack": "$brightBlack",
    "green": "$green",
    "brightGreen": "$brightGreen",
    "white": "$white",
    "brightWhite": "$brightWhite",
    "blue": "$blue",
    "brightBlue": "$brightBlue",
    "cyan": "$cyan",
    "brightCyan": "$brightCyan",
    "brightRed": "$brightRed",
    "red": "$red",
    "brightYellow": "$brightYellow",
    "yellow": "$yellow"
}
"@
