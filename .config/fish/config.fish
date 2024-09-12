# vi: sw=2 ts=2

set fish_greeting

set -l fish_setting ~/.config/fish/settings
set -l fish_local_after "$fish_setting/local-after.fish"
set -l fish_local_before "$fish_setting/local-before.fish"

test -f $fish_local_before && source $fish_local_before

source "$fish_setting/alias.fish"
source "$fish_setting/funcs.fish"
source "$fish_setting/fzf.fish"

test -f $fish_local_after && source $fish_local_after
