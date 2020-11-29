#Brawlhalla get data
library(httr)
library(jsonlite)
library(hablar)



# Passos para encontrar os dados de alguém:
#Passo 1: acesse o steam, clique no seu nick, aparecerá uma url verde, pegue os números do meio
#Passo 2: coloque na url do search e colete o brawlhalla_id dele
#Passo 3: aplique na url do players e colete os dados referente a legends.

#API KEY = WKCIUG0T7JI8QVJVPE3C

#Conectando e coletando os dados

# Coletando o brawl id de fabrício:
#Brawl_id  fabricio= 2330385
# do rayloro: 33250647
url="https://api.brawlhalla.com/search?steamid=76561198918332310&api_key=WKCIUG0T7JI8QVJVPE3C"
get_bid<-GET(url)



# Player Stats
#Fabricio
#url <- paste0("https://api.brawlhalla.com/player/2330385/stats?api_key=WKCIUG0T7JI8QVJVPE3C")
#rayloro
url <- paste0("https://api.brawlhalla.com/player/33250647/stats?api_key=WKCIUG0T7JI8QVJVPE3C")

get<-GET(url)

# Extraindo os dados
data=fromJSON(rawToChar(get$content))
data<-data$legends[data$legends$games>15,] #Pegando os dados dos legends que jogou pelo menos 15 partidas
#Calculando o winrate
data$winrate<-(data$wins/data$games)*100


# Dados estáticos como armas que são usadas
url="https://api.brawlhalla.com/legend/all?api_key=WKCIUG0T7JI8QVJVPE3C"
get<-GET(url)

# Extraindo os dados estáticos
static=fromJSON(rawToChar(get$content))

data_f<-merge(data,static,by="legend_name_key" )
rm(data,static,get,url)

