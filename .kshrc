[[ -f /etc/ksh.kshrc ]] && . /etc/ksh.kshrc

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

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
TZ="US/Pacific"
VISUAL="nvim"
HISTFILE=~/.ksh_history
HISTSIZE=1000
OS=$(uname)

set -o vi

LPREFIX=/usr/local

if [ "$OS" = "OpenBSD" ]; then
	if [ ! -f ~/.cvsrc ]; then
		export CVSROOT="anoncvs@anoncvs4.usa.openbsd.org:/cvs"
	fi
else
	LPREFIX=/usr
fi

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
white_bg="\[\e[48;5;255m\]"
white_fg="\[\e[38;5;255m\]"
blue_fg="\[\e[38;5;75m\]"
grey_bg="\[\e[48;5;239m\]"
grey_fg="\[\e[38;5;239m\]"
reset="\[\e[m\]"
prompt=""

# TODO Set term to ansi on OpenBSD to get colors
# If we're using ansi, use 8 bit colors.
if [ $TERM = "vt220" ]; then
	prompt="\$"
	export TERM=ansi
fi
# Show user@host if we're on a remote ssh session.
if [ "$SSH_CONNECTION" ]; then
	ssh_prompt="${white_bg} ${blue_fg}\u@\h ${grey_bg}${white_fg}${prompt}"
fi

PS1="${grey_bg}${bright_blue}${ssh_prompt} \w $reset$grey_fg$prompt$reset "

alias df='df -h'
alias du='du -h'
alias ls='colorls -GF'
alias view='nvim -R'
alias vi=nvim
alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotls='dot ls-tree --full-tree -r --name-only HEAD'
alias mutt='neomutt'

# TODO make this do something nicer
cd() { command cd "$@"; echo -ne "\033]0;${PWD##*/}\007"; }

src() {
	cd /usr/src/*/$1 || return
}

port() {
	cd /usr/ports/*/$1 2>/dev/null || \
		cd /usr/ports/*/*/$1 2>/dev/null || \
		return
}

if [ -e ${LPREFIX}/bin/keychain ]; then
	${LPREFIX}/bin/keychain --gpg2 --inherit any --agents ssh,gpg -q -Q
	keychain_conf="$HOME/.keychain/$(uname -n)-sh"

	[ -e "${keychain_conf}" ] && . ${keychain_conf}

	[ -e "${keychain_conf}-gpg" ] && . ${keychain_conf}-gpg
fi

if [ -e ~/.ksh_completions ]; then
	. ~/.ksh_completions
fi

export EDITOR HISTFILE HISTSIZE HOME LSCOLORS PATH PS1 TERM TZ VISUAL
