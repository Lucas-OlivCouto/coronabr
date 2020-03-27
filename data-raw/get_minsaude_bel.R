# Faz download dos dados do Minsaúde compilados por Adriano Belisario

download.file(
  "https://raw.githubusercontent.com/belisards/coronabr/master/dados/corona_brasil.csv",
  destfile = "data-raw/minsaude_bel.csv")
minsaude_bel <- read.csv("data-raw/minsaude_bel.csv")
