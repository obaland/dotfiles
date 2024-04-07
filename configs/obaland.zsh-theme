# Identification vriables
OS=$(grep '^ID=' /etc/os-release | cut -d'=' -f2)

# Color palette
color_bg='236'
color_black='232'
color_fg='189'
color_fg_dark='149'
color_fg_gutter='60'
color_dark3='102'
color_blue0='16'
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
color_git='75'
color_git_dirty='204'

COLOR_VI_MODE_INSERT='150'

# Special characters
LSEP_CHAR='\ue0b0'
RSEP_CHAR='\ue0b2'
SEPSUB_CHAR='\u258c'

CURRENT_BG='none'
CURRENT_FG='none'

# For git plugin
ZSH_THEME_GIT_PROMPT_CLEAN=''
ZSH_THEME_GIT_PROMPT_DIRTY='\uf069'

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

# git utilities
#-----------------------------------------------------------------------------
function in_git() {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
  return $?
}

function git_staging_changed() {
  local staged_changes=$(git diff --cached --numstat | wc -l)
  echo $staged_changes
}

function git_working_changed() {
  local working_changes=$(git diff --numstat | wc -l)
  echo $working_changes
}

function git_stash_count() {
  local stash_count=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
  echo $stash_count
}

function git_ahead() {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  local upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
  if [[ -n "$upstream" ]]; then
    local ahead_count=$(git rev-list --count ${branch}..${upstream})
    echo $ahead_count
  fi
}

function git_behind() {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  local upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
  if [[ -n "$upstream" ]]; then
    local behind_count=$(git rev-list --count ${upstream}..${branch})
    echo $behind_count
  fi
}

# Segment utilities
#-----------------------------------------------------------------------------
function segment_begin() {
  local bg=$( [[ -n $1 ]] && echo $1 || echo $CURRENT_BG )
  local fg=$( [[ -n $2 ]] && echo $2 || echo $CURRENT_FG )
  CURRENT_BG=$bg
  CURRENT_FG=$fg
  echo -n "%K{$bg}%F{$fg}"
}

function segment_end() {
  echo -n "%f%k"
}

function block() {
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

function lseparator_begin() {
  echo -n "%S%K{reset}%F{$1}$LSEP_CHAR %f%k%s"
}

function lseparator_end() {
  local fg=$( [[ -n $1 ]] && echo $1 || echo $CURRENT_BG)
  block $LSEP_CHAR reset $fg
}

function rseparator_begin() {
  local fg=$( [[ -n $1 ]] && echo $1 || echo $CURRENT_BG)
  block $RSEP_CHAR reset $fg
}

function rseparator_end() {
  local bg=$( [[ -n $1 ]] && echo $1 || echo $CURRENT_FG)
  local fg=$( [[ -n $2 ]] && echo $2 || echo $CURRENT_BG)
  echo -n "%K{$bg}%F{$fg}$RSEP_CHAR%f%k"
}

function separator_sub() {
  echo -n "%S%K{reset}%F{$1} $SEPSUB_CHAR%f%k%s"
}

# Segments
#-----------------------------------------------------------------------------
function segment_os() {
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

function segment_path() {
  segment_begin $1 $2

  local dir="${(%):-%~}"
  dir="${dir/#\~/\ueb06}"
  dir="${dir//\// \u276f }"
  block "${dir} "
  segment_end
}

function segment_error() {
  segment_begin $1 $2
  block '\uf12a ERROR '
  segment_end
}

function segment_time() {
  segment_begin $1 $2
  block " %* "
  segment_end
}

function segment_host() {
  segment_begin $1 $2
  block " %M"
  segment_end
}

function segment_user() {
  segment_begin $1 $2
  block " %n"
  segment_end
}

function segment_git() {
  local dirty="$(parse_git_dirty)"
  local bg=$color_git
  if [[ -n $dirty ]]; then
    bg=$color_git_dirty
  fi
  rseparator_begin $bg
  segment_begin $bg $color_black
  block " \ue725 $(git_current_branch) "

  local working="$(git_working_changed)"
  local staging="$(git_staging_changed)"
  local stash="$(git_stash_count)"
  if [[ -n "$staging" && "$staging" != 0 ]]; then
    block "\ue621"
    block "\uf046 $staging "
  fi
  if [[ -n "$working" && "$working" != 0 ]]; then
    block "\ue621"
    block "\uf044 $working "
  fi
  if [[ -n "$stash" && "$stash" != 0 ]]; then
    block "\ue621"
    block "\ueb4b $stash "
  fi

  segment_end
  rseparator_end $bg $color_bg
}

function segment_prompt() {
  local icon fg
  if [[ $UID -eq 0 ]]; then
    #icon='\uf0423 '
    icon='\uf0633 '
    fg=$color_orange
  else
    icon='\u276f '
    fg=$color_fg
  fi
  segment_begin reset $fg
  block $icon
  segment_end
}

# NOTE: Depends on `zsh-vim-mode` plugin.
function segment_vimmode() {
  local fg mode
  case $VI_KEYMAP in
    main|viins)
      mode='I'
      fg=$COLOR_VI_MODE_INSERT
      ;;
    vicmd)
      mode='N'
      fg=$color_orange
      ;;
    command)
      mode='C'
      fg=$color_orange
      ;;
    isearch)
      mode='S'
      fg=$color_violet
      ;;
    visual)
      mode='V'
      fg=$color_magenta
      ;;
    viopp)
      mode='P'
      fg=$color_gray
      ;;
    *)
      mode=''
      fg=$color_fg
      ;;
  esac

  segment_begin reset $fg
  block "\uf069 $mode "
  segment_end
}

# Events
#-----------------------------------------------------------------------------
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


# Prompt
#-----------------------------------------------------------------------------
function prompt() {
  segment_vimmode
  segment_prompt
}

function prompt_left() {
  RESULT=$?
  segment_os $color_fg
  lseparator_end
  lseparator_begin $color_bg
  segment_path $color_bg $color_fg
  lseparator_end

  if [[ $RESULT -ne 0 ]]; then
    lseparator_begin $color_red1
    segment_error $color_red1 $color_black
    lseparator_end
  fi
}

function prompt_right() {
  if in_git; then
    segment_git $color_bg $color_fg
  else
    rseparator_begin $color_bg
  fi
  segment_user $color_bg $color_blue
  separator_sub $color_bg
  segment_host $color_bg $color_blue
  separator_sub $color_bg
  segment_time $color_bg $color_green
}

setopt PROMPT_SUBST

RPROMPT='$(prompt_right)'
PROMPT='$(prompt_left)
$(prompt)'

# vim:ft=zsh ts=2 sw=2 sts=2
