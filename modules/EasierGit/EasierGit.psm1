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


<#
.SYNOPSIS
Undo your last git commit
#>

function Undo-GitCommit {
    git reset --soft HEAD~1
}

Export-ModuleMember Show-GitBranches
Export-ModuleMember Clear-GitCache
Export-ModuleMember Undo-GitCommit