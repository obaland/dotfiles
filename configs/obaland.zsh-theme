CURRENT_BG='none'
CURRENT_FG='none'

color_bg='59'
color_terminal_black="60"
color_fg="189"
color_fg_dark="149"
color_fg_gutter="60"
color_dark3="102"
color_blue0="67"
color_blue="111"
color_cyan="117"
color_blue1="80"
color_blue2="44"
color_blue5="153"
color_blue6="195"
color_blue7="60"
color_blue8="110"
color_blue9="103"
color_magenta="183"
color_magenta2="198"
color_purple="140"
color_orange="216"
color_yellow="180"
color_green="150"
color_green1="116"
color_green2="74"
color_green3="73"
color_green4="66"
color_teal="79"
color_red="211"
color_red1="167"
color_git_change="132"
color_gitSigns_change="138"

segment() {
  local bg_begin bg_end
  local fg_begin fg_end
  if [[ $1 != $CURRENT_BG ]]; then
    bg_begin="%K{$1}"
    bg_end="%k"
  fi
  if [[ $2 != $CURRENT_FG ]]; then
    fg_begin="%F{$2}"
    fg_end="%f"
  fi

  CURRENT_BG=$1
  CURRENT_FG=$2
  [[ -n $3 ]] && echo -n "%{$bg_begin$fg_begin$3$fg_end$bg_end%}"
}

segment_sep() {
  segment default $CURRENT_BG 
  segment default default 
}

segment_time() {
  echo -n "%{%*%}"
}

segment_icon() {
  segment $color_terminal_black $color_fg "  "
  #echo -n "%{%F{$color_fg}   %f%}"
}

segment_path() {
  segment 
}

prompt_left() {
  segment_icon
  segment_sep
}

prompt_right() {
  segment_time
  segment_end
}

#RPROMPT=`prompt_right`

#function zle-keymap-select zle-line-init zle-line-finish {
#  reset="%{$reset_color%}"
#  case $KEYMAP in
#    main|viins)
#      mode="[%{$fg[green]%}INSERT$reset]"
#      ;;
#    vicmd)
#      mode="[%{$fg[blue]%}NORMAL$reset]"
#      ;;
#    vivis|vivli)
#      mode="[%{$fg[yellow]%}VISUAL$reset]"
#      ;;
#    *)
#      mode=''
#      ;;
#  esac
#
##  PROMPT="%F{cyan}❯❯ %n@%m:%F{green}%~$reset
##$mode$reset%# "
#  zle reset-prompt
#}

#zle -N zle-line-init
#zle -N zle-line-finish
#zle -N zle-keymap-select

echo "$(prompt_left)"
PROMPT="$(prompt_left)"

# vim:ft=zsh ts=2 sw=2 sts=2
