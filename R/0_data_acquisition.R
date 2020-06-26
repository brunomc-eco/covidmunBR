# COVID-19 Dashboard for IBGE
# Bruno Carvalho, brunomc.eco@gmail.com
# Downloading raw data from public sources

library(readr)

## ocupacao de leitos, Ministério da Saúde
## https://gestaoleitos.saude.gov.br/app/kibana#/dashboard/18685ad0-81b4-11ea-9f02-bfa3f55b2dad
# no final do dashboard, exportar arquivo "Formatted"
# salvar na pasta "./data/leitos_MS"
# renomear arquivo para "leitos_MS.csv"


## IDB Inter-American Development Bank
## Coronavirus Traffic Congestion Impact in Latin America with Waze Data
## https://www.iadb.org/en/topics-effectiveness-improving-lives/coronavirus-impact-dashboard

daily <- read_csv('http://tiny.cc/idb-traffic-daily')
metadata <- read_csv('http://tiny.cc/idb-traffic-metadata')

write.csv(daily, file = "./data/idb/daily.csv")
write.csv(metadata, file = "./data/idb/metadata.csv")
