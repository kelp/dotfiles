# dotfiles

These are my dotfiles managed via the methodology descxribed in this HN thread: 
https://news.ycombinator.com/item?id=11070797
and here:
https://www.atlassian.com/git/tutorials/dotfiles

# Workflow

Configs that apply to all systems will exist in the master branch.

create a branch for any config that is different on a specific computer.
for any global change, do it in master and then 'git merge master'

For local configs, do it on the computer specific branch.

To bootstrap on a new system:

    echo ".dotfiles" >> .gitignore
    git clone --separate-git-dir=$HOME/.dotfiles https://github.com/kelp/dotfiles $HOME/dotfiles-tmp
    rm -r ~/dotfiles-tmp/
    alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
