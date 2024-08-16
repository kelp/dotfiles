# kelp's Fish Config
#

# Config for only interactie shells
if status is-interactive
    # Bootstrap fisher https://github.com/jorgebucaran/fisher
    if not functions -q fisher
        set -q XDG_CONFIG_HOME
        or set XDG_CONFIG_HOME ~/.config
        curl https://git.io/fisher --create-dirs -sLo \
            $XDG_CONFIG_HOME/fish/functions/fisher.fish
        echo "fisher installed, you may need to restart this shell to use it"
    end

    if [ -f $HOME/.work/work.fish ]
        source $HOME/.work/work.fish
    end

    # disable the theme greeting
    function fish_greeting
        set_color normal
    end

    # I have a local motd generated by a systemd timer or a cron as my user
    # if it exists, we'll cat it on interactive login shells.
    function motd
        if status is-interactive && status is-login
            set MOTD $HOME/.config/motd/motd
            if [ -f $MOTD ]
                cat $MOTD
            end
        end
    end

    # If we're inside tmux
    if set -q TMUX
        set -x SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock
    end

    # trying out atuin everywhere
    atuin init fish | source

    # OS specific Configs
    set -x OS (uname -s)

    switch $OS
        case Darwin
            motd
			set -x PATH	$HOME/.ps-toolbox/bin /opt/homebrew/bin /opt/homebrew/sbin $PATH

			if test -d (brew --prefix)"/share/fish/completions"
				set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
			end
			if test -d (brew --prefix)"/share/fish/vendor_completions.d"
				set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
			end
        case FreeBSD
            set -x CLICOLOR
            alias ls='ls -hF'
            motd
        case Linux
            if set -q DESKTOP_SESSION
                set -gx SSH_AUTH_SOCK (gnome-keyring-daemon --start | \
                    awk -F "=" '$1 == "SSH_AUTH_SOCK" { print $2 }')
            end
            if [ -n "$SSH_CONNECTION" ]
                set -x PINENTRY_USER_DATA "USE_CURSES=1"
            end
            # Disable the systemd pager by default, I find it more
            # irritating than helpful.
            set -x SYSTEMD_PAGER ''
            alias ls='ls -hF --color'
            motd
        case OpenBSD
            set -x MANPATH :$HOME/man
            # I prefer gnu dircolors, this gets close :/
            set -x CLICOLOR
            alias ls='colorls -hF'
            alias gpg='gpg2'
            # If we have a local reposync mirror use it.
            if [ -d /home/cvs ]
                set -x CVSROOT /home/cvs
            else
                set -x CVSROOT two.plek.org:/home/cvs
            end
            motd
        case '*'
            echo "I don't know what OS this is"
    end

    set -x EDITOR "nvim"
    set -x VISUAL "$EDITOR"
    set -x MYVIMRC "$HOME/.config/nvim/init.lua"
    set -x ELECTRON_TRASH "trash-cli code"
    set -x TZ 'America/Los_Angeles'

    set -x npm_config_prefix $HOME/.node_modules
    fish_vi_key_bindings
end

# Global configs for interactive and non-interactive shells

set -x PATH $HOME/bin $HOME/.node_modules/bin $HOME/go/bin \
	/usr/local/sbin $HOME/.cargo/bin $PATH

set -x LSCOLORS 'exgxfxdxcxegedabagacad'

# Global aliases
alias python="python3"
alias pip="pip3"
alias pydoc="pydoc3"
alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotls='dot ls-tree --full-tree -r --name-only HEAD'
alias vim='nvim'

if command -sq nvim
    alias vi='nvim'
    alias view='nvim -R'
end
if command -sq doas
    alias sudo='doas'
else if command -sq sudo
    alias doas='sudo'
end
if command -sq neomutt
    alias mutt='neomutt'
end
if command -sq openrsync
    alias rsync='openrsync'
end

# Convenience functions for OpenBSD and FreeBSD
function port ()
    if test (count $argv -gt 1)
        printf "%s\n" (_ "Too many args for port command")
        return 1
    end
    cd /usr/ports/*/$argv || cd /usr/ports/*/*/$argv || return 1
end

function src ()
    cd /usr/src/*/$argv || return
end

function fish_title
    set -q argv[1]; or set argv fish
    # Looks like ~/d/fish: git log
    # or /e/apt: fish
    if set -q SSH_TTY
        echo $USER@(hostname -s) (fish_prompt_pwd_dir_length=1 prompt_pwd): $argv;
    else
        echo (fish_prompt_pwd_dir_length=1 prompt_pwd): $argv;
    end
end


