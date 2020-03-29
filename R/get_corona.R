#' Extrai dados de coronavírus para o Brasil
#'
#' Esta função extrai os valores compilados pelo ministério da Saúde do Brasil
#' (disponível em: 'https://covid.saude.gov.br/') e salva o resultado no disco.
#'
#' @param dir Diretório onde salvar o arquivo
#' @param filename Nome do arquivo
#'
#' @importFrom rvest html_text
#' @importFrom stringr str_split
#' @importFrom jsonlite fromJSON
#' @importFrom utils write.csv
#' @importFrom dplyr mutate_if
#' @importFrom dplyr bind_rows
#' @importFrom dplyr left_join
#' @importFrom rlang .data
#' @import magrittr
#' @import plyr
#'
#' @export
#'
get_corona <- function(dir = "output/",
                       filename = "corona_minsaude") {
  rlang::.data #para usar vars no dplyr
  #get original data and format it
  estados <- read.csv("./data-raw/estados_code.csv", row.names = 1)
  minsaude <-
    read.csv("./data-raw/minsaude_formatted.csv", row.names = 1) %>%
    dplyr::left_join(estados) %>%
    dplyr::mutate(date = as.Date(date))

  covid_br <- get_corona_minsaude()
  #formatting only estados
  covid_estados <- covid_br$PortalMapa
  #estados deveria ser data. nao tem uma pasta com dados, aliñas
  #format estados new
  covid_estados_new <-
    dplyr::left_join(covid_estados, estados) %>%
    dplyr::rename(cases = qtd_confirmado) %>%
    dplyr::select(nome, codigo, geocode, updatedAt, cases) %>%
    dplyr::mutate(date =  as.Date(updatedAt)) %>%
    dplyr::select(-updatedAt)

  new_df <-
    dplyr::bind_rows(minsaude, covid_estados_new) %>%
    distinct(nome, cases, )

   message(paste0("salvando ", filename, ".csv em ", dir))
   if (!dir.exists(dir)) {
     dir.create(dir)
   }
  utils::write.csv(new_df, paste0(dir, filename, ".csv"),
                    row.names = FALSE)
  return(new_df)
}
