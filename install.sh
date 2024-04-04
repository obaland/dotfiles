#!/bin/sh

# Usage: install.sh [type]
#   <type>
#     all: Installed all.
#     vim: Installed related to vim.
#     shell: Installed related to shell.
#     app: Installed related to app.

create_link() {
  if [ -e $2 ]; then
    rm -f $2
  fi
  ln -s $1 $2
  echo "create link: $1 -> $2"
}

TYPE=all
if [ -n "$1" ]; then
  if [ $1 = "all" ] || [ $1 = "vim" ] || [ $1 = "shell" ] || [ $1 = "app" ]; then
    TYPE=$1
  else
    echo "Type '$1' is not supported."
    exit
  fi
fi

readonly ROOTDIR=$(cd $(dirname $0) && pwd)
readonly HOMEDIR=$(cd ~ && pwd)

echo "Start [Install environment] ..."

###########################################################
# Vim or Neovim
###########################################################
if [ $TYPE = "all" ] || [ $TYPE = "vim" ]; then
  readonly VIMDIR="$ROOTDIR/vimrc"
  readonly VIMRC="$VIMDIR/vimrc"

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
fi

###########################################################
# Shell
###########################################################
if [ $TYPE = "all" ] || [ $TYPE = "shell" ]; then
  readonly OMZDIR="$HOMEDIR/.oh-my-zsh"
  readonly OMZTHEMEDIR="$OMZDIR/themes"
  if [ ! -d $OMZTHEMEDIR ]; then
    echo "Installation of `oh-my-zsh` is required." 1>&2
    exit
  fi

  readonly OMZTHEME="$ROOTDIR/configs/obaland.zsh-theme"
  readonly LINKOMZTHEME="$OMZTHEMEDIR/obaland.zsh-theme"
  create_link $OMZTHEME $LINKOMZTHEME

  readonly ZSHRC="$ROOTDIR/configs/zshrc"
  readonly LINKZSHRC="$HOMEDIR/.zshrc"
  create_link $ZSHRC $LINKZSHRC

  readonly TMUXCONF="$ROOTDIR/configs/tmux.conf"
  readonly LINKTMUXCONF="$HOMEDIR/.tmux.conf"
  create_link $TMUXCONF $LINKTMUXCONF
fi

###########################################################
# Application
###########################################################
if [ $TYPE = "all" ] || [ $TYPE = "app" ]; then
  # Karabiner for macOS
  if [ "$(uname)" = "Darwin" ]; then
    readonly KARABINER="karabiner-for-vim.json"
    readonly KARABINER_SRCPATH="${ROOTDIR}/configs/${KARABINER}"
    readonly KARABINER_DESTDIR="${HOMEDIR}/.config/karabiner/assets/complex_modifications"
    readonly KARABINER_LINKPATH="${KARABINER_DESTDIR}/${KARABINER}"

    if [ -d ${KARABINER_DESTDIR} ]; then
      create_link $KARABINER_SRCPATH $KARABINER_LINKPATH
    else
      echo "[ERROR] Require karabiner-elements. (Please install [brew install --cask karabiner-elements])" 1>&2
    fi
  fi
fi

echo "Done [Install environment]"
