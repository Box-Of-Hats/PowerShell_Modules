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

## WorkspaceManager

Open a workspace on a new virtual desktop in Windows 10. Workspaces are defined in a config.json file located in the WorkspaceManager directory. If config.user.json is present then it will be used as a higher priority.

For example:

`~/Documents/WindowsPowershell/Modules/WorkspaceManager/config.json`
`~/Documents/WindowsPowershell/Modules/WorkspaceManager/config.user.json`

```json
{
    "workspaces": [
        {
            "name": "Relax",
            "websites": [
                "http://www.youtube.com",
                "http://www.facebook.com"
            ],
            "code": [],
            "visual_studio": [],
            "open_files": [
                "~/Games/StormTheHouse/storm.exe"
            ]
        },
        {
            "name": "Uni Work",
            "websites": [
                "http://www.wikipedia.org"
            ],
            "code": [],
            "visual_studio": [
                "~/source/repos/My_Project/"
            ],
            "open_files": [
                "~/Documents/Work/Uni/ProjectReport.docx",
                "~/Documents/Work/spending.xlsx
            ]
        }
    ]
}
```
