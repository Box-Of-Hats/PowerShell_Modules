﻿function CreateNewVirtualDeskTop {
    $KeyShortcut = Add-Type -MemberDefinition @"
    [DllImport("user32.dll")]
    static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
    //WIN + CTRL + D: Create a new desktop
    public static void CreateVirtualDesktopInWin10()
    {
        //Key down
        keybd_event((byte)0x5B, 0, 0, UIntPtr.Zero); //Left Windows key
        keybd_event((byte)0x11, 0, 0, UIntPtr.Zero); //CTRL
        keybd_event((byte)0x44, 0, 0, UIntPtr.Zero); //D
        //Key up
        keybd_event((byte)0x5B, 0, (uint)0x2, UIntPtr.Zero);
        keybd_event((byte)0x11, 0, (uint)0x2, UIntPtr.Zero);
        keybd_event((byte)0x44, 0, (uint)0x2, UIntPtr.Zero);
    }
"@ -Name CreateVirtualDesktop -UsingNamespace System.Threading -PassThru
    $KeyShortcut::CreateVirtualDesktopInWin10()
}

function CloseVirtualDeskTop {
    $KeyShortcut = Add-Type -MemberDefinition @"
    [DllImport("user32.dll")]
    static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
    //WIN + CTRL + W: Close a desktop
    public static void CloseVirtualDesktopInWin10()
    {
        //Key down
        keybd_event((byte)0x5B, 0, 0, UIntPtr.Zero); //Left Windows key
        keybd_event((byte)0x11, 0, 0, UIntPtr.Zero); //CTRL
        keybd_event((byte)0x73, 0, 0, UIntPtr.Zero); //W
        //Key up
        keybd_event((byte)0x5B, 0, (uint)0x2, UIntPtr.Zero);
        keybd_event((byte)0x11, 0, (uint)0x2, UIntPtr.Zero);
        keybd_event((byte)0x44, 0, (uint)0x2, UIntPtr.Zero);
    }
"@ -Name CloseVirtualDesktop -UsingNamespace System.Threading -PassThru
    $KeyShortcut::CloseVirtualDesktopInWin10()
}

function ShowMenu {
    Param(
        [Parameter(Mandatory = $true)] $OptionsList,
        [Parameter(Mandatory = $false)] $KeyList = "ZXCVBNMASDFGHJKLQWERTYUIOP1234567890",
        [Parameter(Mandatory = $false)] $UserInput
    )
    for ($i = 0; $i -lt $OptionsList.Length; $i++) {
        $key = $KeyList[$i]
        $val = $OptionsList[$i]
        Write-Host $key "--" $val
    }

    if ([string]::IsNullOrEmpty($UserInput)){
        $UserInput = Read-Host ">"
    }
    $UserInput = $UserInput.ToUpper().Trim()

    if ($UserInput.Length -gt 1) {
        for ($i = 0; $i -lt $OptionsList.Length; $i++) {
            Write-Host "[$i] Comparing $UserInput to" $OptionsList[$i]
            if ($OptionsList[$i].StartsWith($UserInput, 'CurrentCultureIgnoreCase')) {
                return $i
            }
        }
        return -1
    }

    return $KeyList.IndexOf($UserInput);
}

