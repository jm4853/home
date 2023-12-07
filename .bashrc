# Minecraft Font (Install on windows then select in terminal settings)
# https://github.com/IdreesInc/Monocraft/releases
# Hezekiah Font
# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
# LSP more color highlights nvim
# https://github.com/nvim-treesitter/nvim-treesitter
# gruv box theme
# https://github.com/morhetz/gruvbox

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
HISTSIZE=100000000
HISTFILESIZE=100000000
HISTTIMEFORMAT="[%F %T] "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

# Add ~/tools to PATH
export PATH="$PATH:$HOME/tools:$HOME/bin"

# To generate RGB color escape codes, use "\033[38;2;{r};{g};{b}m" (WONT WORK IN TMUX, depending on version)
# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797

BLUE="\[\033[38;5;27m\]"
RED="\[\033[38;5;196m\]"
ORANGE="\[\033[38;5;208m\]"
CYAN="\[\033[38;5;37m\]"
PURPLE="\[\033[38;5;91m\]"
WHITE="\[\033[38;5;15m\]"
GRAY="\[\033[38;5;241m\]"
BLACK="\[\033[38;5;0m\]"
TEXT_RESET="\[\033[00m\]"

# get current branch in git repo
function parse_git_branch() {
    v=$?
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        echo -e " \033[38;5;37m[\033[38;5;241m${BRANCH}${STAT}\033[38;5;37m]"
    else
        echo ""
    fi
    exit $v


# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

function ret_val() {
    v=$?
    if [ "$v" -ne "0" ]; then
        echo -ne "\033[38;5;196m"
        if [ "$v" -ne "130" ]; then
            echo -e "$v"
        fi
    fi
}

function _dir_chomp () {
    rv=$?
    local p=${1/#$HOME/\~} b s
    s=${#p}
    while [[ $p != "${p//\/}" ]]&&(($s>$2))
    do
        p=${p#/}
        [[ $p =~ \.?. ]]
        b=$b/${BASH_REMATCH[0]}
        p=${p#*/}
        ((s=${#b}+${#p}))
    done
    echo -e "${b/\/~/\~}${b+/}$p"
    exit $rv
}


dir_str='$(_dir_chomp "$(pwd)" 36)'
export PS1="${CYAN}[${PURPLE}\t${CYAN}] ${WHITE}${dir_str}\`parse_git_branch\` ${PURPLE}\`ret_val\`> ${TEXT_RESET}"
