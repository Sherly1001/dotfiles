# vi: sw=2 ts=2

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

function prompt_nix_shell
  if set -q name
    echo -n (set_color blue)"[$name]> "(set_color normal)
  end
end

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

  set -l bold_flag --bold
  set -q __fish_prompt_status_generation
  or set -g __fish_prompt_status_generation $status_generation

  if test $__fish_prompt_status_generation = $status_generation
    set bold_flag
  end

  set __fish_prompt_status_generation $status_generation
  set -l status_color (set_color $fish_color_status)
  set -l statusb_color (set_color $bold_flag $fish_color_status)
  set -l prompt_status (__fish_print_pipestatus "[" "]" "|"\
    "$status_color" "$statusb_color" $last_pipestatus)

  set color_cwd brblue

  echo -n -s -e (prompt_nix_shell) (prompt_login)' ' (set_color $color_cwd)\
    (prompt_pwd -d 10) $normal ' ' (fish_vcs_prompt) $normal ' '\
    $prompt_status $suffix_color $suffix $normal ' '
end
