#!/usr/bin/env bash
# Stamatis Karnouskos (karnouskos@ieee.org)
# Requirements: git

LANG='C'
LC_ALL='C'

#Read config file
CONFIGFILE='config.conf'

if [ -f $CONFIGFILE ]
then
    source $CONFIGFILE
else
    echo "$CONFIGFILE does not exist. Please create it."
    exit 1
fi

#refresh local repo
git pull --quiet

#update the pages
./events.sh
./papers.sh
./members.sh

#commit changes
git config --local core.autocrlf input
git config --local core.whitespace trailing-space,space-before-tab,indent-with-non-tab
git commit -a -m ":construction_worker: automated update" --quiet
git push --quiet
