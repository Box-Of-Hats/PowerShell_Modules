function CreateNewVirtualDeskTop {
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
        [Parameter(Mandatory = $false)] $KeyList = "ZXCVBNMASDFGHJKLQWERTYUIOP1234567890"
    )
    for ($i = 0; $i -lt $OptionsList.Length; $i++) {
        $key = $KeyList[$i]
        $val = $OptionsList[$i]
        Write-Host $key "--" $val
    }

    $userIn = Read-Host ">"
    $userIn = $userIn.ToUpper().Trim()

    if ($userIn.Length -gt 1) {
        for ($i = 0; $i -lt $OptionsList.Length; $i++) {
            Write-Host "[$i] Comparing $userIn to" $OptionsList[$i]
            if ($OptionsList[$i].StartsWith($userIn, 'CurrentCultureIgnoreCase')) {
                return $i
            }
        }
        return -1
    }

    return $KeyList.IndexOf($userIn);
}

function OpenWorkspace {
    Param(
        $WorkSpace,
        $Applications
    )
    CreateNewVirtualDeskTop
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
        Start-Process $programs -WindowStyle Maximized
    }

    # Launch
    foreach ($programName in $WorkSpace.launch) {
        $launchablePrograms = @{}

        foreach ($item in $config.programs.PSObject.Properties) {
            $launchablePrograms[$item.Name] = $item.Value.ToString().Trim()
        }

        foreach ($item in $programName.PSObject.Properties) {
            $exe = $launchablePrograms.($item.Name)
            $arg = $item.Value
            Write-Host  "Start-Process '$exe' $arg"
            Start-Process $exe $arg
        }
    }

}

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

function Edit-WorkSpaces {
    $configFile = Get-ConfigFile
    if ([string]::IsNullOrEmpty($configFile)) {
        return
    }
    Start-Process Code $configFile
}

function Open-WorkSpace {
    Param(
        [string]$ConfigFile
    )
    Write-Host "TEST"
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
    $chosenWorkspaceIndex = ShowMenu $config.workspaces.name -KeyList $config.keylist
    
    if (-1 -eq $chosenWorkspaceIndex) {
        Write-Host "Could not find workspace."
        return
    }
    else {
        $chosenWorkspace = $config.workspaces[$chosenWorkspaceIndex]
        Write-Host "Opening workspace:" $chosenWorkspace.Name
        OpenWorkspace $chosenWorkspace
    }
}

function Close-Workspaces {
    param(
        [int]$Count = 10
    )
    for ($i = 0; $i -lt $Count; $i++) {
        CloseVirtualDeskTop
        Start-Sleep -Milliseconds 100
    }
}

Export-ModuleMember Edit-WorkSpaces
Export-ModuleMember Open-WorkSpace
Export-ModuleMember Close-Workspaces