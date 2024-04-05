CURRENT_BG='none'
CURRENT_FG='none'

# Color palette
color_bg='236'
color_black='232'
color_fg='189'
color_fg_dark='149'
color_fg_gutter='60'
color_dark3='102'
color_blue0='59'
color_blue='111'
color_cyan='117'
color_blue1='80'
color_blue2='44'
color_blue5='153'
color_blue6='195'
color_blue7='60'
color_blue8='110'
color_blue9='103'
color_blue10='103'
color_magenta='183'
color_magenta2='198'
color_purple='140'
color_orange='216'
color_orange1='166'
color_yellow='180'
color_green='150'
color_green1='116'
color_green2='74'
color_green3='73'
color_green4='66'
color_teal='79'
color_red='160'
color_red1='167'
color_git='236'
color_git_dirty='52'

left_sep='\ue0b0'
right_sep='\ue0b2'

# Identification OS
OS=$(grep '^ID=' /etc/os-release | cut -d'=' -f2)

# git utilities
in_git() {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
  return $?
}

get_git_branch() {
  echo $(git branch --show-current 2>/dev/null)
}

is_git_dirty() {
  ! git diff --quiet 2>/dev/null
}

is_git_untracked() {
  [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]
}

is_git_added() {
  ! git diff --cached --quiet 2>/dev/null
}

is_git_modified() {
  [[ -n $(git ls-files --modified 2>/dev/null) ]]
}

is_git_deleted() {
  [[ -n $(git ls-files --deleted 2>/dev/null) ]]
}

is_git_renamed() {
  [[ -n $(git ls-files --others --exclude-standard 2>/dev/null | git diff --name-only --diff-filter=R 2>/dev/null) ]]
}

is_git_unmerged() {
  ! git ls-files --unmerged --error-unmatch . 2>/dev/null >/dev/null
}

# Segment utilities
segment_begin() {
  local bg=$( [[ -n $1 ]] && echo $1 || echo $CURRENT_BG )
  local fg=$( [[ -n $2 ]] && echo $2 || echo $CURRENT_FG )
  CURRENT_BG=$bg
  CURRENT_FG=$fg
  echo -n "%K{$bg}%F{$fg}"
}

segment_end() {
  echo -n "%f%k"
}

block() {
  local bg_begin bg_end
  local fg_begin fg_end

  if [[ -n $2 && $2 != $CURRENT_BG ]]; then
    bg_begin="%K{$2}"
    bg_end="%k"
    CURRENT_BG=$2
  fi
  if [[ -n $3 && $3 != $CURRENT_FG ]]; then
    fg_begin="%F{$3}"
    fg_end="%f"
    CURRENT_FG=$3
  fi

  [[ -n $1 ]] && echo -n "$bg_begin$fg_begin$1$fg_end$bg_end"
}

left_separator_begin() {
  echo -n "%S%K{reset}%F{$1}$left_sep %f%k%s"
}

left_separator_end() {
  local fg=$( [[ -n $1 ]] && echo $1 || echo $CURRENT_BG)
  block $left_sep reset $fg
}

right_separator_begin() {
  echo -n "%S%K{reset}%F{$1}$left_sep %f%k%s"
}

right_separator_end() {
  local fg=$( [[ -n $1 ]] && echo $1 || echo $CURRENT_BG)
  block $right_sep reset $fg
}

right_separator() {
  echo -n "%S%K{reset}%F{$1} \u258c%f%k%s"
}

# Segments
segment_os() {
  local bg icon
  if [[ $OS == 'ubuntu' ]]; then
    icon='\uf31b'
    bg=$color_orange1
  else
    icon='\ue712'
    bg=$color_black
  fi

  segment_begin $bg $1
  block " $icon "
  segment_end
}

segment_path() {
  segment_begin $1 $2

  local dir="${(%):-%~}"
  dir="${dir/#\~/\ueb06}"
  dir="${dir//\// \u276f }"
  block "${dir} "
  segment_end
}

segment_error() {
  segment_begin $1 $2
  block '\uf12a ERROR '
  segment_end
}

segment_time() {
  segment_begin $1 $2
  block " %* "
  segment_end
}

segment_host() {
  segment_begin $1 $2
  block " %M"
  segment_end
}

segment_user() {
  segment_begin $1 $2
  block " %n"
  segment_end
}

segment_git() {
  segment_begin $1 $2
  local bg=$1
  if is_git_dirty; then
    bg=$color_git_dirty
  fi
  block " \ue725 $(get_git_branch) " $bg
  if is_git_untracked; then
    block "\uf128 " $bg
  fi
  if is_git_added; then
    block "\uf067 " $bg
  fi
  if is_git_modified; then
    block "\ueade " $bg
  fi
  if is_git_renamed; then
    block "\ueae0 " $bg
  fi
  if is_git_deleted; then
    block "\uf00d " $bg
  fi
  if is_git_unmerged; then
    block "\ue727 " $bg
  fi
  segment_end
}

segment_prompt() {
  echo -n "%#"
}

prompt_left() {
  RESULT=$?
  segment_os $color_fg
  left_separator_end
  left_separator_begin $color_blue0
  segment_path $color_blue0 $color_fg
  left_separator_end

  if [[ $RESULT -ne 0 ]]; then
    left_separator_begin $color_red1
    segment_error $color_red1 $color_black
    left_separator_end
  fi
}

prompt_right() {
  if in_git; then
    segment_git $color_git $color_fg
    block ' ' reset, reset
  fi
  segment_user $color_bg $color_blue
  right_separator $color_bg
  segment_host $color_bg $color_blue
  right_separator $color_bg
  segment_time $color_bg $color_green
}

# preexec function: An implicitly invoked builtin function in Zsh,
# executed just before a command is executed.
preexec() {
  START_TIME=$(date +%s%3N) # Record the current time in milliseconds
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

echo "$(prompt_right)"
RPROMPT='$(prompt_right)'

echo "$(prompt_left)"
PROMPT='$(prompt_left)
$(segment_prompt) '

# vim:ft=zsh ts=2 sw=2 sts=2
