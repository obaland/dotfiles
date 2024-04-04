#####################################################################
# environment
#####################################################################

export TERM='xterm-256color'

export LANG=ja_JP.UTF-8

# for Vim/Neovim
if [ -d ~/.config ] ; then
  export XDG_CONFIG_HOME=$(cd ~/.config; pwd)
fi

# Rust
if [ -d ~/.cargo ] ; then
  export PATH="$(cd ~/.cargo/bin; pwd):$PATH"
fi

# os
os_type=''
case ${OSTYPE} in
  darwin*)
    os_type='mac'
    ;;
  linux*)
    if uname -r | grep -i 'microsoft' > /dev/null; then
      # Windows Subsystem for Linux
      os_type='windows'
    else
      os_type='linux'
    fi
    ;;
esac

case ${os_type} in
  'linux')
    export EDITOR=vim
    ;;
  'mac')
    export EDITOR=nvim
    # For macOS, the brew installation location is preferred.
    export PATH=/usr/local/bin:$PATH
    ;;
  *)
    export EDITOR=nvim
esac

#####################################################################
# completions
#####################################################################

# Enable completions
autoload -U compinit
compinit

#####################################################################
# colors
#####################################################################

# Use prompt colors feature
autoload -U colors
colors

# Color settings for zsh complete candidates
if [ ${os_type} = 'mac' ] ; then
  alias la='ls -a'
  alias ll='ls -l'
else
  alias ls='ls --color=always'
  alias la='ls -a --show-control-chars --color=always'
  alias ll='ls -l --show-control-chars --color=always'
fi

export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30'
if [ ${os_type} = 'windows' ] ; then
  LS_COLORS="${LS_COLORS}:ow=34"
else
  LS_COLORS="${LS_COLORS}:ow=43;30"
fi
export LS_COLORS

# Use vcs_info
autoload -Uz vcs_info

# Bind keys (vi mode)
bindkey -v

# prompt
##RPROMPT="%{$fg[cyan]%}%D{%Y/%m/%d} %*"

function zle-keymap-select zle-line-init zle-line-finish {
  reset="%{$reset_color%}"
  case $KEYMAP in
    main|viins)
      mode="[%{$fg[green]%}INSERT$reset]"
      ;;
    vicmd)
      mode="[%{$fg[blue]%}NORMAL$reset]"
      ;;
    vivis|vivli)
      mode="[%{$fg[yellow]%}VISUAL$reset]"
      ;;
    *)
      mode=''
      ;;
  esac

  PROMPT="%F{cyan}❯❯ %n@%m:%F{green}%~$reset
$mode$reset%# "
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# TODO: setting vcs_info
