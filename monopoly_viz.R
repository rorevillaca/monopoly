#Visualizing monopoly

library(tidyverse)
library(hrbrthemes)
library(openxlsx)
library(magrittr)
library(extrafont)
library(ggnewscale)
library(cowplot)

font_import(paths = c("C:/Users/rodrigo.revilla/AppData/Local/Microsoft/Windows/Fonts", prompt = F))
install.packages("extrafontdb")
loadfonts()

#Data wrangling


#Generating dataframe
ymins <- c(rep(0,11),0.4,seq(1,5.5,0.5),rep(5.5,9),seq(5.5,1,-0.5))
ymaxs <- c(rep(1,11),1,seq(1.5,5.5,0.5),6.5,rep(6.5,10),seq(5.5,1.5,-0.5))
xmins <- c(seq(5.5,1,-0.5),0,0.4,rep(0,10),seq(1,5.5,0.5),rep(5.5,9))
xmaxs <- c(6.5,seq(5.5,1.5,-0.5),rep(1,12),seq(1.5,5.5,0.5),rep(6.5,10))
id<-c(seq(0,10),10.5,seq(11,39))
tiles <- data.frame(xmins,xmaxs,ymins,ymaxs,id)

ymins <- c(rep(0.8,5),1,2,2.5,3.5,4.5,5,rep(5.5,6),5,4.5,3.5,2,1)
ymaxs <- c(rep(1,5),1.5,2.5,3,4,5,5.5,rep(5.7,6),5.5,5,4,2.5,1.5)
xmins <-c(5,4,2.5,1.5,1,rep(0.8,6),1,2,2.5,3.5,4,5,rep(5.5,5))
xmaxs <-c(5.5,4.5,3,2,1.5,rep(1,6),1.5,2.5,3,4,4.5,5.5,rep(5.7,5))
colors <- c(rep("#945438",2),rep("#abe0f8",3),rep("#d93a96",3),rep("#f7941d",3),rep("#ed1b24",3),rep("#fef200",3),rep("#20b15a",3),rep("#0172ba",2))
group_tiles <- data.frame(xmins,xmaxs,ymins,ymaxs,colors)

simulation_results <- read.csv2('C:/Users/rodrigo.revilla/Desktop/simulation_results.csv',sep=",",header=FALSE)
simulation_results %<>% group_by(V2) %>% summarise(n=n()) %>% ungroup()
simulation_results %<>% mutate(percentage=n/sum(simulation_results$n)) 
simulation_results %<>% mutate(V2 = V2 %>% as.character() %>% as.numeric())

tiles  %<>%  left_join(simulation_results %>% select(-n),by=c("id"="V2"))
tiles  %<>%  mutate(perc_label = scales::percent(percentage,accuracy = 0.1),x_lab=xmins+(xmaxs-xmins)/2,y_lab=ymins+(ymaxs-ymins)/2)
tiles  %<>%  mutate(y_lab=ifelse(id%in%c(0,10),0.250,y_lab)) %>% mutate(y_lab=ifelse(id%in%c(10.5),0.8,y_lab))


#Plot creation

a<-ggplot()+
  geom_rect(data=tiles,aes(xmin=xmins,xmax=xmaxs,ymin=ymins,ymax=ymaxs,fill=percentage),color="white")+
  scale_fill_continuous(low = "#fde5d9",high = "#c41e1e",labels = scales::percent_format(accuracy=0.1),name="Probability",guide=guide_legend(keywidth = 1))+
  new_scale_fill()+
  geom_rect(data=group_tiles,aes(xmin=xmins,xmax=xmaxs,ymin=ymins,ymax=ymaxs,fill=colors),color="white")+
  scale_fill_identity()+
  geom_text(data=tiles,aes(x=x_lab,y=y_lab,label=perc_label,color=ifelse(id%in%c(0,10.5),"white","black")),size=4,fontface="bold")+
  scale_color_manual(values=c("black","white"),guide=FALSE)+
  geom_label(aes(x=6.5/2-0.35,y=(6.5/2)+1.3,label="THE PROBABILITIES OF"),size=5,color="white",fill="gray60",family="Kabel-Heavy",label.padding = unit(0.4,"lines"))+
  geom_label(aes(x=6.5/2,y=(6.5/2)+0.9,label="MONOPOLY"),size=12,color="white",fill="#ee1b24",family="Kabel-Heavy",label.padding = unit(0.5,"lines"))+
  geom_text(aes(x=6.5/2,y=2.4,label="SPACE COLOR INDICATES THE RELATIVE \n PROBABILITY OF LANDING ON IT OVER \n500,000 SIMULATIONS OF THE GAME\n\nConsiders dice rolls, 'the three-doubles rule',\nCommunity Chest and Chance Cards, and \nlanding on the 'Go To Jail' Tile"),fontface="bold",color="gray50")+
  geom_text(aes(x=6,y=0.6,label="GO"),color="white",family="Kabel-Heavy",size=5)+
  geom_text(aes(x=0.7,y=0.62,label="JAIL"),color="white",family="Kabel-Heavy",size=3)+
  geom_text(aes(x=2.75,y=5.25,label="ILLINOIS AVE."),family="Kabel-Heavy",size=4,color="gray55")+
  geom_segment(aes(x=2.75,y=5.48,xend=2.75,yend=5.35),size=0.8,color="gray60")+
  geom_segment(aes(x=6.2,y=0.45,xend=5.8,yend=0.45),color="white",arrow = arrow(length = unit(0.15, "cm")),size=0.6)+
  scale_y_continuous(limits=c(-0.5,7),expand=c(-.05,-.05))+
  scale_x_continuous(limits=c(-0.5,7),expand=c(-.05,-.05))+
  coord_fixed()+
  theme_void()+
  theme(legend.position = "bottom",legend.margin=margin(unit(0,"cm")))
  
additional_elements <- ggdraw()
additional_elements <- additional_elements + draw_label("github.com/Rorevilla", x = 0.89, y = 0.04,colour = "gray50",fontface="bold",size=8.5)

final_plot<-additional_elements+draw_plot(a+ theme(plot.margin = margin(t = 0, r = 0, b = 0, l = 0, unit = "in")))

new_scale <- function(new_aes) {
  structure(ggplot2::standardise_aes_names(new_aes), class = "new_aes")
}
