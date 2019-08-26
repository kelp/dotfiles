#!/usr/bin/fish
#
# Generate a nice motd
#

set TMP (mktemp)
set MOTD $HOME/.config/motd/motd

neofetch >> $TMP

echo "Updates: " >> $TMP
checkupdates >> $TMP
echo "Last: " >> $TMP
last -n 2 | grep -v wtmp | sed '/^$/d'  >> $TMP

mv $TMP $HOME/.config/motd/motd

rm -f $TMP
