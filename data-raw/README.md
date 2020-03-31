# Dados brutos do Ministério da saúde

## Dados até 2020-03-18
Até 2020-03-18 o ministério de saúde brasileiro disponibilizou os dados de casos de coronavirus COVID-19 discriminados por estado na página http://plataforma.saude.gov.br/novocoronavirus/#COVID-19-brazil.

## Dados entre 2020-03-18 e 2020-03-25

Entre 2020-03-18 e 2020-03-25 o ministério de saúde brasileiro disponibilizou os dados de casos de coronavirus COVID-19 discriminados por estado no blog do Ministério e em apresentações de powerpoint.
Adriano Belisario atualizou os dados à mão no repositório
https://github.com/belisards/coronabr.

__A série inteira desde dia 2020-01-30 até dia 2020-03-25 se encontra no arquivo `minsaude_raw.csv`.__

Esse arquivo é formatado usando o script `get_minsaude_bel.R` e salvo no arquivo

`minsaude_formatted.csv`

## Dados a partir de 2020-03-26

A partir de 2020-03-26 o ministério de saúde brasileiro disponibilizou os dados de casos de coronavirus COVID-19 na página https://covid.saude.gov.br/

O script que permite obter esses dados foi escrito por Julio Recenti e se encontra em `get_minsaude_new.R`

São dados diários, uma lista com 6 elementos

-PortalGeral - Número total de casos e óbitos
-PortalRegiao - Número de casos por região do Brasil
-PortalSemana - Número de casos por semana epidemiológica
-PortalDias - Número de casos por dia
-PortalAcumulo - Número acumulado de casos
-PortalMapa - Dados por Estado (cria o mapa)

__A discriminação por tipo de caso e o número de óbitos por estado não se encontra mais disponível. __

A função `get_corona()` formata esses dados para uso interno do pacote e unifica as diferentes fontes de dados relativas ao ministério da saúde.

Nota: os scripts que geram os dados estão salvos na pasta `data-raw` mas estão escritos para serem rodados em sessão interativa na raíz do pacote - sem mudar de pasta de trabalho #boaspráticas
