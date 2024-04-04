CURRENT_BG='none'
CURRENT_FG='none'

color_bg='235'
color_fg='231'

segment() {
  local bg fg
  if [[ $1 != $CURRENT_BG ]]; then
    bg="%{%K{$1}"
  else
    bg="%k%K{$1}"
  fi
  if [[ $1 != $CURRENT_FG ]]; then
    fg="%F{$1}"
  else
    fg="%f%F{$1}"
  fi
  echo -n "$bg$fg"

  CURRENT_BG=$1
  CURRENT_FG=$2
  [[ -n $3 ]] && echo -n $3
}

segment_end() {
}

segment_time() {
  echo -n "%{%*%}"
}

segment_icon() {
  echo -n "%{%K{$color_bg}%F{%color_fg}  %k%f%}"
}

prompt_left() {
  segment_icon
}

prompt_right() {
  segment_time
  segment_end
}

#RPROMPT=`prompt_right`

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

  #PROMPT="$(prompt_left)"
  PROMPT="%F{cyan}❯❯ %n@%m:%F{green}%~$reset
$mode$reset%# "
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# vim:ft=zsh ts=2 sw=2 sts=2
