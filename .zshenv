# Customize to your needs... 
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin 

# Employeer specific configs go here
if [ -f $HOME/.work/workrc ]; then
  source $HOME/.work/workrc
fi

export EDITOR=nvim
export VISUAL=$EDITOR
# Conveniences for tweaking nvim
export VIMCONFIG=~/.config/nvim
export VIMDATA=~/.local/share/nvim
export MYVIMRC=$HOME/.config/nvim/init.vim
# Use ripgrep for FZF
export FZF_DEFAULT_COMMAND='rg --files'

case "$(uname)" in
  Darwin)

  export PATH=$HOME/bin:$HOME/go/bin:$HOME/Library/Python/3.7/bin:$PATH
    ;;
  Linux)
    ;;
  *)
esac
if [ -f "$HOME/.cargo/env" ]; then
	. "$HOME/.cargo/env"
fi
