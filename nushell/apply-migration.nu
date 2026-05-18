#!/usr/bin/env nu

def symlink-points-to [target: path, source: path] {
  if (($target | path type) != "symlink") {
    return false
  }

  ((^readlink $target | str trim) == $source)
}

def backup-and-link [source: path, target: path, backup_dir: path] {
  if not ($source | path exists) {
    error make {msg: $"missing source path: ($source)"}
  }

  if (symlink-points-to $target $source) {
    print $"ok: ($target) already points to ($source)"
    return
  }

  if (($target | path type) != null) {
    mkdir $backup_dir
    let backup_target = ($backup_dir | path join ($target | path basename))
    mv $target $backup_target
    print $"backed up: ($target) -> ($backup_target)"
  }

  ^ln -s $source $target
  print $"linked: ($target) -> ($source)"
}

def import-zsh-history [] {
  let zsh_history = ($nu.home-dir | path join ".zsh_history")
  if not ($zsh_history | path exists) {
    print $"skip: ($zsh_history) does not exist"
    return
  }

  let commands = (
    open $zsh_history
    | lines
    | parse --regex '^: [0-9]+:[0-9]+;(?<command>.*)$'
    | get command
  )

  if ($commands | is-empty) {
    print "skip: no zsh extended-history commands found"
    return
  }

  let first_command = ($commands | first)
  if ((history | where command == $first_command | length) > 0) {
    print "skip: zsh history appears to be imported already"
    return
  }

  $commands | history import
  print $"imported ($commands | length) zsh history entries"
}

def main [
  --import-history
] {
  let source_dir = ($nu.home-dir | path join ".config" "nushell")
  let target_dir = ($nu.home-dir | path join "Library" "Application Support" "nushell")
  let backup_dir = ($target_dir | path join $"backup-(date now | format date '%Y%m%d%H%M%S')")

  mkdir $target_dir

  backup-and-link ($source_dir | path join "config.nu") ($target_dir | path join "config.nu") $backup_dir
  backup-and-link ($source_dir | path join "env.nu") ($target_dir | path join "env.nu") $backup_dir
  backup-and-link ($source_dir | path join "login.nu") ($target_dir | path join "login.nu") $backup_dir
  backup-and-link ($source_dir | path join "vendor") ($target_dir | path join "vendor") $backup_dir

  if $import_history {
    import-zsh-history
  } else {
    print "skip: zsh history import disabled; pass --import-history to append it"
  }
}
