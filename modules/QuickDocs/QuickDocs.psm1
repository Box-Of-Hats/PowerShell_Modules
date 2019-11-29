$standupTemplate = '# {0} - {1}

## Yesterday

-   

## Today

-   

## Questions

-

## Comments

-   

## Issues

-   
';

function New-Standup() {
    param(
        [Parameter(Mandatory = $true)][string]$ProjectName,
        [Parameter()][switch]$OpenFile
    )
    $today = ([datetime]::Now).ToString("yyyy-MM-dd")
    $path = New-Item -Type File -Path ("{0}-{1}.md" -F ($today, $ProjectName)) -Value ($standupTemplate -F ($ProjectName, $today))
    if ($OpenFile){
        code $path
    }
    return $path.FullName
}

Export-ModuleMember New-Standup
