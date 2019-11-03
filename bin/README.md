# Automatic Updates

This is a collection of scripts to enable automatic update of the TC web pages.

- [events.sh](events.sh): updates TC events page
- [members.sh](members.sh): updates TC members page
- [papers.sh](papers.sh): updates TC papers page
- [update-all.sh](update-all.sh): calls events members and papers scripts
- [config.conf](config-sample.conf): configuration file for all scripts

## Configuration

All necessary parameters for the configuration of scripts are in config.conf file

The scripts require several utilities to be installed in the host that runs them.
You should install them e.g.

```bash
# Unix-based systems
sudo apt-get install git curl bibtool bibtex2html

# MacOS via brew
brew install git && \
brew install curl && \
brew install bib-tool && \
brew install bibtex2html
```

Once properly configured you can run the command to update the website e.g.

```bash
update-all.sh
```

Optionally, you can add such command in the crontab to execute every night and update the TC web pages e.g.

```bash
0	2	*	*	*	cd /home/stamatis/tcia/bin/ && ./update-all.sh
```

## TSV exports of Google Docs

In Google Docs you have to go to the spreadsheet and

- select **Publish to the web**
- subsequently select the specific part of that spreadsheet,
- and finally also choose **tab separated values (.tsv)**.
- Make sure that you also select the option to **Automaticaly republish when changes are made**.

Copy the link that gets generated which should be similar to
`https://docs.google.com/spreadsheets/[...]&single=true&output=tsv`
These links can then be used in the `config.conf` file

Only some fields are read by the scripts from each .tsv file e.g.

- papers.sh reads only field 2 (DOI). See [papers-sample.tsv](papers-sample.tsv).
- events.sh reads fields 1,2 and 3 (year, link and description). See [events-sample.tsv](events-sample.tsv).
- members.sh reads fields 2,3,4,8 (name, institution, country, google scholar ID). See [members-sample.tsv](members-sample.tsv).

The Google Docs spreadsheets need to reflect this structure and the respective fields in those positions.

