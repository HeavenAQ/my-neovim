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

# zoxide directory jumper for Nushell
source ~/.zoxide.nu

def "nu-complete zoxide path" [context: string] {
  let parts = $context | str trim --left | split row " " | skip 1 | each { str downcase }
  let completions = (
    ^zoxide query --list --exclude $env.PWD -- ...$parts
    | lines
    | each {|dir|
        if ($parts | length) <= 1 {
          $dir
        } else {
          let dir_lower = $dir | str downcase
          let rem_start = $parts | drop 1 | reduce --fold 0 {|part, rem_start|
            ($dir_lower | str index-of --range $rem_start.. $part) + ($part | str length)
          }
          {
            value: ($dir | str substring $rem_start..)
            description: $dir
          }
        }
      }
  )
  {
    options: {
      sort: false
      completion_algorithm: substring
      case_sensitive: false
    }
    completions: $completions
  }
}

def --env --wrapped z [...rest: string@"nu-complete zoxide path"] {
  __zoxide_z ...$rest
}
