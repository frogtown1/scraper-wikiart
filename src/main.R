
library(tidyverse)
library(rvest)
library(jsonlite)
library(httr)
library(R.utils)





# List of Old Masters from Gothic(Proto-Renaissance) to Neoclassicism 
# https://en.wikipedia.org/wiki/Old_Master
old_masters <- c(
  "cimabue", "giotto-di-bondone", "duccio", "simone-martini", "ambrogio-lorenzetti", "pietro-lorenzetti", "gentile-da-fabriano", "lorenzo-monaco", "masolino", "pisanello", "sassetta","paolo-uccello", "fra-angelico", "masaccio", "filippo-lippi", "andrea-del-castagno", "piero-della-francesca", "benozzo-gozzoli", "antonello-da-messina", "cosimo-tura", "andrea-mantegna", "antonio-pollaiuolo", "francesco-cossa", "melozzo-da-forli", "luca-signorelli", "pietro-perugino", "verrocchio", "sandro-botticelli", "domenico-ghirlandaio", "pinturicchio", "cima-da-conegliano", "piero-di-cosimo", "francesco-francia", "lorenzo-costa", "fra-bartolommeo", "michelangelo", "bernardino-luini", "raphael", "ridolfo-ghirlandaio", "andrea-del-sarto", "corregio", "giulio-romano", "robert-campin", "jan-van-eyck", "konrad-witz", "rogier-van-der-weyden", "stefan-lochner", "petrus-christus", "dirk-bouts", "simon-marmion", "meister-francke", "hans-memling", "martin-schongauer", "michael-pacher", "hugo-van-der-goes", "hieronymous-bosch", "gerard-david", "geertgen-tot-sint-jans", "hans-holbein-the-elder", "quentin-matsys", "jan-mabuse", "matthias-grunewald", "albrecht-durer", "lucas-cranach-the-elder", "hans-burgkmair", "jean-clouet", "albrecht-altdorfer", "maitre-de-moulins", "hans-baldung-grien", "joachim-patenier", "joos-van-cleve", "bernard-van-orley", "hans-springinklee", "lucas-van-leyden", "jan-van-scorel", "hans-holbein-the-younger", "george-pencz", "sebald-beham", "barthel-beham", "lucas-cranach-the-younger", "pieter-bruegel-the-elder", "egidius-sadeler", "bartolome-bermejo", "alonso-berruguete", "luis-de-morales", "alonso-sanchez-coello", "el-greco", "dosso-dossi", "alfonso-lombardi", "bartolommeo-bandinelli", "pontormo", "rosso-fiorentino", "maarten-van-heemskerck", "alessandro-moretto", "giulio-clovio", "niccolo-tribolo", "parmigianino", "bronzino", "jacob-seisenegger", "pieter-aertsen", "francois-clouet", "giorgio-vasari", "antonio-moro", "giovanni-battista-moroni", "federico-barocci", "giuseppe-arcimboldo", "giambologna", "denis-calvaert", "scipione-pulzone", "bartholomeus-spranger", "karel-van-mander", "abraham-bloemaert", "joachim-wtewael", "adam-elsheimer", "antonio-tempesta", "lodovico-caracci", "bartolomeo-cesi", "agostino-caracci", "lodovico-cigoli", "bartolomeo-carducci", "annibale-carraci", "orazio-gentileschi", "hans-rottenhammer", "pieter-bruegel-the-younger", "francisco-pacheo", "francisco-ribalta", "jan-brueghel-the-elder", "juan-martinez-montanes", "caravaggio", "guido-reni", "peter-paul-rubens", "bernardo-strozzi", "juan-bautista-maino", "johann-liss", "jusepe-de-ribera", "guercino", "artemisia-gentileschi", "georges-de-la-tour", "jacob-jordaens", "louis-le-nain", "nicolas-poussin", "pietro-da-cortona", "francisco-de-zurbaran", "gianlorenzo-bernini", "antoine-le-nain", "anthony-van-dyck", "diego-velazquez", "claude-lorrain", "alonso-cano", "jan-brueghel-the-younger", "mathieu-le-nain", "giovanni-benedetto-castiglione", "juan-bautista-martinez-del-mazo", "mattia-preti", "salvator-rosa", "juan-carreno-de-miranda", "carlo-dolci", "bartolome-esteban-murillo", "charles-le-brun", "juan-de-valdes-leal", "pedro-de-mena", "luca-giordano", "roelant-savery", "frans-snyders", "frans-hals", "pieter-lastman", "hendrick-terbrugghen", "gerrit-van-honthorst", "dirck-van-baburen", "matthias-stom", "adriaen-brouwer", "rembrandt-van-rijn", "jan-lievens", "jacob-adriaensz-backer", "ferdinand-bol", "jan-havickszoon-steen", "jan-davidsz-de-heem", "david-teniers-the-younger", "adiaen-van-ostade", "govert-flinck", "gerrit-dou", "frans-van-mieris-the-elder", "gerard-terborch", "willem-kalf", "albert-cuyp", "samuel-van-hoogstraten", "jan-de-bray", "jacob-van-ruisdael", "gabriel-metsu", "pieter-de-hooch", "johannes-vermeet", "meindert-hobbema", "aert-de-gelder", "adriaen-van-der-werff", "rachel-ruysch",
  "giovanni-battista-piazzatta", "jean-antoine-watteau", "giovan-battista-pittoni", "giovanni-battista-tiepolo", "jean-baptiste-simeon-chardin", "francois-boucher", "charles-andre-van-loo", "pompeo-atoni", "martin-johann-schmidt", "jean-baptiste-greuze", "francois-hubert-drouais", "jean-honore-fragonard", "louise-elisabeth-vigee-le-brun", "nicholas-hilliard", "william-dobson", "john-michael-wright", "peter-lely", "godfrey-kneller", "james-thornhill", "william-hogarth", "allan-ramsay", "joshua-reynolds", "thomas-gainsborough", "joseph-wright-of-derby", "george-romney", "john-opie", "thomas-lawrence", "anton-raphael-mengs", "johann-zoffany", "benjamin-west", "angelica-kauffman"
  )


