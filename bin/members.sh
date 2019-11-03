#!/usr/bin/env bash
# Stamatis Karnouskos (karnouskos@ieee.org)
# Requirements: curl

FILE='members'
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


# A TSV export from google spreadsheet
curl -s -L -R  $MEMBERSURL -o "$FILE.tsv"


if [ -s $FILE".tsv" ]; then

cat "../template_header.html" >$FILE".html"
echo "<div class=\"title\">TC-IA Members</div> <div class=\"subcont\">" >> $FILE".html"


tail -n +3 $FILE".tsv" \
| sort -b -d -f -i -k 2,3  -t$'\t'  \
| awk 'BEGIN { FS = "\t" } ;
{if (length($8) < 9)
  {
  {print "<div class=\"member\"><div class=\"image\"><img align=\"left\" src=\"https://scholar.google.com/citations/images/avatar_scholar_128.png\" width=\"60\" height=\"70\" alt=\"" $2 "\" /></div>"}
  {print "<div class=\"member_data\">"}
  {print "<p><b>" $2 "</b><br />"}
  }
else
  {
  {print "<div class=\"member\"><div class=\"image\"><img align=\"left\" src=\"https://scholar.google.com/citations?view_op=medium_photo&user=" $8 "\" width=\"60\" height=\"70\" alt=\"" $2 "\" /></div>"}
  {print "<div class=\"member_data\">"}
  {print "<p><b><a href=\"https://scholar.google.com/citations?user=" $8 "\">" $2 "</a></b><br />"}
  }
}
{print $3 " <br />"}
{print $4 " <br />"}
{print "</p></div></div>"}
' >> $FILE".html"


echo "</div>" >> $FILE".html"
cat "../template_footer.html" >>$FILE".html"
sed -i.bak -e 's///' $FILE".html"
sed -i.bak -e 's/[[:blank:]]*$//' $FILE".html"
\rm -f $FILE".html.bak"


#cleanup
\rm -f $FILE".tsv"
\mv -f "$FILE.html" "../$FILE.html"

fi
exit 0
