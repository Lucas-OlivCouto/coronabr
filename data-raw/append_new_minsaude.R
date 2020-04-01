#append new_data day by day
#this script appends new daily data from minsaude to the historical series
library(dplyr)
# le o template estados
estados <- read.csv("./data-raw/estados_code.csv",
                    row.names = 1)
#e os dados antigos de minsaúde, já formatados, fonte adriano belisario (see readme)
minsaude <-
  read.csv("./data-raw/minsaude_formatted.csv", row.names = 1) %>%
  dplyr::left_join(estados) %>%
  dplyr::mutate(date = as.Date(date))

#faz download dos dados mais recentes
source("data-raw/get_minsaude_new.R")
#I am working from the root of the package so there's "data-raw/" everywhere
#pega os objetos .rda que a função do julio criou. see readme.
daily <- list.files("data-raw", pattern = ".rda$", full.names = T)
daily
#carrega um a um e junta com os dados antigos (minsaude, linha 8)

for (i in seq_along(daily)) {
  load(daily[i])#nome do objeto covid_br

  #isto só extrai a data do nome do objeto .rda
  date <- stringr::str_split(string = daily[i],
                             c("/"),
                             simplify = TRUE) %>%
    data.frame() %>% select(2) %>% pull() %>%
    stringr::str_split(pattern = "_", simplify = T) %>%
    data.frame() %>% select(1) %>% pull() %>% as.character()

  #pega a tabela com a informacao de estados e renomeia nome
  covid_estados <- covid_br$PortalMapa %>%
    rename(uadm = nome)

  #junta e formata ainda só os dados para um único dia
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
#junta com os dados anteriores de minsaude. na primeira iteração o dado fixo velho,
  #nas seguintes os dados em ordem de data
  new_df <-
    dplyr::bind_rows(minsaude, covid_estados_new) %>%
    #às vezes os dados nao foram atualizados e o append inclui linhas velhas daí:
    dplyr::distinct()
  #salva o de cada dia
  utils::write.csv(new_df,
                   paste0("data-raw/minsaude_append_",
                          date, ".csv"),
                   row.names = FALSE)
  #salva de novo mas em um que se chama latest. só este deveria mudar no git
  utils::write.csv(new_df,
                   paste0("data-raw/minsaude_append_latest.csv"),
                   row.names = FALSE)
  #para controlar o loop
  minsaude <- new_df
  message(pander::pander(covid_estados_new %>% count(date)))
}
  #estou pensando que latest é o que deveria entrar nos plots.
  #mas estou ciente de que estou em data-raw, isto deveria sair pro corpo do pacote (get_corona já faz isso mas não resolve o append)
  #uma opção seria botar um use_data aqui, com latest. to quebrando a cabeça ainda.
