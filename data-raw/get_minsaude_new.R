library(dplyr)
get_corona_minsaude <- function(write = FALSE) {
  url <- "https://xx9p7hp1p7.execute-api.us-east-1.amazonaws.com/prod/"
  endpoints <- c("PortalGeral",
                 "PortalRegiao",
                 "PortalSemana",
                 "PortalDias",
                 "PortalAcumulo",
                 "PortalMapa")
  links <- paste0(url, endpoints)
  headers <- httr::add_headers("X-Parse-Application-Id" = "unAFkcaNDeXajurGB7LChj8SgQYS2ptm")
  covid_br <- links %>%
    purrr::set_names(endpoints) %>%
    purrr::map(httr::GET, headers) %>%
    purrr::map(httr::content, simplifyDataFrame = TRUE) %>%
    purrr::map("results") %>%
    purrr::map(tibble::as_tibble)
  if (write == TRUE) {
    save(covid_br, file = paste0("./data-raw/", Sys.Date(), "_covid_br.rda"),
         compress = "xz")
  }
  return(covid_br)
}
get_corona_minsaude(write = TRUE)
#this should be run everyday (travis?) and will save an .rda with the whole data for the day. maybe this is unnecessary but maybe data will change.
