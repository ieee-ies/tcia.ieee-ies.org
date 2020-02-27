#!/usr/bin/env bash
# Stamatis Karnouskos (karnouskos@ieee.org)
# Requirements: curl bibtool bibtex2html

FILE='papers'
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
curl -s -L -R $PAPERSURL -o $FILE".tsv"

if [ -s $FILE".tsv" ]; then

	cat "../template_header.html" >$FILE".html"
	echo "<div class=\"title\">Recent Common Papers</div> <div class=\"subcont\"> <p>" >>$FILE".html"

	DOI="$(tail -n +2 $FILE".tsv" |
		sort -u -b -d -f -i -k 1,2 -s -t$'\t' |
		awk 'BEGIN { FS = "\t" } ;
	{if (length($2) > 1) {print $2}}')"  #no empty lines

	for i in $DOI; do
		if (echo $i | grep -q "10."); then  #valid DOI
			curl -sSgLH 'Accept: application/x-bibtex' "http://dx.doi.org/$i" | sed 's/}, /},\n\t/g' >>$FILE".bib"
			echo >>$FILE".bib"
		fi
	done

	rm -f $FILE".tsv"

	bibtool -S -d -q -k $FILE".bib" -o $FILE"2.bib"
	mv -f $FILE"2.bib" $FILE".bib"

	bibtex2html -nokeys -d -r -o $FILE"2" -i -s IEEEtranTCIA.bst -nolinks -nodoc -q -nobibsource -nofooter -noheader -noabstract -nokeywords -nodoi -html-entities -nf url "URL" $FILE".bib"

	cat $FILE"2.html" >>$FILE".html"
	\rm -f $FILE"2.html"

	echo "</div>" >>$FILE".html"
	cat "../template_footer.html" >>$FILE".html"
	sed -i.bak -e 's/[[:blank:]]*$//' $FILE".html"
	\rm -f $FILE".html.bak"


	\rm -f $FILE".bib"
	\mv -f "$FILE.html" "../$FILE.html"
fi

exit 0
