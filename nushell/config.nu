# Interactive Nushell config migrated from ~/.zshrc.

$env.config.buffer_editor = "nvim"

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"
$env.config.edit_mode = 'vi'
$env.HOMEBREW_PREFIX = "/opt/homebrew"
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
$env.HOMEBREW_REPOSITORY = "/opt/homebrew"
$env.BAT_THEME = "Nord"
$env.DYLD_LIBRARY_PATH = "/opt/homebrew/opt/expat/lib"
$env.FZF_DEFAULT_OPTS = "--color=gutter:-1,pointer:#214969"
$env.FZF_CTRL_T_OPTS = [
  "--walker-skip .git,node_modules,target"
  "--preview 'bat -n --color=always {}'"
  "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
] | str join " "
$env.QUARTO_PYTHON = "/Users/heavenchen/dev/umich-deep-learning/.venv/bin/python"

source ~/.config/nushell/vendor/autoload/starship.nu

$env.config.keybindings = [
  {
    name: fzf_history
    modifier: control
    keycode: char_r
    mode: [emacs vi_normal vi_insert]
    event: {
      send: executehostcommand
      cmd: "commandline edit --replace (history | get command | reverse | uniq | to text | fzf --height 40% --layout=reverse --no-sort --scheme=history --query (commandline) | str trim)"
    }
  }
]

let java_home = (^/usr/libexec/java_home -v 17 | str trim)
$env.JAVA_HOME = $java_home

$env.PATH = (
  $env.PATH
  | prepend [
      $"($env.JAVA_HOME)/bin"
      "/opt/homebrew/opt/python@3.12/libexec/bin"
      $"($nu.home-dir)/.local/bin"
      $"($nu.home-dir)/.cargo/bin"
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ]
  | append [
      $"($nu.home-dir)/Library/Application Support/Coursier/bin"
      $"($nu.home-dir)/.orbstack/bin"
    ]
  | uniq
)

# Keep macOS /usr/bin/open available since Nushell's built-in `open`
# has a different meaning.
alias nu-open = open
alias open = ^open

alias vim = nvim
alias v = nvim
alias l = ls -al
alias ll = ls -l
alias python = python3
alias pip = pip3

def nuconfig [] {
  ^nvim $nu.config-path
}

def nulogin [] {
  ^nvim $nu.loginshell-path
}

def zshconfig [] {
  nuconfig
}

def getip [] {
  ^ifconfig
  | lines
  | where {|line|
      (
        ($line | str contains "inet ")
        and (not ($line | str contains "inet6"))
        and (not ($line | str contains "127.0.0.1"))
      )
    }
  | each {|line|
      $line
      | split row " "
      | where {|part| $part != "" }
      | get 1
    }
  | str join "\n"
}

def ide [] {
  ^tmux kill-pane -a
  ^tmux split-window -h -p 25
  ^tmux select-pane -l
  ^tmux split-window -v -p 25
  ^tmux split-window -h
  ^tmux select-pane -t 0
}

def --env y [...args] {
  let tmp = (mktemp -t "yazi-cwd.XXXXXX")
  ^yazi ...$args --cwd-file $tmp

  let cwd = (nu-open $tmp)
  if $cwd != $env.PWD and ($cwd | path exists) {
    cd $cwd
  }

  rm -fp $tmp
}

# zsh-z compatible directory jumper. Reuses the existing ~/.z database.
def z-data-file [] {
  $nu.home-dir | path join ".z"
}

def z-entries [] {
  let data_file = (z-data-file)

  if not ($data_file | path exists) {
    return []
  }

  nu-open --raw $data_file
  | lines
  | where {|line| $line =~ '\|[0-9.]+\|[0-9]+$' }
  | parse "{path}|{rank}|{time}"
  | update rank {|row| $row.rank | into float }
  | update time {|row| $row.time | into int }
}

def z-save [entries: table] {
  let data_file = (z-data-file)
  let text = (
    $entries
    | each {|entry| $"($entry.path)|($entry.rank)|($entry.time)" }
    | str join "\n"
  )

  if ($text | is-empty) {
    "" | save --force $data_file
  } else {
    $"($text)\n" | save --force $data_file
  }
}

def z-touch [dir: string] {
  if not ($dir | path exists) {
    return
  }

  let data_file = (z-data-file)
  let now = ((date now | into int) // 1_000_000_000)
  let dir = ($dir | path expand)
  let old_entries = (z-entries)
  let old = ($old_entries | where path == $dir | first)
  let rank = if ($old | is-empty) { 1.0 } else { ($old.rank + 1.0) }
  let new_entry = { path: $dir, rank: $rank, time: $now }
  let entries = (
    $old_entries
    | where path != $dir
    | append $new_entry
  )

  if not ($data_file | path exists) {
    "" | save --force $data_file
  }

  z-save $entries
}

def z-remove [
  dir: string
  --recursive (-R)
] {
  let dir = ($dir | path expand)
  let entries = if $recursive {
    z-entries | where {|entry| not ($entry.path == $dir or ($entry.path | str starts-with $"($dir)/")) }
  } else {
    z-entries | where path != $dir
  }

  z-save $entries
}

def z-matches [
  ...query: string
  --rank (-r)
  --recent (-t)
  --current (-c)
] {
  let now = ((date now | into int) // 1_000_000_000)
  let terms = ($query | each { str downcase })
  let base = (
    z-entries
    | where {|entry| $entry.path != $env.PWD and ($entry.path | path exists) }
    | where {|entry|
        if $current {
          $entry.path | str starts-with $"($env.PWD)/"
        } else {
          true
        }
      }
    | where {|entry|
        if ($terms | is-empty) {
          true
        } else {
          let path = ($entry.path | str downcase)
          $terms | all {|term| $path | str contains $term }
        }
      }
    | insert age {|entry| [($now - $entry.time), 0] | math max }
    | insert frecent {|entry| $entry.rank / (($entry.age + 3600) | into float) }
  )

  if $rank {
    $base | sort-by rank --reverse
  } else if $recent {
    $base | sort-by time --reverse
  } else {
    $base | sort-by frecent --reverse
  }
}

def "nu-complete z path" [context: string] {
  let parts = (
    $context
    | str trim --left
    | split row " "
    | skip 1
    | where {|part| not ($part | str starts-with "-") }
  )

  {
    options: {
      sort: false
      completion_algorithm: substring
      case_sensitive: false
    }
    completions: (
      z-matches ...$parts
      | each {|entry| { value: $entry.path, description: $"rank ($entry.rank), last used ($entry.time)" } }
    )
  }
}

def --env z [
  --list (-l)
  --echo (-e)
  --rank (-r)
  --recent (-t)
  --current (-c)
  --remove (-x)
  --recursive (-R)
  ...query: string@"nu-complete z path"
] {
  if $remove {
    z-remove $env.PWD --recursive=$recursive
    return
  }

  let matches = (z-matches ...$query --rank=$rank --recent=$recent --current=$current)

  if $list {
    $matches | select path rank time
  } else {
    let match = ($matches | first)
    if ($match | is-empty) {
      print --stderr $"z: no match found: ($query | str join ' ')"
      return
    }

    if $echo {
      print $match.path
    } else {
      cd $match.path
    }
  }
}

$env.config.hooks.env_change.PWD = (
  ($env.config.hooks.env_change.PWD? | default [])
  | append {|_before, after| z-touch $after }
)
