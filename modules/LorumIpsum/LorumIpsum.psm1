function New-LorumIpsum {
    Param(
        [int] $CharLength = 150,
        [int] $SentenceLengthWords = 10,
        [switch] $ExactLength
    )
    $words = @(
        "lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit", "Curabitur", "dignissim", "tortor",
        "non", "sollicitudin", "fermentum", "Aliquam", "est", "mi", "consectetur", "cursus", "Ut", "pellentesque", "varius",
        "orci", "quis", "lacinia", "eros", "dictum", "nec", "Donec", "blandit", "rutrum", "leo", "Vestibulum", "cursus",
        "vulputate", "velit", "a", "tincidunt", "Nam", "mattis", "iaculis", "faucibus", "Nam", "orci", "enim", "feugiat",
        "at", "molestie", "sed", "tincidunt", "sapien", "Etiam", "hendrerit", "risus", "ullamcorper", "sapien", "convallis",
        "sit", "amet", "sodales", "nulla", "elementum", "Interdum", "malesuada", "fames", "et", "ac", "ante", "ipsum", "primis",
        "in", "faucibus", "Phasellus", "gravida", "justo", "non", "pretium", "fermentum", "tellus", "felis", "vehicula", "felis",
        "iaculis", "nisl", "sem", "feugiat"
    )

    $output = ""
    $currentSentenceLength = 0
    while ($output.Length -le $CharLength) {
        $randomWord = Get-Random -InputObject $words

        if ($currentSentenceLength -eq 0) {
            $firstLetter = $randomWord.Substring(0, 1).ToUpper()
            $remainder = $randomWord.Substring(1)
            $randomWord = "$firstLetter$remainder"
        }
        else {
            $randomWord = $randomWord.ToLower()
        }

        $output = "$output $randomWord"
        if ($currentSentenceLength -ge $SentenceLengthWords-1) {
            $output = "$output."
            $currentSentenceLength = 0

        }
        else {
            $currentSentenceLength++
        }
    }

    if ($ExactLength) {
        if ($output.Length -ge $CharLength) {
            $output = $output.Substring(0, $CharLength)
        }
    }

    if ($output.Substring($output.Length - 1) -ne ".") {
        $output = "$output."
    }
    

    $output | clip
    return $output
}

Export-ModuleMember New-LorumIpsum