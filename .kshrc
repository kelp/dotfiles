[[ -f /etc/ksh.kshrc ]] && . /etc/ksh.kshrc


light_green="\[\e[1;32m\]"
light_red="\[\e[1;31m\]"
blue="\[\e[0;34m\]"
ul_blue="\[\e[4;34m\]"
bright_blue="\[\e[38;5;33m\]"
yellow="\[\e[0;33m\]"
gray="\[\e[0;37m\]"
gray_bg="\[\e[48;5;235m\]"
gray_fg="\[\e[38;5;235m\]"
reset="\[\e[m\]"

EDITOR="nvim"
LSCOLORS="exgxfxdxcxegedabagacad"
TZ="American/Los_Angeles"
VISUAL="nvim"
PS1="$gray_bg$bright_blue \w $reset$gray_fg$reset "

DEVPATH=$HOME/.node_modules/bin:$HOME/go/bin:$HOME/.cargo/bin

PATH=$HOME/bin:$DEVPATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games

export EDITOR HOM LSCOLORS PATH PS1 TZ TERM VISUAL

alias df='df -h'
alias du='du -h'
alias ls='colorls -GF'
alias vi=nvim
alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotls='dot ls-tree --full-tree -r --name-only HEAD'

src() {
	cd /usr/src/*/$1 || return
}

port() {
	cd /usr/ports/*/$1 2>/dev/null || \
		cd /usr/ports/*/*/$1 2>/dev/null || \
		return
}

if [ -e ~/.ksh_completions ]; then
	. ~/.ksh_completions
fi
