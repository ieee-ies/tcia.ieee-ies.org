#!/usr/bin/env bash
# Stamatis Karnouskos (karnouskos@ieee.org)
# Requirements: git

LANG='C'
LC_ALL='C'

#refresh local repo
git pull --quiet

#Local testing. Read local config if available
CONFIGFILE='config.conf'
if [ -f $CONFIGFILE ]
then
    source $CONFIGFILE
fi

#Make sure secret variables are set properly in GitHub
if [ -z ${MEMBERSURL+x} ]
  then
    echo "Secret variable MEMBERSURL is unset. I wont update members.html"
  else
    ./members.sh
fi

if [ -z ${EVENTSURL+x} ]
  then
    echo "Secret variable EVENTSURL is unset. I wont update events.html"
  else
    ./events.sh
fi

if [ -z ${PAPERSURL+x} ]
  then
    echo "Secret variable PAPERSURL is unset. I wont update papers.html"
  else
    ./papers.sh
fi


#commit changes
git config --local core.autocrlf input
git config --local core.whitespace trailing-space,space-before-tab,indent-with-non-tab
git commit -a -m ":construction_worker: automated update" --quiet || exit 0
git push --quiet
