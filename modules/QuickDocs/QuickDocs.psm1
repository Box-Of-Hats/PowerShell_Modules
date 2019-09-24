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

function New-Standup(){
    param(
        [Parameter(Mandatory=$true)][string]$ProjectName
    )
    $today = ([datetime]::Now).ToString("yyyy-MM-dd")
    $path = New-Item -Type File -Path ("{0}-{1}.md" -F ($ProjectName, $today)) -Value ($standupTemplate -F ($ProjectName, $today))
    return $path.FullName
}

Export-ModuleMember New-Standup