url_head <- "https://www.wikiart.org/en/"

urls <- apply(expand.grid(url_head, old_masters), 1, paste, collapse="")
urls <- apply(expand.grid(urls, "/mode/all-paintings?json=2&layout=new&page="), 1, paste, collapse="")
urls <- apply(expand.grid(urls, 1:7), 1, paste, collapse="")
urls <- apply(expand.grid(urls, "&resultType=detailed"), 1, paste, collapse="")


for (i in 1:length(urls)){
  # HTTR will check if JSON page exists (ERROR 500).
  r <- GET(urls[i])
  webJSON_status <- status_code(r)
  
  if (webJSON_status != 500) {
    try(webJSON_full <- fromJSON(urls[i]))
    webJSON_full$Paintings <- lapply(webJSON_full$Paintings, as.character)
    webJSON_full$Paintings <- webJSON_full$Paintings[c("id", "title", "year", "width", "height", "artistName", "image")]
    write.csv(webJSON_full$Paintings, sprintf("./data/url.%d.csv", i), row.names=FALSE, na="", col.names = FALSE, sep="|")
    cat("downloaded page", i, "out of", length(urls),"at", as.character(Sys.time()), "\n")
    Sys.sleep(1)
  } else {
    next
  }
}


# Remove empty files.
setwd("./data/")
lapply(Filter(function(x) countLines(x)<=1, list.files(pattern='.csv')), unlink)

# Merge files into a single one.
files <- list.files("./", full.names = TRUE)
files <- lapply(files, function(x) read.csv(x, header=FALSE, skip=1, col.names=c("id", "title", "year", "width", "height", "artistName", "image")))
paintings_df <- do.call(rbind.data.frame, files)

# Check for and remove duplicated entries.
length(paintings_df$id[duplicated(paintings_df$id)])
paintings_df <- paintings_df[!duplicated(paintings_df$id),]
length(paintings_df$id[duplicated(paintings_df$id)])

# Clean .$years column of ambiguities.
paintings_df$year %>%
  as.character(.) %>%
  gsub("\\?", "",.) %>%
  sub("^\\s+", "",.)
paintings_df$year <- sapply(strsplit(paintings_df$year,"-"), "[", 1)
sapply(strsplit(paintings_df$year, ""), "[", 1)
paintings_df$year[nchar(paintings_df$year)!= 4] <- NA
paintings_df$year <- as.numeric(paintings_df$year)


write.csv(paintings_df,file="./paintings.csv",row.names=FALSE)



# Retrieving images
for (j in 4992:length(paintings_df$year)) {
  if (!is.na(paintings_df$year[j])) {
    s <- GET(paintings_df$image[j])
    webIMG_status <-  status_code(s)
    
    if (webIMG_status != 404) { 
      download.file(url = paintings_df$image[j], destfile = paste("./images/",sprintf("%05d", j), sep="", ".jpg"), mode ="wb", quiet = T)
      Sys.sleep(1)
    } else {
      next
    }
    
  } else {
    next
  }
  
}




