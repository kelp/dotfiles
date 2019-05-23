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

Put all configs in master, but if they shouldn't or don't need
to exist on a computer, delete them in that computer's branch.

To bootstrap on a new system:
    curl https://raw.githubusercontent.com/kelp/dotfiles/master/dotfiles.sh | bash
