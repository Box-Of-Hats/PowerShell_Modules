# Powershell Modules

## Quick-Start Guide

1. Clone or download this repository

    `> git clone https://github.com/Box-Of-Hats/PowerShell_Modules.git`

2. Open a powershell window in the modules directory

    `> cd .\modules\`

3. Run ModuleInstaller.ps1

    `> .\ModuleInstaller.ps1 -InstallAllModules`

You now have all of the modules installed and the commands will be available in all of your powershell sessions.

You can use the `Edit-Config` command to select any of the config files used by these modules and you can adjust the settings to suit your needs.

Note: If you re-install any modules using ModuleInstaller.ps1, __you will lose any config.json files.__ You can instead create config.user.json files which will not be overwritten. All modules will prioritise config.user.json files when they are found. 

___

## Available modules

### Module installer

To install any modules from this repo, you can dump the associated directory into your Powershell modules folder. 

Otherwise, you can run ModuleInstaller.ps1 from this repo with the name of the module that you want to install.

Once installled, the module and its commands will be available in all of your powershell sessions, without needing to import it every time.

`E:\dev\code\PowerShell_Snippets\modules> .\ModuleInstaller.ps1 .\WorkspaceManager`


![Installation Example](images/ps_snips_install_example.gif)

### WorkspaceManager

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

#### Usage

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

## Scripts

### Process clipboard selection

Need to copy lots of items from one place to another but the format isn't quite right? You can modify the clipboard selection on-the-fly!

```Powershell
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
        sleep 1
        Write-Host "$clipBoard"
    }
}
```
