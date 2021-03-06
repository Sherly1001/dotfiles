$host.ui.rawui.windowtitle = 'pwsh'

function git-status {
    $branch = git branch --show-current 2>$null
    if ($branch -eq $null) {
        return $null
    }

    git status -s 2>$null | ForEach-Object -Begin {
        $index = $False; $working = $False; $untrack = $False
    } -Process {
        switch -Regex ($_) {
            '^\w'   { $index = $True }
            '^ \w'  { $working = $True }
            '^\?\?' { $untrack = $True }
        }
    }

    return New-Object psobject -Property @{
        branch = $branch
        hasIndex = $index
        hasWorking = $working
        hasUntrack = $untrack
    }
}

function prompt {
    $color = if ($?) { 'green' } else { 'red' }
    $regex = [regex]::Escape($HOME) + "(\\.*)*$"
    $st = git-status

    Write-Host 'PS ' -nonewline
    Write-Host "$($pwd -replace $regex, '~$1')" -fore blue -nonewline

    if ($st) {
        if ($st.hasUntrack -or $st.hasWorking) {
            $cl = 'red'
            $bk = 'red'
        } elseif ($st.hasIndex) {
            $cl = 'yellow'
        } else {
            $cl = 'green'
            $bk = 'green'
        }
        if ($st.hasIndex) { $bk = 'yellow' }

        Write-Host " [" -fore $bk -nonewline
        Write-Host $st.branch -fore $cl -nonewline
        Write-Host "]" -fore $bk -nonewline
    }

    Write-Host "`n->" -fore $color -nonewline

    return ' '
}

Set-Alias e explorer
Set-Alias grep Select-String
Set-Alias py python

function gco { git checkout $args }
function gcoo { gco master $args }
Remove-Item Alias:gcm -Force
function gcm { git commit -m $args }
function gad { git add $args }
function glg { git log $args }
function glo { git log --oneline $args }
function gpu { git push $args }
function gpl { git pull $args }
function gft { git fetch $args }
function gcl { git clone $args }
function gmg { git merge $args }
function gbr { git branch $args }
function gst { git status $args }
function gdf { git diff $args }
function gdc { git diff --cached $args }
function gd { git diff --no-index $args }

Set-PSReadLineKeyHandler -Chord Ctrl+w -Function ViExit
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function ViExit

function fm($file) {
    Invoke-Expression "astyle -A2s4SpHUk3W3xfxhOn $file"
}

function clfm() {
    foreach ($file in $args) {
        Invoke-Expression "clang-format --style='{ AllowShortFunctionsOnASingleLine: Empty, AllowShortIfStatementsOnASingleLine: WithoutElse, AllowShortLoopsOnASingleLine: true, IncludeBlocks: Regroup, IndentCaseLabels: true, IndentWidth: 4, SortIncludes: false }' -i $file"
    }
}

function b {
    param([switch]$g)

    if (-not $args[0]) {
        Write-Host -fore red "No input file"
        return
    }

    $out = [System.IO.Path]::GetFileNameWithoutExtension($args[0]) + '.exe'
    $ext = [System.IO.Path]::GetExtension($args[0])

    $cc = 'clang '
    if ($ext -like '.cpp') {
        $cc = 'clang++ '
    }
    if ($g) {
        $cc += '-g '
    }

    if ($args[1] -and $args[1] -ne '.') {
        $out = $args[1]
        if ([System.IO.Path]::GetExtension($out) -eq '') {
            $out += '.exe'
        }
    }

    $cc += "'$($args[0])' "
    $cc += "-o '$($out)'"

    foreach($i in $args[2..$args.length]) {
        $cc += " '$i'"
    }

    write-host "$cc"
    Invoke-Expression "$cc"
}

Remove-Item Alias:rm
function rm {
    foreach ($file in $args) {
        Remove-Item -force -recurse $file
    }
}

Remove-Item Alias:cls
function cls {
Clear-Host
write-host -fore green "
                   _____    __                       __            ___   ____     ____     ___
                  / ___/   / /_     ___     _____   / /  __  __   <  /  / __ \   / __ \   <  /
                  \__ \   / __ \   / _ \   / ___/  / /  / / / /   / /  / / / /  / / / /   / / 
                 ___/ /  / / / /  /  __/  / /     / /  / /_/ /   / /  / /_/ /  / /_/ /   / /  
                /____/  /_/ /_/   \___/  /_/     /_/   \__, /   /_/   \____/   \____/   /_/   
                                                      /____/                                  "
}

write-host -fore green "
                   _____    __                       __            ___   ____     ____     ___
                  / ___/   / /_     ___     _____   / /  __  __   <  /  / __ \   / __ \   <  /
                  \__ \   / __ \   / _ \   / ___/  / /  / / / /   / /  / / / /  / / / /   / / 
                 ___/ /  / / / /  /  __/  / /     / /  / /_/ /   / /  / /_/ /  / /_/ /   / /  
                /____/  /_/ /_/   \___/  /_/     /_/   \__, /   /_/   \____/   \____/   /_/   
                                                      /____/                                  "
