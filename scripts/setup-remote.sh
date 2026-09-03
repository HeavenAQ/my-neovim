#!/usr/bin/env bash
# リモートサーバに、普段使っている道具一式を sudo 無しで入れる。
#
#   使い方（サーバ上で実行）:
#     bash setup-remote.sh              # 道具を入れて .bashrc / .tmux.conf を整える
#     bash setup-remote.sh --no-tools   # .bashrc / .tmux.conf だけ
#     bash setup-remote.sh --dry-run    # 何をするかだけ出す
#
#   手元から流し込む場合:
#     ssh <host> 'bash -s' < setup-remote.sh
#
# 方針:
#   - sudo を使わない。全部 ~/.local/bin と ~/.fzf に入れる。
#   - 何度流しても同じ結果になる（.bashrc への追記はマーカーで囲って置換する）。
#   - **アーキテクチャを必ず判定して落とす。** ここを手で間違えると
#     「PATH にはあるのに Exec format error で動かない」状態になり、
#     nvim の picker が黙って死ぬ（実際に ARM の fd を x86 機に置いて踏んだ）。
set -euo pipefail

DO_TOOLS=1
DRY=0
for a in "$@"; do
  case "$a" in
    --no-tools) DO_TOOLS=0 ;;
    --dry-run)  DRY=1 ;;
    -h|--help)  sed -n '2,18p' "$0"; exit 0 ;;
    *) echo "不明な引数: $a" >&2; exit 2 ;;
  esac
done

BIN="$HOME/.local/bin"
say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
run()  { if [ "$DRY" = 1 ]; then echo "  [dry] $*"; else eval "$@"; fi; }

# ---- アーキテクチャ判定 ---------------------------------------------------
case "$(uname -m)" in
  x86_64|amd64)  RUST_ARCH=x86_64-unknown-linux-musl;  NVIM_ARCH=linux-x86_64 ;;
  aarch64|arm64) RUST_ARCH=aarch64-unknown-linux-musl; NVIM_ARCH=linux-arm64  ;;
  *) echo "未対応のアーキテクチャ: $(uname -m)" >&2; exit 1 ;;
esac
say "arch=$(uname -m) → rust:$RUST_ARCH nvim:$NVIM_ARCH"
mkdir -p "$BIN"
# 導入済み判定の前に PATH を通しておく。非対話 ssh の PATH には ~/.local/bin が
# 入っていないため、これが無いと「既にあるのに無い」と誤判定して入れ直す。
export PATH="$BIN:$HOME/.fzf/bin:$PATH"

gh_latest() {  # <owner/repo> -> 最新タグ
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
    | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1
}

fetch_tar() {  # <url> <tar内の実行ファイル名> <入れる名前>
  local url=$1 inner=$2 name=$3 tmp
  tmp=$(mktemp -d)
  curl -fsSL "$url" -o "$tmp/a.tar.gz"
  tar xzf "$tmp/a.tar.gz" -C "$tmp"
  local src; src=$(find "$tmp" -type f -name "$inner" -perm -u+x | head -1)
  [ -n "$src" ] || { warn "$name: 展開物の中に $inner が無い"; rm -rf "$tmp"; return 1; }
  install -m755 "$src" "$BIN/$name"
  rm -rf "$tmp"
  # 落としたものが本当にこの機械で動くか確かめる（アーキ違いをここで弾く）
  "$BIN/$name" --version >/dev/null 2>&1 \
    || { warn "$name を入れたが実行できない（アーキ不一致の可能性）"; return 1; }
  say "$name → $($BIN/$name --version 2>&1 | head -1)"
}

install_tools() {
  if [ "$DRY" = 1 ]; then
    for t in rg fd nvim zoxide fzf; do
      if command -v "$t" >/dev/null 2>&1; then echo "  [dry] $t: 既にある（何もしない）"
      else echo "  [dry] $t: 導入する"; fi
    done
    return
  fi
  if command -v rg >/dev/null 2>&1; then say "rg: 既にある ($(command -v rg))"; else
    local t; t=$(gh_latest BurntSushi/ripgrep)
    fetch_tar "https://github.com/BurntSushi/ripgrep/releases/download/$t/ripgrep-$t-$RUST_ARCH.tar.gz" rg rg || true
  fi
  if command -v fd >/dev/null 2>&1 && fd --version >/dev/null 2>&1; then
    say "fd: 既にある ($(command -v fd))"
  else
    local t; t=$(gh_latest sharkdp/fd)
    fetch_tar "https://github.com/sharkdp/fd/releases/download/$t/fd-$t-$RUST_ARCH.tar.gz" fd fd || true
  fi
  if command -v nvim >/dev/null 2>&1; then say "nvim: 既にある ($(command -v nvim))"; else
    local t tmp; t=$(gh_latest neovim/neovim); tmp=$(mktemp -d)
    curl -fsSL "https://github.com/neovim/neovim/releases/download/$t/nvim-$NVIM_ARCH.tar.gz" -o "$tmp/n.tar.gz"
    tar xzf "$tmp/n.tar.gz" -C "$HOME"
    ln -sf "$HOME/nvim-$NVIM_ARCH/bin/nvim" "$BIN/nvim"
    rm -rf "$tmp"; say "nvim → $($BIN/nvim --version | head -1)"
  fi
  if command -v zoxide >/dev/null 2>&1; then say "zoxide: 既にある"; else
    curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash >/dev/null 2>&1 \
      && say "zoxide 導入" || warn "zoxide の導入に失敗"
  fi
  if [ -x "$HOME/.fzf/bin/fzf" ] || command -v fzf >/dev/null 2>&1; then say "fzf: 既にある"; else
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" >/dev/null 2>&1
    "$HOME/.fzf/install" --bin >/dev/null 2>&1 && say "fzf 導入"
  fi
}

