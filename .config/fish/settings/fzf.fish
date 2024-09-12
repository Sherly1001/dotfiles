# vi: sw=2 ts=2

not type -q fzf && exit 0

fzf --fish | source

set -gx FZF_DEFAULT_OPTS "
  --bind=ctrl-k:kill-line
"

set -gx FZF_DEFAULT_COMMAND "
  rg -uu -H --color=never --files
"
