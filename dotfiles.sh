#!/bin/bash
#
# A handy script to bootstrap / clone my dotfiles setup to a new system
# Borrowed from https://www.atlassian.com/git/tutorials/dotfiles
#
git clone --bare https://github.com/kelp/dotfiles.git $HOME/.dotfiles
function dot {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p .dotfiles-backup
dot checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
  else
    echo "Backing up pre-existing dot files.";
    dot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi;
dot checkout
dot config status.showUntrackedFiles no