# ---- .bashrc（マーカーで囲った管理ブロックを置換）--------------------------
BEGIN='# >>> remote-setup >>>'
END='# <<< remote-setup <<<'
write_bashrc() {
  local rc="$HOME/.bashrc" block
  block=$(cat <<'BLOCK'
# >>> remote-setup >>>
# setup-remote.sh が管理する区画。手で書き換えても次回の実行で上書きされる。

# PATH は .bashrc の冒頭の「対話的でなければ return」より後ろに書くと、
# 非対話シェル（scp / ssh <cmd> / エディタが起こすプロセス）に効かない。
# nvim をそこから起こすと rg/fd が見つからず picker が黙って死ぬので、
# .profile 側にも同じものを置いてある。
export PATH="$HOME/.local/bin:$HOME/.fzf/bin:$PATH"
[ -d "$HOME/nvim-linux-x86_64/bin" ] && export PATH="$HOME/nvim-linux-x86_64/bin:$PATH"
[ -d "$HOME/nvim-linux-arm64/bin" ]  && export PATH="$HOME/nvim-linux-arm64/bin:$PATH"

export EDITOR=nvim
export VISUAL=nvim

alias ll="ls -la"
alias l="ls -la"
alias la="ls -a"
alias v=nvim
alias vim=nvim

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)"
[ -f "$HOME/.fzf.bash" ] && . "$HOME/.fzf.bash"
# <<< remote-setup <<<
BLOCK
)
  if [ "$DRY" = 1 ]; then echo "  [dry] $rc に管理ブロックを書く"; return; fi
  touch "$rc"
  cp "$rc" "$rc.bak-$(date +%Y%m%d-%H%M%S)"
  if grep -qF "$BEGIN" "$rc"; then
    awk -v b="$BEGIN" -v e="$END" -v new="$block" '
      index($0,b){print new; skip=1; next} index($0,e){skip=0; next} !skip' "$rc" > "$rc.tmp"
    mv "$rc.tmp" "$rc"
    say ".bashrc の管理ブロックを更新"
  else
    printf '\n%s\n' "$block" >> "$rc"
    say ".bashrc に管理ブロックを追記"
  fi
  # --- ログインシェル側 ---------------------------------------------------
  # bash はログイン時、.bash_profile → .bash_login → .profile の順で
  # **最初に見つかった1つだけ**を読む。.bash_profile があるのに .profile へ
  # 書いても永久に読まれないので、実際に読まれるファイルを選ぶ。
  local login_rc
  if   [ -f "$HOME/.bash_profile" ]; then login_rc="$HOME/.bash_profile"
  elif [ -f "$HOME/.bash_login" ];   then login_rc="$HOME/.bash_login"
  elif [ -f "$HOME/.profile" ];      then login_rc="$HOME/.profile"
  else login_rc="$HOME/.bash_profile"; touch "$login_rc"
  fi
  say "ログインシェルが読むのは $(basename "$login_rc")"
  cp "$login_rc" "$login_rc.bak-$(date +%Y%m%d-%H%M%S)" 2>/dev/null || true

  # ログインシェルは .bashrc を自動では読まない。読ませておかないと
  # ssh で入った直後だけ alias も PATH も無い、という状態になる。
  if ! grep -q 'bashrc' "$login_rc" 2>/dev/null; then
    printf '\n# .bashrc を読む（ログインシェルは自動では読まない）\nif [ -f "$HOME/.bashrc" ]; then . "$HOME/.bashrc"; fi\n' >> "$login_rc"
    say "$(basename "$login_rc") から .bashrc を読むようにした"
  fi

  # 非対話シェル（ssh <cmd> / エディタが起こすプロセス）にも PATH を通す。
  # .bashrc の PATH 行は「対話的でなければ return」より後ろにあるため効かない。
  if ! grep -q 'remote-setup PATH' "$login_rc" 2>/dev/null; then
    printf '\n# remote-setup PATH（非対話シェル用）\nexport PATH="$HOME/.local/bin:$HOME/.fzf/bin:$PATH"\n' >> "$login_rc"
    say "$(basename "$login_rc") に PATH を追記"
  fi
}

# ---- tmux（OSC 52 を外側の端末へ通す）------------------------------------
write_tmux() {
  local f="$HOME/.tmux.conf"
  if [ "$DRY" = 1 ]; then echo "  [dry] $f に clipboard 設定"; return; fi
  touch "$f"
  grep -q 'set-clipboard on' "$f" || cat >> "$f" <<'TCONF'

# yank を手元の端末のクリップボードへ通す（OSC 52）
set -g set-clipboard on
set -g allow-passthrough on
# tmux が外へ中継するには、外側端末の terminfo に Ms が要る。
# 入れ子 tmux（手元も tmux）だと外側の TERM が tmux-256color になり
# Ms を持たないので、明示的に足しておく。
set -ag terminal-overrides ",tmux-256color:Ms=\\E]52;%p1%s;%p2%s\\7"
set -ag terminal-overrides ",screen-256color:Ms=\\E]52;%p1%s;%p2%s\\7"
TCONF
  say ".tmux.conf を整えた"
}

[ "$DO_TOOLS" = 1 ] && install_tools || say "道具の導入は飛ばす"
write_bashrc
write_tmux
say "完了。 exec bash -l で読み直すか、入り直してください。"
