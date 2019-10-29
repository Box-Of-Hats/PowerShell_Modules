

function Get-WorkHours {
    Param(

        [Parameter(Mandatory = $true)][datetime]$StartTime,
        [Parameter(Mandatory = $false)][datetime]$EndTime,
        [Parameter(Mandatory = $false)][int]$LunchDuration = 1
    )

    if ($null -eq $EndTime) {
        $EndTime = Get-Date
    }

    $elapsedHours = (NEW-TIMESPAN -Start $StartTime -End $EndTime).TotalHours - $LunchDuration

    Write-Verbose "Shift $StartTime - $EndTime | $LunchDuration hour lunch | $elapsedHours hours"

    return $elapsedHours
}


#Alias
New-Alias -Name gwh -Value Get-WorkHours

#Exports
Export-ModuleMember -Alias *

Export-ModuleMember Get-WorkHours
