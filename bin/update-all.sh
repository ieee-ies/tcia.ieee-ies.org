#!/usr/bin/env bash
# Stamatis Karnouskos (karnouskos@ieee.org)
# Requirements: git

LANG='C'
LC_ALL='C'

#refresh local repo
git pull --quiet

#Local testing. Read local config if available
CONFIGFILE='config.conf'
if [ -f $CONFIGFILE ]; then
  source $CONFIGFILE
fi

#Make sure secret variables are set properly in GitHub
if [ -z ${MEMBERSURL+x} ]; then
  echo "Secret variable MEMBERSURL is unset. I wont update members.html"
else
  echo "Updating members.html"
  ./members.sh
  git add ../members.html
fi

if [ -z ${EVENTSURL+x} ]; then
  echo "Secret variable EVENTSURL is unset. I wont update events.html"
else
  echo "Updating events.html"
  ./events.sh
  git add ../events.html
fi

if [ -z ${PAPERSURL+x} ]; then
  echo "Secret variable PAPERSURL is unset. I wont update papers.html"
else
  echo "Updating papers.html"
  ./papers.sh
  git add ../papers.html
fi

#commit changes
git config --local core.autocrlf input
git config --local core.whitespace trailing-space,space-before-tab,indent-with-non-tab
git commit -a -m ":construction_worker: automated update" --quiet || exit 0
git push --quiet
