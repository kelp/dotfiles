#!/usr/bin/env fish
#
# Generate a nice motd
#

set TMP (mktemp)
set MOTD $HOME/.config/motd/motd
set OS (uname -s)

if which neofetch > /dev/null
	neofetch >> $TMP
else
	echo "neofetch not installed"
	exit 1
end

switch $OS
    case Linux
        set DIST (lsb_release -si)
        switch $DIST
            case Arch
                echo "Updates: " >> $TMP
                checkupdates >> $TMP
            case Debian
                # do nothing so far
            case Ubuntu
                # do nothing so far
         end
    case OpenBSD
        echo "Package updates: " >> $TMP
        pkg_add -snuI | egrep -v '(quirks|highwater|tarsnap)' &>> $TMP
end

echo "Last: " >> $TMP
last -n 2 | grep -v wtmp | sed '/^$/d'  >> $TMP

mv $TMP $HOME/.config/motd/motd

rm -f $TMP
