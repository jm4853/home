# Minecraft Font (Install on windows then select in terminal settings)
# https://github.com/IdreesInc/Monocraft/releases
# Hezekiah Font
# https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip

PATH="$PATH:$HOME/tools:$HOME/bin"

alias o='less'
alias v='vim'
alias l='ls -lah'
alias wbrc='vim ~/.bashrc'
alias rbrc='source ~/.bashrc'
alias wvrc='vim ~/.vimrc'
alias t='tmux'
alias tl='tmux ls'
alias ts='tmux new -s'
alias ta='tmux attach -t'
alias mv='mv -i'
alias cp='cp -i'
alias cc='cc -Wall'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias ...='../..'
alias ....='../../..'

# Get oh-my-posh working

# To generate RGB color escape codes, use "\033[38;2;{r};{g};{b}m" (WONT WORK IN TMUX, depending on version)
# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797

CURR_DIR="\w"
TIME_STR="\t"
BLUE="\[\033[38;5;27m\]"
RED="\[\033[38;5;196m\]"
CYAN="\[\033[38;5;37m\]"
PURPLE="\[\033[38;5;91m\]"
WHITE="\[\033[38;5;15m\]"
TEXT_RESET="\[\033[00m\]"

function checkReturnValue()
{
    v=$?
    if [ "$v" -ne "0" ]; then
        echo -ne "\033[38;5;196m"
        if [ "$v" -ne "130" ]; then
            echo -e "$v"
        fi
    else
        echo -e ""
    fi
}

ret_val_func='$(checkReturnValue)'
# Can implement PS0 to display after commands finish but before next prompt (depending on bash version)
# https://wiki.archlinux.org/title/Bash/Prompt_customization
PS1="${CYAN}[${PURPLE}\t${CYAN}] ${WHITE}\w ${PURPLE}${ret_val_func}> ${TEXT_RESET}"
