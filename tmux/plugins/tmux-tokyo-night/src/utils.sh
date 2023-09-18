#!/usr/bin/env bash
#
get_tmux_option() {
  local option=$1
  local default_value=$2
  local -r option_value=$(tmux show-option -gqv "$option")

  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

function generate_left_side_string() {
  local separator_end="#[bg=#292e42]#{?client_prefix,#[fg=#e0af68],#[fg=#ff9e64]}${left_separator:?}#[none]"

  echo "#[fg=#3b4261,bold]#{?client_prefix,#[bg=#e0af68],#[bg=#ff9e64]}   #S ${separator_end}"
}

function generate_inactive_window_string() {
  local separator_start="#[bg=#737aa2,fg=#292e42]${left_separator:?}#[none]"
  local separator_internal="#[bg=#545c7e,fg=#737aa2]${left_separator:?}#[none]"
  local separator_end="#[bg=#292e42,fg=#545c7e]${left_separator:?}#[none]"

  echo "${separator_start}#[fg=#ffffff]#I${separator_internal}#[fg=#ffffff]   #W ${separator_end}"
}

function generate_active_window_string() {
  separator_start="#[bg=#3d59a1,fg=#292e42]${left_separator:?}#[none]"
  separator_internal="#[bg=#394b70,fg=#3d59a1]${left_separator:?}#[none]"
  separator_end="#[bg=#292e42,fg=#394b70]${left_separator:?}#[none]"

  echo  "${separator_start}#[fg=#ffffff]#I${separator_internal}#[fg=#ffffff]   #W ${separator_end}#[none]"
}
