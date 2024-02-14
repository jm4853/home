# Dont do anything if shell isnt interactive
case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth

shopt -s histappend

HISTSIZE=100000000
HISTFILESIZE=100000000
HISTTIMEFORMAT="[%F %T] "

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# aliases defined in ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable autocomplete
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add to PATH
for pdir in "$HOME/tools" \
            "$HOME/bin"
do
  if ! [[ "$PATH" =~ (^|:)"$pdir"(:|$) ]]
  then
      export PATH="$PATH:$pdir"
  fi
done

BLUE="\001\033[38;5;27m\002"
RED="\001\033[38;5;196m\002"
ORANGE="\001\033[38;5;208m\002"
CYAN="\001\033[38;5;37m\002"
PURPLE="\001\033[38;5;91m\002"
WHITE="\001\033[38;5;15m\002"
GREY="\001\033[38;5;241m\002"
BLACK="\001\033[38;5;0m\002"
TEXT_RESET="\001\033[00m\002"

function parse_git_branch() {
    # Let command line return value "pass through" the function
    rv=$?
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        echo -ne " ${CYAN}[${GREY}${BRANCH}${STAT}${CYAN}]"
    else
        echo ""
    fi
    exit $rv
}

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
    echo -e "${b/\/~/~}${b+/}$p"
    exit $rv
}

function _my_pwd () {
    rv=$?
    pwd
    exit $rv
}

function ret_val() {
    v=$?
    if [ "$v" -ne "0" ]; then
        echo -ne "${RED}"
        if [ "$v" -ne "130" ]; then
            echo -e "$v"
        fi
    fi
}


dir_str='$(_dir_chomp "$(_my_pwd)" 36)'
export PS1="${CYAN}[${PURPLE}\t${CYAN}] ${WHITE}${dir_str}\`parse_git_branch\` ${PURPLE}\`ret_val\`> ${TEXT_RESET}"

