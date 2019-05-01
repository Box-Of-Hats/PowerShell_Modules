function Show-GitBranches {
    git remote prune origin
    git fetch --all
    git branch --all

}

<#
.SYNOPSIS
Clear your git cache to force your repo to use your .gitignore, even if a file is already tracked.

.DESCRIPTION
Clear your git cache to force your repo to use your .gitignore, even if a file is already tracked.

#>

function Clear-GitCache {
    git rm -r --cached .
    git add .
}

Export-ModuleMember Show-GitBranches
Export-ModuleMember Clear-GitCache