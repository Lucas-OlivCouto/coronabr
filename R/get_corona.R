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
#' @importFrom utils read.csv
#' @importFrom utils write.csv
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
    dplyr::rename(cases = .data$qtd_confirmado) %>%
    dplyr::select(.data$nome,
                  .data$codigo,
                  .data$geocode,
                  .data$updatedAt,
                  .data$cases) %>%
    dplyr::mutate(date =  as.Date(.data$updatedAt)) %>%
    dplyr::select(-.data$updatedAt)

  new_df <-
    dplyr::bind_rows(minsaude, covid_estados_new) %>%
    dplyr::distinct()

   message(paste0("salvando ", filename, ".csv em ", dir))
   if (!dir.exists(dir)) {
     dir.create(dir)
   }
  utils::write.csv(new_df, paste0(dir, filename, ".csv"),
                    row.names = FALSE)
  return(new_df)
}
