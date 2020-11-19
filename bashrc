# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
hsts=0

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  screen.linux|screen|xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
    else
  color_prompt=
    fi
fi




if [ "$color_prompt" = yes ]; then
  PROMPT_COMMAND=prompt_command
  trap 'timer_start' DEBUG

  function git-path() {
    repo=$(basename `git rev-parse --show-toplevel`)
    path=$(git rev-parse --show-prefix)
    if [ -z "$path" ]; then
      echo -n "$repo"
    else
      path=${path::-1}
      echo -n "$repo/$path"
    fi
  }

  function timer_start {
    timer_start=${timer_start:-$(timer_now)}
  }

  function timer_stop {
    local delta_us=$((($(date +%s%N) - $timer_start) / 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 3600000000))
    # Goal: always show around 3 digits of accuracy
    if ((h > 0)); then timer_show=${h}h${m}m
    elif ((m > 0)); then timer_show=${m}m${s}s
    elif ((s > 0)); then timer_show="$s"s
    else timer_show=""
    fi
    unset timer_start
  }

  function timer_now {
    date +%s%N
  }

  function prompt_command() {
    local EXIT="$?"
    timer_stop
    PS1="\[\e[0m\]\n"
    if [[ ("$EUID" -eq 0) || ("$USER" -ne "jules") ]]; then
      PS1+="\[\e[01;31m\]\u \[\e[0m\]"
      if  [[ ($(hostname) ==   *"instance"*) || ($(hostname) == *"server"*) ]]; then
        PS1+="at "
      else
        PS1+="in "
      fi
    fi
    if  [[ ($(hostname) ==   *"instance"*) || ($(hostname) == *"server"*) ]]; then
      PS1+="\[\e[34;1m\]\h \[\e[0m\]in "
    fi
    PS1+="\[\e[01;36m\]"
    isGit=$(git rev-parse --is-bare-repository 2>&1)
    if [ "$isGit" == "false" ]; then
      PS1+="$(git-path)\[\e[0m\] on \[\e[35;1m\]$(git symbolic-ref --short HEAD)"
      state=""
      # ⎇
      if [ "$(git diff --cached)" != "" ]; then state+="+"; fi
      if ! git diff-files --quiet --ignore-submodules -- ;then state+="*"; fi

      if [ "$(git ls-files -o --directory --exclude-standard)" != "" ]; then state+="?";fi
      if [ "$(git remote)" != "" ]; then
        unpush=$(git log --branches --not --remotes --format=format:'*')
        unpushnb=${#unpush}

        if [ "$unpushnb" != "0" ]; then state+="↑$unpushnb"; fi
      fi
      if [ "$state" != "" ];then
        PS1+="\[\e[01;31m\] [$state]"
      fi
   else
      PS1+="\w"
    fi;
    if [ "$timer_show" != "" ]; then
      PS1+="\[\e[0m\] took \[\e[01;33m\]$timer_show";
    fi
    PS1+="\n"
    if [ $EXIT -eq 0 ]; then
      PS1+="\[\e[01;32m\]"
    else
      PS1+="\[\e[01;31m\]"
    fi;
    PS1+="❱\[\e[0m\] "

  }

  PS2="\[\e[0m\]❱\[\e[0m\] "

else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto -A'
  alias ll='ls --color=auto -Al'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
alias code='/mnt/c/Users/Jules/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
