# vi: sw=2 ts=2

set fish_greeting

set tty (tty)
if [ $tty = "/dev/tty1" ]
  startx &>/tmp/xinit.log
end

alias sn "screen -S"
alias sr "screen -r"
alias sls "screen -ls"

alias vi "nvim"
alias nv "neovide"
alias nu "nix-env --uninstall"

alias dp "docker-compose"
alias cm "cmake -B build -S ."
alias cmb "cmake --build build"

alias gco "git checkout"
alias gcoo "gco master"
alias gcm "git commit -m"
alias gcma "git commit --amend"
alias gad "git add"
alias glg "git log"
alias glo "git log --oneline"
alias gla "git log --oneline --graph --all"
alias gpu "git push"
alias gpl "git pull"
alias gft "git fetch"
alias gcl "git clone"
alias gmg "git merge"
alias gbr "git branch"
alias gst "git status"
alias gdf "git diff"
alias gdc "git diff --cached"
alias gd "git diff --no-index"

function fish_git_prompt
  if not git branch &>/dev/null
    return 0
  end

  set br (git branch --show-current 2>/dev/null)
  set st (git status -s 2>/dev/null | awk '/^\w/ { i = "i"; } /^.\w/ { w = "w"; } /^\?\?/ { u = "u"; } END { print u w i }')

  if [ (string match -r u $st) ] || [ (string match -r w $st) ]
    set cl red
    set bk red
  else if [ (string match -r i $st) ]
    set cl yellow
  else
    set cl green
    set bk green
  end

  if [ (string match -r i $st) ]
    set bk yellow
  end

  set cl (set_color $cl)
  set bk (set_color $bk)

  [ -z $br ] && set br "no branch"
  echo -n $bk'['$cl$br$bk']'(set_color normal)
end

function fish_prompt --description 'Write out the prompt'
  set -l last_pipestatus $pipestatus
  set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
  set -l normal (set_color normal)
  set -q fish_color_status
  or set -g fish_color_status red

  if [ $last_pipestatus[-1] -eq 0 ]
    set suffix_color (set_color green)
  else
    set suffix_color (set_color red)
  end

  # Color the prompt differently when we're root
  set -l color_cwd $fish_color_cwd
  set -l suffix '\n->'
  if functions -q fish_is_root_user; and fish_is_root_user
    if set -q fish_color_cwd_root
      set color_cwd $fish_color_cwd_root
    end
    set suffix '\n#'
  end

  # Write pipestatus
  # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
  set -l bold_flag --bold
  set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
  if test $__fish_prompt_status_generation = $status_generation
    set bold_flag
  end
  set __fish_prompt_status_generation $status_generation
  set -l status_color (set_color $fish_color_status)
  set -l statusb_color (set_color $bold_flag $fish_color_status)
  set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

  set color_cwd brblue

  if test "$NX" != ""
    set nx (set_color green)'#'$NX'#'$normal' '
  end

  echo -n -s -e (prompt_login)' ' (set_color $color_cwd) (prompt_pwd -d 10) $normal ' ' (fish_vcs_prompt) $normal ' ' $nx $prompt_status $suffix_color $suffix $normal ' '
end

if set -q NX_SHELL_HOOK
  source (echo $NX_SHELL_HOOK | psub)
end

function nx --description 'nix-shell with pre conf shell'
  argparse -i 's/shell=' 'r/run=?' -- $argv

  set shell /cmn/sx/$_flag_shell.nix
  if test -d /cmn/sx/$_flag_shell
    set shell /cmn/sx/$_flag_shell
  end

  if set -q _flag_run && test -n "$_flag_run"
    set NX $_flag_run
    set run --run $_flag_run
  else
    set NX $argv
    if test -z "$NX"
      set NX $shell
    end
    if set -q _flag_run
      set run --run $argv[-1]
    else
      set run --run "NX='$NX' fish"
    end
  end

  NIXPKGS_ALLOW_UNFREE=1 nix-shell $shell $argv $run
end

function ni --description 'nix-env nixpkgs install'
  for pkg in $argv
    set -a pkgs nixpkgs.$pkg
  end
  NIXPKGS_ALLOW_UNFREE=1 nix-env -iA $pkgs
end

function gi --description 'create .gitignore'
  curl -sL "https://www.toptal.com/developers/gitignore/api/$argv"
end

function lu --description 'du and sort'
  argparse -i 'd=' 'r' -- $argv

  set -la arg '-ha'

  if set -q _flag_d
    set -a arg "-d$_flag_d"
  else
    set -a arg '-d1'
  end

  set -a arg $argv

  du $arg | sort -h $_flag_r
end
