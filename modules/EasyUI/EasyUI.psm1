
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
        $randomNumber = Get-Random -Minimum 0 -Maximum 9
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

Export-ModuleMember Get-Choice
Export-ModuleMember Get-PinConfirmation