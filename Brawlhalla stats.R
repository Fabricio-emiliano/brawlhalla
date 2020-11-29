# Criação de funções:
winrate_arma=function(df){
  one<-df%>%group_by(weapon_one)%>%summarise(
    winrate=mean(winrate),
    games=round(mean(games),0)
  )%>%arrange(desc(winrate))
  two<-df%>%group_by(weapon_two)%>%summarise(
    winrate=mean(winrate),
    games=round(mean(games),0)
  )%>%arrange(desc(winrate))
  
  names(one)[1]=names(two)[1]="weapon"
  
  dano_one=df%>%group_by(weapon_one)%>%summarise(
    dano_causado=round(mean(as.numeric(damagedealt)/games),1))
  dano_two=df%>%group_by(weapon_two)%>%summarise(
    dano_causado=round(mean(as.numeric(damagedealt)/games),1))
  names(dano_one)[1]=names(dano_two)[1]="weapon"
  
  one=merge(one,dano_one,by="weapon")
  two=merge(two,dano_two,by="weapon")
  weapon=rbind(one,two)%>%group_by(weapon)%>%summarise(
    winrate=mean(winrate),
    games=round(mean(games),0),
    dano_causado=round(mean(dano_causado),1)
  )%>%arrange(desc(winrate))
  
  return(weapon)
}

# _______//_________//_________//_________//_________//_________


#Pacotes
library(ggplot2)
library(dplyr)

#Objetivos da pesquisa: Deseja-se verificar quais são os 5 personagens com maior winrate e deseja-se verificar qual a melhor arma para o player jogar e crescer em ELO. 

# Os cinco melhores personagens de acordo com winrate:
top5<-(data_f%>%
  select(bio_name,winrate,games)%>%arrange(desc(winrate)))[1:5,]
top5
# a melhor arma para se jogar de acordo com winrate

winrate_arma(data_f)


# Dano médio que causa com a bomba
mean(as.numeric(data_f$damagegadgets)/data_f$games)
# Dano médio que causa jogando itens
mean(as.numeric(data_f$damagethrownitem)/data_f$games)
sd(as.numeric(data_f$damagethrownitem)/data_f$games)

# Quais stats me fazem ganhar mais partidas:

stats=data_f%>%filter(bio_name %in% (top5)[1:2,]$bio_name)%>%select(weapon_one,weapon_two,strength,dexterity,defense,speed)


# Analise descritiva

# Histograma: Aparentemente tem distribuição normal
hist(data$winrate,breaks = 20)
shapiro.test(data$winrate)

mean(data$winrate)
sd(data$winrate)

mean(as.numeric(data$damagedealt)/data$games)
mean(as.numeric(data$damagetaken)/data$games)



#Visualizando o winrate
data%>%
  ggplot(aes(x=reorder(legend_name_key,winrate),y=winrate))+
  geom_col()+coord_flip()+geom_hline(yintercept = 50,color="red")+
  scale_y_continuous(limits=c(0,max(data$winrate)+1),breaks=seq(0,65,5))+labs(y="Taxa de vitória",x="Personagem")

#Visualizando os danos
data%>%
  ggplot(aes(x=dano_causado,y=winrate))+
  geom_point()
data%>%
  ggplot(aes(x=dano_recebido,y=winrate))+
  geom_point()


#Visualizando os níveis

data%>%
  ggplot(aes(x=level,y=winrate))+
  geom_point()
data%>%
  ggplot(aes(x=kothrownitem,y=winrate))+
  geom_point()

