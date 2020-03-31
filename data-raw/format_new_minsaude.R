#append new_data day by day
#this script appends new daily data from minsaude to the historical series
library(dplyr)
estados <- read.csv("./data-raw/estados_code.csv",
                    row.names = 1)
minsaude <-
  read.csv("./data-raw/minsaude_formatted.csv", row.names = 1) %>%
  dplyr::left_join(estados) %>%
  dplyr::mutate(date = as.Date(date))

#I am working from the root of the package
daily <- list.files("data-raw", pattern = ".rda$", full.names = T)
for (i in seq_along(daily)) {
  load(daily[i])#covid_br
  date <- stringr::str_split(string = daily[i],
                             c("/"),
                             simplify = TRUE) %>%
    data.frame() %>%
    select(2) %>%
    pull() %>%
    stringr::str_split(pattern = "_", simplify = T) %>%
    data.frame() %>%
    select(1) %>%
    pull() %>%
    as.character()
  covid_estados <- covid_br$PortalMapa %>%
    rename(uadm = nome)
  #estados deveria ser data. nao tem uma pasta com dados, aliñas
  #format estados new
  covid_estados_new <-
    dplyr::left_join(covid_estados, estados) %>%
    dplyr::rename(cases = .data$qtd_confirmado) %>%
    dplyr::select(.data$uadm,
                  .data$uf,
                  .data$geocode,
                  .data$updatedAt,
                  .data$cases) %>%
    dplyr::mutate(date =  as.Date(.data$updatedAt)) %>%
    dplyr::select(-.data$updatedAt)
  new_df <-
    dplyr::bind_rows(minsaude, covid_estados_new) %>%
    dplyr::distinct()
  utils::write.csv(new_df,
                   paste0("data-raw/minsaude_append_",
                          date, ".csv"),
                   row.names = FALSE)
  utils::write.csv(new_df,
                   paste0("data-raw/minsaude_append_latest.csv"),
                   row.names = FALSE)
  minsaude <- new_df
}
