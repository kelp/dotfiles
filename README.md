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

	curl -Lks https://git.io/fjB0R | bash

Generally we rebase branches, so need to be careful about which changes
happen in those branches. 

# Useful commands:

## Create a new breanch for the local config
    	dot checkout -b arch-server

## Push the new branch upstream
    	dot push origin/arch-server

## Revert file to state in master
    	dot checkout master <file>

## Main workflow, for any file that exists on all computers, edit on master
	dot checkout master
	# do edits
	dot checkout arch-server
	dot merge master

## List all files currently tracked
	dot ls-tree --full-tree -r --name-only HEAD
	# or just use dotls alias
	dotls
