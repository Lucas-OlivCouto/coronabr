# Faz download dos dados do Minsaúde compilados por Adriano Belisario
# i checked that the info be the same as the file that we had til 18-03
# this shouldnt be downloaded anymore because the file has changed
#download.file(
#  "https://raw.githubusercontent.com/belisards/coronabr/master/dados/corona_brasil.csv",
#  destfile = "data-raw/minsaude_bel.csv")
library(dplyr)
estados <- read.csv("data-raw/estados_code.csv", row.names = 1)
minsaude <- read.csv("data-raw/minsaude_raw.csv") %>%
  rename(geocode = uid) %>%
  arrange(date) %>%
  left_join(estados) %>%
  select(-uf) %>%
  filter(date != "2020-03-26")
write.csv(minsaude, "data-raw/minsaude_formatted.csv")
