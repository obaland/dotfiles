#!/bin/sh

create_link() {
  if [ -e $2 ]; then
    unlink $2
  fi
  ln -s $1 $2
  echo "create link: $1 -> $2"
}

readonly ROOTDIR=$(cd $(dirname $0) && pwd)

echo "Start [Install environment] ..."

###########################################################
# Vim or Neovim
###########################################################
readonly VIMDIR="$ROOTDIR/vimrc"
readonly VIMRC="$VIMDIR/vimrc"
readonly HOMEDIR=$(cd ~ && pwd)

readonly LINKVIMRC="$HOMEDIR/.vimrc"
create_link $VIMRC $LINKVIMRC

readonly XDGCONFIGDIR="$HOMEDIR/.config"
readonly LINKXDGCONFIG="$XDGCONFIGDIR/nvim"

if [ ! -d ${XDGCONFIGDIR} ]; then
  mkdir ${XDGCONFIGDIR}
fi
create_link $VIMDIR $LINKXDGCONFIG

readonly LINKVIM="$HOMEDIR/.vim"
create_link $VIMDIR $LINKVIM

###########################################################
# Shell
###########################################################
readonly CONFIGDIR="$ROOTDIR/configs"

readonly ZSHRC="$CONFIGDIR/zshrc"
readonly LINKZSHRC="$HOMEDIR/.zshrc"
create_link $ZSHRC $LINKZSHRC

readonly TMUXCONF="$CONFIGDIR/tmux.conf"
readonly LINKTMUXCONF="$HOMEDIR/.tmux.conf"
create_link $TMUXCONF $LINKTMUXCONF

###########################################################
# Application
###########################################################
# Karabiner for macOS
if [ "$(uname)" = "Darwin" ]; then
  readonly KARABINER="karabiner-for-vim.json"
  readonly KARABINER_SRCPATH="${CONFIGDIR}/${KARABINER}"
  readonly KARABINER_DESTDIR="${HOMEDIR}/.config/karabiner/assets/complex_modifications"
  readonly KARABINER_LINKPATH="${KARABINER_DESTDIR}/${KARABINER}"

  if [ -d ${KARABINER_DESTDIR} ]; then
    create_link $KARABINER_SRCPATH $KARABINER_LINKPATH
  else
    echo "[ERROR] Require karabiner-elements. (Please install [brew install --cask karabiner-elements])" 1>&2
  fi
fi

echo "Done [Install environment]"
