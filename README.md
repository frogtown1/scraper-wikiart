# WikiArt Old Masters Scraper
This program scrapes artwork and their details from the visual encyclopedia, WikiArt. 
The current version here demos the scraper for the works of old masters between the Gothic and Neoclassical movements.

## Usuage
Simply run the script through the latest version of RStudio to proceed with the scraping process.
Note that the scraping speed is very slow. This was done intentionally so as to not abuse the altruistic access provided by the WikiArt foundation and its volunteers (plus,I wasn't using it for any realtime project so wasn't in a rush to wait out the job).

### Dependencies
- `tidyverse` : data munging
- `rvest`     : html scraping pages
- `jsonlite`  : JSON munging
- `httr`      : HTTP requests
- `R.Utils`   : Extending utilities to edit csv, file formats, and log printing

### Customize
For WikiArt inquiries, simply replace the sample with the list of target artists to scrape, following wikiart url formatting conventions.
This sample scrapes 1587 urls for 186 artists yielding 4992 images and their authorship details.


