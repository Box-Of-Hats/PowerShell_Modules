function New-LorumIpsum {
    Param(
        [int] $CharLength = 150,
        [int] $SentenceLengthWords = 20,
        [switch] $ExactLength,
        $WordList
    )
    
    if ($null -eq $WordList ) {
        $WordList = @(
            "lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit", "Curabitur", "dignissim", "tortor",
            "non", "sollicitudin", "fermentum", "Aliquam", "est", "mi", "consectetur", "cursus", "Ut", "pellentesque", "varius",
            "orci", "quis", "lacinia", "eros", "dictum", "nec", "Donec", "blandit", "rutrum", "leo", "Vestibulum", "cursus",
            "vulputate", "velit", "a", "tincidunt", "Nam", "mattis", "iaculis", "faucibus", "Nam", "orci", "enim", "feugiat",
            "at", "molestie", "sed", "tincidunt", "sapien", "Etiam", "hendrerit", "risus", "ullamcorper", "sapien", "convallis",
            "sit", "amet", "sodales", "nulla", "elementum", "Interdum", "malesuada", "fames", "et", "ac", "ante", "ipsum", "primis",
            "in", "faucibus", "Phasellus", "gravida", "justo", "non", "pretium", "fermentum", "tellus", "felis", "vehicula", "felis",
            "iaculis", "nisl", "sem", "feugiat"
        )
    }

    $output = ""
    $currentSentenceLength = 0
    while ($output.Length -le $CharLength) {
        $randomWord = Get-Random -InputObject $WordList

        # Capitalise first word of each sentence
        if ($currentSentenceLength -eq 0) {
            $randomWord = (Get-Culture).TextInfo.ToTitleCase($randomWord)
        }
        else {
            $randomWord = $randomWord.ToLower()
        }

        $output = "$output $randomWord".TrimStart(' ')

        # End each setence with a period
        if ($currentSentenceLength -ge $SentenceLengthWords - 1) {
            $output = "$output."
            $currentSentenceLength = 0

        }
        else {
            $currentSentenceLength++
        }
    }

    # Truncate string if required
    if ($ExactLength) {
        if ($output.Length -ge $CharLength) {
            $output = $output.Substring(0, $CharLength - 1)
        }
    }

    # End the output with a period if it's not already
    if ($output.Substring($output.Length - 1) -ne ".") {
        $output = "$output."
    }
    Write-Host "Copied to clipboard." -ForegroundColor Green
    $output | clip.exe
    return $output
}

#Alias
New-Alias -Name lorum -Value New-LorumIpsum

#Exports
Export-ModuleMember -Alias *
Export-ModuleMember New-LorumIpsum