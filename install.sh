#!/bin/sh

create_link() {
  if [ -e "$2" ]; then
    rm -f "$2"
  fi
  ln -s "$1" "$2"
  echo "create link: $1 -> $2"
}

readonly ROOTDIR=$(cd $(dirname $0) && pwd)
readonly HOMEDIR=$(cd ~ && pwd)

echo "Start [Install environment] ..."

# Vim or Neovim
#-----------------------------------------------------------------------------
readonly VIMDIR="$ROOTDIR/vimrc"
readonly VIMRC="$VIMDIR/vimrc"

readonly LINKVIMRC="$HOMEDIR/.vimrc"
create_link "$VIMRC" "$LINKVIMRC"

readonly XDGCONFIGDIR="$HOMEDIR/.config"
readonly LINKXDGCONFIG="$XDGCONFIGDIR/nvim"

if [ ! -d "$XDGCONFIGDIR" ]; then
  mkdir "$XDGCONFIGDIR"
fi
create_link "$VIMDIR" "$LINKXDGCONFIG"

readonly LINKVIM="$HOMEDIR/.vim"
create_link "$VIMDIR" "$LINKVIM"

# Shell
#-----------------------------------------------------------------------------
readonly OMZDIR="$HOMEDIR/.oh-my-zsh"
readonly OMZTHEMEDIR="$OMZDIR/themes"
if [ ! -d "$OMZTHEMEDIR" ]; then
  echo "Installation of `oh-my-zsh` is required." 1>&2
  exit
fi

readonly OMZTHEME="$ROOTDIR/configs/obaland.zsh-theme"
readonly LINKOMZTHEME="$OMZTHEMEDIR/obaland.zsh-theme"
create_link "$OMZTHEME" "$LINKOMZTHEME"

readonly ZSHRC="$ROOTDIR/configs/zshrc"
readonly LINKZSHRC="$HOMEDIR/.zshrc"
create_link "$ZSHRC" "$LINKZSHRC"

# zsh plugin manager
readonly ZPLUG="$HOMEDIR/.zplug"
if [ ! -d "$ZPLUG" ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

#readonly ZSHPLUGINS="$HOMEDIR/.oh-my-zsh/custom/plugins"
#
#readonly ZSH_PLUGIN_AUTOSUGGESTIONS_NAME="zsh-autosuggestions"
#readonly ZSH_PLUGIN_AUTOSUGGESTIONS_PATH="$ZSHPLUGINS/zsh-autosuggestions"
#if [ ! -d "$ZSH_PLUGIN_AUTOSUGGESTIONS_PATH" ]; then
#  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_PLUGIN_AUTOSUGGESTIONS_PATH"
#else
#  echo "'$ZSH_PLUGIN_AUTOSUGGESTIONS_NAME' alreay exists." 1>&2
#fi

# tmux
#-----------------------------------------------------------------------------
readonly TMUX="$HOMEDIR/.tmux"
if [ ! -d "$TMUX" ]; then
  git clone https://github.com/gpakosz/.tmux.git "$TMUX"
  create_link "$TMUX/tmux.conf" "$HOMEDIR/.tmux.conf"
fi

readonly TMUXTMP="$TMUX/plugins/tpm"
if [ ! -d "$TMUXTMP" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TMUXTMP"
fi

readonly TMUXCONF="$ROOTDIR/configs/tmux.conf"
readonly LINKTMUXCONF="$HOMEDIR/.tmux.conf.local"
create_link "$TMUXCONF" "$LINKTMUXCONF"

# Application
#-----------------------------------------------------------------------------
# Karabiner for macOS
if [ "$(uname)" = "Darwin" ]; then
  readonly KARABINER="karabiner-for-vim.json"
  readonly KARABINER_SRCPATH="${ROOTDIR}/configs/${KARABINER}"
  readonly KARABINER_DESTDIR="${HOMEDIR}/.config/karabiner/assets/complex_modifications"
  readonly KARABINER_LINKPATH="${KARABINER_DESTDIR}/${KARABINER}"

  if [ -d "$KARABINER_DESTDIR" ]; then
    create_link "$KARABINER_SRCPATH" "$KARABINER_LINKPATH"
  else
    echo "[ERROR] Require karabiner-elements. (Please install [brew install --cask karabiner-elements])" 1>&2
  fi
fi

echo "Done [Install environment]"
