# Powershell Snippets

## Module installer

To install any modules from this repo, you can dump the associated directory into your Powershell modules folder. 

Otherwise, you can run ModuleInstaller.ps1 from this repo with the name of the module that you want to install.

`~\PowerShell_Snippets\ModuleInstaller> .\ModuleInstaller.ps1 ..\WorkspaceManager`

## WorkspaceManager

Open a workspace on a new virtual desktop in Windows 10. Workspaces are defined in a config.json file located in the WorkspaceManager directory. If config.user.json is present then it will be used as a higher priority.

For example:

`~/Documents/WindowsPowershell/Modules/WorkspaceManager/config.json`
`~/Documents/WindowsPowershell/Modules/WorkspaceManager/config.user.json`

```json
{
    "programs": {
        "vscode": "C:\\Users\\username\\AppData\\Local\\Programs\\Microsoft VS Code\\Code.exe",
        "vstudio": "C:\\Program Files (x86)\\Microsoft Visual Studio\\2017\\Enterprise\\Common7\\IDE\\devenv.exe"
    },
    "workspaces": [
        {
            "name": "Template Workspace",
            "websites": ["http://www.google.com"],
            "launch": {},
            "open_files": []
        },
        {
            "name": "Template Workspace 2",
            "websites": ["http://www.youtube.com"],
            "open_files": [],
            "launch": {
                "vstudio": "C:\\Users\\username\\source\\repos\\project1\\projnumber1.sln",
                "code": ["~\\Documents"]
            }
        }
    ]
}
```

### Usage

Run the command Open-Workspace and a list of your workspaces will show.

To open a workspace, you can either type the quick-code letter to the left of an option (e.g 'X' would open the workspace 'Uni Work') or you can type the start of the name of the workspace and the first match will be opened.

```
    > Open-WorkSpace
     Loaded config from  E:\ja1ke\Documents\WindowsPowerShell\Modules\WorkspaceManager\\config.user.json
     Select a workspace:
     Z -- Relaxation
     X -- Uni Work
    > Relaxa|
```

## Process clipboard selection

Need to copy lots of items from one place to another but the format isn't quite right? You can modify the clipboard selection on-the-fly!

```Powershell
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
```
