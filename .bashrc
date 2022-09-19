#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# aliases
alias sudo='sudo '
alias please='sudo'

alias ls='ls --color=auto'
alias la='ls -lAh'
alias ll='ls -lh'
alias tree='tree -C'

alias df='df -H'

alias heat='watch -d sensors'
alias sysup='sudo pacman -Syu; paru -Syu;echo -e "\nremember to manually recompile xmonad"'

alias clear='clear; startScript'

alias config='/usr/bin/git --git-dir=/home/jade/.dotfilecfg/ --work-tree=/home/jade'


PS1='\e[32m(\u \A \w) λx. \e[34m'
PS0='\e[m'

# greeting
startScript () {
  lCalculus () {
    array=(
      "λx. x"
      "λx. λy. x"
      "λx. λy. y"
      "λf. (λx. (f x x)) (λx. (f x x))"
      "λf. λx. (f x)"
    )
    size=${#array[@]}
    index=$(($RANDOM % $size))
    echo ${array[$index]}
  }

  echo -e "\e[35m\e[1m($(lCalculus))\e[m\n\n"
}

[ -f "/home/jade/.ghcup/env" ] && source "/home/jade/.ghcup/env" # ghcup-env

export GTK_THEME=Adwaita:dark

startScript