function OpenWorkspace {
    Param(
        $WorkSpace,
        $Applications,
        [switch]$SameDesktop
    )
    if (-not $SameDesktop) {
        CreateNewVirtualDeskTop
    }

    Start-Sleep -Milliseconds 600
    # Open websites
    if ($workSpace.websites.Count -gt 0) {
        Start-Process chrome -ArgumentList  @($workSpace.websites[0], '/new-window')
    }
    if ($workSpace.websites.Count -gt 1) {
        Start-Sleep -Milliseconds 600
        foreach ($url in $WorkSpace.websites[1..$workSpace.websites.Count]) {
            Start-Process chrome $url
        }
    }

    # Misc Files
    foreach ($file in $WorkSpace.open_files) {
        Start-Process $file -WindowStyle Maximized
    }

    # Programs
    foreach ($programs in $WorkSpace.programs) {
        try {
            Start-Process $programs -WindowStyle Maximized -UseNewEnvironment | Out-Null
        } catch {
            Start-Process $programs | Out-Null
        }
    }

    # Launch
    foreach ($programName in $WorkSpace.launch) {
        $launchablePrograms = @{ }

        foreach ($item in $config.programs.PSObject.Properties) {
            $launchablePrograms[$item.Name] = $item.Value.ToString().Trim()
        }

        foreach ($item in $programName.PSObject.Properties) {
            $exe = $launchablePrograms.($item.Name)
            $arg = $item.Value
            Write-Host  "Start-Process '$exe' $arg"
            Start-Process $exe $arg  | Out-Null
        }
    }

    # Commands
    foreach ($command in $WorkSpace.commands) {
        Write-Host "Execute: $command"
        Invoke-Expression $command
        Start-Sleep 500
    }

}

<#
.DESCRIPTION
    Retrieve the json configuration file, in order of preference.
.OUTPUTS
    Path of the config file to use
#>
function Get-ConfigFile {
    $configPaths = (
        "$PSScriptRoot\\config.user.json",
        "$PSScriptRoot\\config.json"
    )
    if ([string]::IsNullOrEmpty($ConfigFile)) {
        foreach ($path in $configPaths) {
            if (Test-Path -Path $path -PathType Leaf) {
                return $path
            }
        }
    }

    Write-Host "Could not find a config file. Checked locations: "
    foreach ($path in $configPaths) {
        Write-Host $path
    }
}

<#
.DESCRIPTION
    Open the current json configuration file for editing in VSCode.
#>
function Edit-WorkSpaces {
    $configFile = Get-ConfigFile
    if ([string]::IsNullOrEmpty($configFile)) {
        return
    }
    Invoke-Item $configFile
}

<#
.DESCRIPTION
    Prompt the user for a selection and open the respective workspace.
.PARAMETER ConfigFile
    The path of the json config file to read from.
.PARAMETER SameDesktop
    Switch to allow a workspace to open in the same desktop.
#>
function Open-WorkSpace {
    Param(
        [string]$WorkSpaceName,
        [switch]$SameDesktop,
        [string]$ConfigFile
    )
    if ([string]::IsNullOrEmpty($ConfigFile)) {
        $ConfigFile = Get-ConfigFile
    }

    if (Test-Path -Path $ConfigFile -PathType Leaf) {
        Write-Host "Loaded config from $ConfigFile" -ForegroundColor Green
        $config = Get-Content $ConfigFile | ConvertFrom-Json
    }
    else {
        Write-Host "Could not find config: $ConfigFile"
        return
    }

    Write-Host "Select a workspace:"
    $chosenWorkspaceIndex = ShowMenu $config.workspaces.name -KeyList $config.keylist -UserInput $WorkSpaceName

    if (-1 -eq $chosenWorkspaceIndex) {
        Write-Host "Could not find workspace."
        return
    }
    else {
        $chosenWorkspace = $config.workspaces[$chosenWorkspaceIndex]
        Write-Host "Opening workspace:" $chosenWorkspace.Name
        OpenWorkspace $chosenWorkspace -SameDesktop:$SameDesktop
    }

}

<#
.DESCRIPTION
    Close X number of virtual desktops. The windows will remain open.
.PARAMETER Count
    The number of virtual desktops to close.
#>
function Close-Workspaces {
    param(
        [int]$Count = 10
    )
    for ($i = 0; $i -lt $Count; $i++) {
        CloseVirtualDeskTop
        Start-Sleep -Milliseconds 100
    }
}


#Alias
New-Alias -Name opw -Value Open-WorkSpace

#Exports
Export-ModuleMember -Alias *

Export-ModuleMember Edit-WorkSpaces
Export-ModuleMember Open-WorkSpace
Export-ModuleMember Close-Workspaces
