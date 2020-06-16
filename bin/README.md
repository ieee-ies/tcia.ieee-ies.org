# Automatic Updates

The website can be edited online in GitHub or offline and be committed via git.

Some website pages i.e. papers.html, events.html, and members.html, can be automatically updated from Google Docs.
Currently the sync is done daily, and on demand (via any update on the website).

You only need to provide the Google Docs links as GitHub secrets as explained below.

## Google Docs and TSV exports

Two spreadsheets are expected one having the members of the TC and another one with the events and papers. There are standard formats which you can easily copy and get started.

Once these 2 files are created, go in Google Docs to the spreadsheet and:

- select **Publish to the web**
- subsequently select the specific part of that spreadsheet,
- and finally also choose **tab separated values (.tsv)**.
- Make sure that you also select the option to **Automatically republish when changes are made**.

Copy the link that gets generated which should be similar to
`https://docs.google.com/spreadsheets/[...]&single=true&output=tsv`

The EVENTSURL, MEMBERSURL and PAPERSURL need to be setup as secret variables in GitHub.


## Setting up a local development environment

This is only needed if you plan to modify the scripts that automatically generate the pages.

### Script Overview
This is a collection of scripts to enable automatic update of the TC web pages.
- [events.sh](events.sh): updates TC events page
- [members.sh](members.sh): updates TC members page
- [papers.sh](papers.sh): updates TC papers page
- [update-all.sh](update-all.sh): calls events members and papers scripts
- `config-sample.conf`: configuration file (optional for local testing)

### Configuration
EVENTSURL, MEMBERSURL and PAPERSURL need to either be set as environment variables or to be read from `/bin/config.conf`.

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

### technical explanation on Google Docs exported TSV files

Only some fields are read by the scripts from each .tsv file e.g.

- papers.sh reads only field 2 (DOI). See [papers-sample.tsv](papers-sample.tsv).
- events.sh reads fields 1,2 and 3 (year, link and description). See [events-sample.tsv](events-sample.tsv).
- members.sh reads fields 2,3,4,8 (name, institution, country, google scholar ID). See [members-sample.tsv](members-sample.tsv).

The Google Docs spreadsheets need to reflect this structure and the respective fields in those positions.
