#!/bin/sh

link() {
  if [ -L "$2" ]; then
    unlink "$2"
  fi
  ln -s "$1" "$2"
  echo "link: $1 -> $2"
}

readonly ROOTDIR=$(cd $(dirname $0) && pwd)
readonly HOMEDIR=$(cd ~ && pwd)

echo "Start [Install environment] ..."

# Vim or Neovim
#-----------------------------------------------------------------------------
readonly VIMDIR="$ROOTDIR/vimrc"
readonly VIMRC="$VIMDIR/vimrc"

readonly LINKVIMRC="$HOMEDIR/.vimrc"
link "$VIMRC" "$LINKVIMRC"

readonly XDGCONFIGDIR="$HOMEDIR/.config"
readonly LINKXDGCONFIG="$XDGCONFIGDIR/nvim"

if [ ! -d "$XDGCONFIGDIR" ]; then
  mkdir "$XDGCONFIGDIR"
fi
link "$VIMDIR" "$LINKXDGCONFIG"

readonly LINKVIM="$HOMEDIR/.vim"
link "$VIMDIR" "$LINKVIM"

# Shell
#-----------------------------------------------------------------------------

# Need `oh-my-posh`
# Install: curl -s https://ohmyposh.dev/install.sh | bash -s
readonly OMPTHEME="$ROOTDIR/theme.omp.json"
readonly LINKOMPTHEME="$HOMEDIR/.theme.omp.json"
link "$OMPTHEME" "$LINKOMPTHEME"

readonly ZINIT="$HOMEDIR/.local/share/zinit"
if [ ! -d "$ZINIT" ]; then
  sh -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fi

readonly ZSHRC="$ROOTDIR/zsh/zshrc"
readonly LINKZSHRC="$HOMEDIR/.zshrc"
link "$ZSHRC" "$LINKZSHRC"

readonly ZSHCONFIG="$ROOTDIR/zsh/zsh"
readonly LINKZSHCONFIG="$HOMEDIR/.zsh"
link "$ZSHCONFIG" "$LINKZSHCONFIG"

# tmux
#-----------------------------------------------------------------------------
readonly TMUX="$HOMEDIR/.tmux"
if [ ! -d "$TMUX" ]; then
  # Install .tmux and tpm
  git clone https://github.com/gpakosz/.tmux.git "$TMUX"
  git clone https://github.com/tmux-plugins/tpm "$TMUX/plugins/tpm"
fi
link "$TMUX/.tmux.conf" "$HOMEDIR/.tmux.conf"

readonly TMUXCONF="$ROOTDIR/tmux/tmux.conf"
readonly LINKTMUXCONF="$HOMEDIR/.tmux.conf.local"
link "$TMUXCONF" "$LINKTMUXCONF"

# Application
#-----------------------------------------------------------------------------
# Karabiner for macOS
if [ "$(uname)" = "Darwin" ]; then
  readonly KARABINER="karabiner-for-vim.json"
  readonly KARABINER_SRCPATH="${ROOTDIR}/karabiner/${KARABINER}"
  readonly KARABINER_DESTDIR="${HOMEDIR}/.config/karabiner/assets/complex_modifications"
  readonly KARABINER_LINKPATH="${KARABINER_DESTDIR}/${KARABINER}"

  if [ -d "$KARABINER_DESTDIR" ]; then
    link "$KARABINER_SRCPATH" "$KARABINER_LINKPATH"
  else
    echo "[ERROR] Require karabiner-elements. (Please install [brew install --cask karabiner-elements])" 1>&2
  fi
fi

echo "Done [Install environment]"
