#' Extrai dados de coronavírus para o Brasil
#'
#' Esta função extrai os valores compilados pelo ministério da Saúde do Brasil
#' (disponível em: 'https://covid.saude.gov.br/') e salva o resultado no disco.
#'
#' @param dir Diretório onde salvar o arquivo
#' @param filename Nome do arquivo, valor predeterminado "minsaude"
#' @param uf Caractere indicando a abreviação do(s) estado(s) brasileiro(s)
#'
#' @importFrom utils write.csv
#' @importFrom dplyr mutate_if bind_rows left_join
#' @importFrom rlang .data
#' @importFrom utils read.csv write.csv
#' @importFrom magrittr %>%
#' @importFrom plyr .
#' @importFrom lubridate as_date
#'
#' @export
#'
get_corona_minsaude <- function(dir = "output",
                                filename = "minsaude",
                                uf = NULL) {
  rlang::.data #para usar vars no dplyr
  #get original data and format it
  url <- "https://covid.saude.gov.br"
  date <- format(Sys.Date(), "%Y%m%d")
  res <- utils::read.csv2(
    paste0("https://covid.saude.gov.br/assets/files/COVID19_",
           date,
           ".csv"))
  res <- res %>% dplyr::mutate(date = lubridate::as_date(as.character(data),
                                           tz = "America/Sao_Paulo",
                                           format = "%d/%m/%Y")) %>%
    dplyr::select(-data)
  # gravando metadados da requisicao
  metadado <- data.frame(intervalo = paste(range(res$date), collapse = ";"),
                         fonte = url,
                         acesso_em = Sys.Date())
  if (!is.null(uf)) {
    res <- res %>% dplyr::filter(estado %in% uf)
  }

   message(paste0("salvando ", filename, ".csv em ", dir))
   if (!dir.exists(dir)) {
     dir.create(dir)
   }
   utils::write.csv(res,
                    paste0(dir, "/", filename,
                           paste(uf, collapse = "-"), ".csv"),
                    row.names = FALSE)
   utils::write.csv(metadado,
                    paste0(dir, "/", "metadado_minsaude",
                           paste(uf, collapse = "-"), ".csv"),
                    row.names = FALSE)
   return(res)
}
