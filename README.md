# WikiArt Old Masters Scraper
This program scrapes artwork and their details from the visual encyclopedia, WikiArt. 
The current version here demos the scraper for the works of old masters between the Gothic and Neoclassical movements.

## Usuage

### Packages
- `tidyverse` : data munging
- `rvest`     : html scraping pages
- `jsonlite`  : JSON munging
- `httr`      : HTTP requests
- `R.Utils`   : Extending utilities to edit csv, file formats, and log printing

### Customize
For WikiArt inquiries, simply replace the sample with the list of target artists to scrape, following wikiart url formatting conventions.
This sample scrapes 1587 urls for 186 artists yielding 4992 images and their authorship details.


