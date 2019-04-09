
<#
.DESCRIPTION
Get a choice from a selection, via an arrow-navigated menu.

.PARAMETER OptionsList
The list of options to choose from

.OUTPUTS
The index of the selected option
#>

function Get-ChoiceWithArrowMenu {
    Param(
        [Parameter(Mandatory = $true)] $OptionsList,
        [Parameter(Mandatory = $false)] $Message = "Make a choice:"
    )

    $cursorLocation = 0;
    while ($true) {
        Clear-Host
        Write-Host $Message
        Write-Host ("-" * $Message.Length)
        for ($i = 0; $i -lt $OptionsList.Count; $i++) {
            if ($i -eq $cursorLocation) {
                Write-Host "$($OptionsList[$i]) <" -ForegroundColor Green
            }
            else {
                Write-Host $OptionsList[$i]
            }
        }
        $pressedKeyCode = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Select-Object -ExpandProperty VirtualKeyCode
        if ($pressedKeyCode -eq 38) {
            # Up
            $cursorLocation--
        }
        elseif ($pressedKeyCode -eq 40) {
            # Down
            $cursorLocation++
        }
        elseif ($pressedKeyCode -eq 37) {
            # Left
            $cursorLocation = 0
        }
        elseif ($pressedKeyCode -eq 39) {
            # Right
            $cursorLocation = $OptionsList.Count - 1
        }
        elseif ($pressedKeyCode -eq 32) {
            # Space
            return $cursorLocation
        }
        elseif ($pressedKeyCode -eq 13) {
            # Return
            return $cursorLocation
        }
        elseif ($pressedKeyCode -eq 27) {
            # Escape
            return -1
        }
        $cursorLocation = [math]::Min([math]::Max($cursorLocation, 0), $OptionsList.Count - 1)
    }
}


function Edit-Config {

    $configFiles = Get-ChildItem $env:PSModulePath.Split(";")[0] -Include "config.*json" -Recurse

    $chosenConfigIndex = Get-ChoiceWithArrowMenu ($configFiles) "Edit config for module:"

    if ($chosenConfigIndex -eq -1){
        return
    }

    Invoke-Item $configFiles[$chosenConfigIndex]
    
}

Export-ModuleMember Edit-Config