
<#
.DESCRIPTION
    Prompt for confirmation, requiring a pin to be input to prevent accidental confirmation
.OUTPUTS
    Boolean
#>
function Get-PinConfirmation {
    Param(
        [Parameter(Mandatory = $false)][int]$PinLength = 4
    )

    $pin = ""

    for ($i = 0; $i -lt $PinLength; $i++) {
        $randomNumber = Get-Random -Minimum 0 -Maximum 10
        $pin = "$pin$randomNumber"
    }

    Write-Host "Enter the pin to confirm: '$pin'"
    $userIn = Read-Host ">"

    return $userIn -eq $pin
}


<#
.DESCRIPTION
    Show a multiple choice menu and prompt input

.OUTPUTS
    The index of the selected option
#>
function Get-Choice {
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

Export-ModuleMember Get-ChoiceWithArrowMenu
Export-ModuleMember Get-Choice
Export-ModuleMember Get-PinConfirmation