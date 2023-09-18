#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=src/utils.sh
. "$CURRENT_DIR/utils.sh"

theme_variation=$(get_tmux_option "@theme_variation" "night")
theme_enable_icons=$(get_tmux_option "@theme_variation" 1)

# shellcheck source=src/palletes/night.sh
. "$CURRENT_DIR/palletes/$theme_variation.sh"

### Load Options
border_style_active_pane=$(get_tmux_option "@theme_active_pane_border_style" "fg=#737aa2")
border_style_inactive_pane=$(get_tmux_option "@theme_inactive_pane_border_style" "fg=#292e42")
left_separator=$(get_tmux_option "@theme_left_separator" "")
right_separator=$(get_tmux_option "@theme_right_separator" "")

# https://man.openbsd.org/OpenBSD-current/man1/tmux.1#acs
window_with_activity_style=$(get_tmux_option "@theme_window_with_activity_style" "italics")
window_status_bell_style=$(get_tmux_option "@theme_status_bell_style" "bold")

IFS=' ' read -r -a plugins <<< "$(get_tmux_option "@theme-plugins" "datetime")"

tmux set-option -g status-left-length 100
tmux set-option -g status-right-length 100

tmux set-window-option -g window-status-activity-style "$window_with_activity_style"
tmux set-window-option -g window-status-bell-style "${window_status_bell_style}"

# message styling
tmux set-option -g message-style "bg=#414868,fg=#89ddff"

# status bar
tmux set-option -g status-style "bg=#181826,fg=#ffffff"

# border color
tmux set-option -g pane-active-border-style "$border_style_active_pane"
tmux set-option -g pane-border-style "$border_style_inactive_pane"

### Left side
tmux set-option -g status-left "$(generate_left_side_string)"

### Windows list
tmux set-window-option -g window-status-format "$(generate_inactive_window_string)" 
tmux set-window-option -g window-status-current-format "$(generate_active_window_string)"

### Right side
tmux set-option -g status-right ""
last_plugin="${plugins[-1]}"
is_last_plugin=0

for plugin in "${plugins[@]}"; do

  if [ ! -f "${CURRENT_DIR}/plugin/${plugin}.sh" ]; then
    tmux display-message " #[bold]ERROR:#[none] The plugin #[bold]${plugin}#[none] does not exists!" 
  else
    if [ "$plugin" == "$last_plugin" ];then 
      is_last_plugin=1
    fi 

    # shellcheck source=src/plugin/datetime.sh
    . "${CURRENT_DIR}/plugin/${plugin}.sh"

    icon_var="plugin_${plugin}_icon"
    accent_color_var="plugin_${plugin}_accent_color"
    accent_color_icon_var="plugin_${plugin}_accent_color_icon"

    plugin_icon="${!icon_var}"
    accent_color="${!accent_color_var}"
    accent_color_icon="${!accent_color_icon_var}"

    separator_start="#[fg=$accent_color,bg=#292e42]${right_separator}#[none]"
    separator_end="#[fg=#292e42,bg=$accent_color]${right_separator}#[none]"
    separator_icon_start="#[fg=$accent_color_icon,bg=#292e42]${right_separator}#[none]"
    separator_icon_end="#[fg=$accent_color,bg=$accent_color_icon]${right_separator}#[none]"

    plugin_output="#[fg=#ffffff,bg=$accent_color]$(load_plugin)#[none]"
    plugin_output_string=""

    plugin_icon_output="${separator_icon_start}#[fg=#ffffff,bg=$accent_color_icon]${plugin_icon}${separator_icon_end}"

    if [ ! $is_last_plugin -eq 1 ] || [ "${#plugins[@]}" -gt 1 ];then
      plugin_output_string="${plugin_icon_output}${plugin_output}${separator_end}"
    else
      plugin_output_string="${plugin_icon_output}${plugin_output}"
    fi

    tmux set-option -ga status-right "$plugin_output_string"
  fi 
done

tmux set-window-option -g window-status-separator ''
