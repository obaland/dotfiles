# Identification vriables
OS=$(grep '^ID=' /etc/os-release | cut -d'=' -f2)

# Color palette
COLOR_BG='236'
COLOR_BLACK='232'
COLOR_FG='189'
COLOR_BLUE=111
COLOR_ORANGE='166'
COLOR_GREEN='150'
COLOR_RED='160'
COLOR_GIT='75'
COLOR_GIT_DIRTY='204'

COLOR_VI_MODE_INSERT='150' # green
COLOR_VI_MODE_VISUAL='183' # magenta
COLOR_VI_MODE_ISEARCH='140' # purple
COLOR_VI_MODE_NORMAL='216' # orange
COLOR_VI_MODE_COMMAND='180' # yellow

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
    bg=$COLOR_ORANGE
  else
    icon='\ue712'
    bg=$COLOR_BLACK
  fi

  segment_begin $bg $1
  block " $icon "
  segment_end
}

function segment_path() {
  segment_begin $1 $2

  local dir="${(%):-%~}"
  dir="${dir/#\~/\ueb06}"
  if [[ "$dir" == "/"* ]]; then
    dir="/${dir:1}"
    dir="${dir//\// \u276f }"
    dir="/ "${dir:1}
  else
    dir="${dir//\// \u276f }"
  fi
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
  local ahead="$(git_ahead)"
  local behind="$(git_behind)"
  local working="$(git_working_changed)"
  local staging="$(git_staging_changed)"
  local stash="$(git_stash_count)"
  local bg=$COLOR_GIT
  if [[ -n $working && $working != 0 || -n $staging && $staging != 0 ]]; then
    bg=$COLOR_GIT_DIRTY
  elif [[ -n $ahead && $ahead != 0 || -n $behind && $behind != 0 ]]; then
    bg=$COLOR_GIT_DIRTY
  fi
  rseparator_begin $bg
  segment_begin $bg $COLOR_BLACK
  block " \ue725 $(git_current_branch) "

  if [[ -n $staging && $staging != 0 ]]; then
    block "\ue621"
    block "\uf046 $staging "
  fi
  if [[ -n $working && $working != 0 ]]; then
    block "\ue621"
    block "\uf044 $working "
  fi
  if [[ -n $stash && $stash != 0 ]]; then
    block "\ue621"
    block "\ueb4b $stash "
  fi

  segment_end
  rseparator_end $bg $COLOR_BG
}

function segment_prompt() {
  local icon fg
  if [[ $UID -eq 0 ]]; then
    #icon='\uf0423 '
    icon='󰘳 '
    fg=$COLOR_ORANGE
  else
    icon='\u276f '
    fg=$COLOR_FG
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
      fg=$COLOR_VI_MODE_NORMAL
      ;;
    command)
      mode='C'
      fg=$COLOR_VI_MODE_COMMAND
      ;;
    isearch)
      mode='S'
      fg=$COLOR_VI_MODE_ISEARCH
      ;;
    visual)
      mode='V'
      fg=$COLOR_VI_MODE_VISUAL
      ;;
    viopp)
      mode='P'
      fg=$COLOR_FG
      ;;
    *)
      mode=''
      fg=$COLOR_FG
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
  segment_os $COLOR_FG
  lseparator_end
  lseparator_begin $COLOR_BG
  segment_path $COLOR_BG $COLOR_FG
  lseparator_end

  if [[ $RESULT -ne 0 ]]; then
    lseparator_begin $COLOR_RED
    segment_error $COLOR_RED $COLOR_BLACK
    lseparator_end
  fi
}

function prompt_right() {
  if in_git; then
    segment_git $COLOR_BG $COLOR_FG
  else
    rseparator_begin $COLOR_BG
  fi
  segment_user $COLOR_BG $COLOR_BLUE
  separator_sub $COLOR_BG
  segment_host $COLOR_BG $COLOR_BLUE
  separator_sub $COLOR_BG
  segment_time $COLOR_BG $COLOR_GREEN
}

setopt PROMPT_SUBST

RPROMPT='$(prompt_right)'
PROMPT='$(prompt_left)
$(prompt)'

# vim:ft=zsh ts=2 sw=2 sts=2
