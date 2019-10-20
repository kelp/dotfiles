[[ -f /etc/ksh.kshrc ]] && . /etc/ksh.kshrc

# Sets extra paths
set -A paths /usr/games \
        ~/go/bin \
        /usr/ports/infrastructure/bin \
        ~/bin \
        ~/.cargo/bin \
        ~/.node_modules/bin

for d in "${paths[@]}"; do
        [[ -d "${d}" ]] && PATH="${PATH}:$d"
done


EDITOR="nvim"
LSCOLORS="exgxfxdxcxegedabagacad"
TZ="American/Los_Angeles"
VISUAL="nvim"
HISTFILE=~/.ksh_history
HISTSIZE=1000

set -o vi

# Disabled until i figure out how to make it work with ksh
#if [ -e ~/.git-prompt ]; then
	# shellcheck source=/home/qbit/.git-prompt
#	. ~/.git-prompt
#	export GIT_PS1_SHOWDIRTYSTATE=true
#	export GIT_PS1_SHOWUNTRACKEDFILES=true
#	export GIT_PS1_SHOWCOLORHINTS=true
#	export GIT_PS1_SHOWUPSTREAM="auto"
#fi

# Colors for use in the prompt and elsewere.
gray_bg="\[\e[48;5;235m\]"
gray_fg="\[\e[38;5;235m\]"
reset="\[\e[m\]"
prompt=""
#
# TODO Set term to ansi on OpenBSD to get colors
# If we're using ansi, use 8 bit colors.
[[ $TERM = "vt220" ]] && prompt="\$"

PS1="$gray_bg$bright_blue \w $reset$gray_fg$prompt$reset "

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

export EDITOR HISTFILE HISTSIZE HOME LSCOLORS PATH PS1 TERM TZ VISUAL
