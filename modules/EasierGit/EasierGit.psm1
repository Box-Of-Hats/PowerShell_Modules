function Show-GitBranches {
    git remote prune origin
    git fetch --all
    git branch --all

}

Export-ModuleMember Show-GitBranches