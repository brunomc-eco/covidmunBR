# COVID-19 Dashboard for IBGE
# Bruno Carvalho, brunomc.eco@gmail.com
# Processing data from IDB

library(dplyr)

idb_raw <- read.csv("./data/idb/daily.csv",
                    header = TRUE)

str(idb_raw)
idb_raw$region_name <- as.character(idb_raw$region_name)

#selecionando apenas cidades brasileiras

idb_br <- idb_raw %>%
  filter(country_iso_code == "BR")



str(idb_br$region_name)
unique(idb_br$region_name)

head(idb_raw)


# geocodigos mun IBGE
codmun <- read.csv("./data/IBGE_geocodmun.csv",
                   header = TRUE,
                   encoding = "UTF-8")

codmun <- codmun[ ,-1]

names(codmun) <- c("codmun", "Município", "Estado")

codmun$Município <- as.character(codmun$Município)
codmun$Estado <- as.character(codmun$Estado)

# corrigindo nomes de municípios para o join
codmun$Município[5281] <- c("Poxoréu")
codmun$Município[2032] <- c("Iuiu")


# leitos MS
leitos_raw <- read.csv("./data/leitos_MS/leitos_MS.csv",
                       header = TRUE,
                       encoding = "UTF-8")

# corrigindo tipos de variáveis
leitos_raw$Município <- as.character(leitos_raw$Município)
leitos_raw$Estado <- as.character(leitos_raw$Estado)
leitos_raw$Data <- as.Date(leitos_raw$Data)

# tabela para análises
leitos <- leitos_raw %>%
  inner_join(codmun, by = c("Município", "Estado")) %>% # join dos codigos municipais
  filter(Data == Sys.Date()) # mantendo apenas registros de hoje

# output por municipios
leitos_mun <- leitos %>%
  group_by(Estado, Município, codmun) %>%
  summarise(respiradores = sum(Respiradores),
            leitos_covid = sum(Leitos.COVID),
            leitos_covid_uti = sum(Leitos.COVID.UTI),
            ocupacao_covid = sum(Ocupação.COVID),
            ocupacao_covid_uti = sum(Ocupação.COVID.UTI))

write.csv(leitos_mun,
          file = paste0("./outputs/1_leitos_mun_", Sys.Date(), ".csv"),
          row.names = FALSE)

# output por UF
leitos_uf <- leitos %>%
  group_by(Estado) %>%
  summarise(respiradores = sum(Respiradores),
            leitos_covid = sum(Leitos.COVID),
            leitos_covid_uti = sum(Leitos.COVID.UTI),
            ocupacao_covid = sum(Ocupação.COVID),
            ocupacao_covid_uti = sum(Ocupação.COVID.UTI))

write.csv(leitos_uf,
          file = paste0("./outputs/1_leitos_uf_", Sys.Date(), ".csv"),
          row.names = FALSE)


# check if sums are matching
#sum(leitos_raw$Ocupação.COVID.UTI)
#sum(leitos$Ocupação.COVID.UTI)
#sum(leitos_mun$ocupacao_covid_uti)
#sum(leitos_uf$ocupacao_covid_uti)
