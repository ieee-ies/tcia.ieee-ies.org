#!/usr/bin/env bash
# Stamatis Karnouskos (karnouskos@ieee.org)
# Requirements: curl

FILE='events'
LANG='C'
LC_ALL='C'

#Local testing. Read local config if available
CONFIGFILE='config.conf'
if [ -f $CONFIGFILE ]; then
  source $CONFIGFILE
fi

#Make sure secret variables are set properly
if [ -z ${EVENTSURL+x} ]; then
  echo "Secret variable EVENTSURL is unset. Exiting"
  exit 1
fi

# A TSV export from google spreadsheet
echo "Acquiring events dataset ..."
curl -s -L -R $EVENTSURL -o "$FILE.tsv"

if [ -s $FILE".tsv" ]; then

  cat "../template_header.html" >$FILE".html"

  echo "<div class=\"title\">Events </div> <div class=\"subcont\"> <div class=\"links\"> <p> <ul>" >>$FILE".html"

  tail -n +2 $FILE".tsv" |
    sort -u -b -d -f -i -k 1,3 -s -t$'\t' |
    awk 'BEGIN { FS = "\t" } ;
{if (length($2) > 6)
  {
  {print "<li><a href=\"" $2 "\" target=\"_blank\">" $3 "</a></li><p>"}
  }
}
' >>$FILE".html"

  echo "</ul> </div> </div>" >>$FILE".html"

  cat "../template_footer.html" >>$FILE".html"
  sed -i.bak -e 's/[[:blank:]]*$//' $FILE".html"
  \rm -f $FILE".html.bak"

  #cleanup
  \rm -f $FILE".tsv"
  \mv -f "$FILE.html" "../$FILE.html"

fi
exit 0
