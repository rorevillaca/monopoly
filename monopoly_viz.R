#Visualizing monopoly

library(tidyverse)
library(hrbrthemes)

#Data wrangling


#Generating dataframe
ymins <- c(rep(0,11),seq(1,5.5,0.5),rep(5.5,9),seq(5.5,1,-0.5))
ymaxs <- c(rep(1,10),seq(1,5.5,0.5),6.5,rep(6.5,10),seq(5.5,1.5,-0.5))
xmins <- c(seq(5.5,1,-0.5),rep(0,11),seq(1,5.5,0.5),rep(5.5,9))
xmaxs <- c(6.5,seq(5.5,1.5,-0.5),rep(1,11),seq(1.5,5.5,0.5),rep(6.5,10))
id<-seq(1,40)
tiles <- data.frame(xmins,xmaxs,ymins,ymaxs,id)

ymins <- c(rep(0.8,5),1,2,2.5,3.5,4.5,5,rep(5.5,6),5,4.5,3.5,2,1)
ymaxs <- c(rep(1,5),1.5,2.5,3,4,5,5.5,rep(5.7,6),5.5,5,4,2.5,1.5)
xmins <-c(5,4,2.5,1.5,1,rep(0.8,6),1,2,2.5,3.5,4,5,rep(5.5,5))
xmaxs <-c(5.5,4.5,3,2,1.5,rep(1,6),1.5,2.5,3,4,4.5,5.5,rep(5.7,5))
colors <- c(rep("#945438",2),rep("#abe0f8",3),rep("#d93a96",3),rep("#f7941d",3),rep("#ed1b24",3),rep("#fef200",3),rep("#20b15a",3),rep("#0172ba",2))
group_tiles <- data.frame(xmins,xmaxs,ymins,ymaxs,colors)

#Plot creation

ggplot()+
  geom_rect(data=tiles,aes(xmin=xmins,xmax=xmaxs,ymin=ymins,ymax=ymaxs,fill=id),color="black")+
  scale_fill_gradient()+
  new_scale_fill()+
  geom_rect(data=group_tiles,aes(xmin=xmins,xmax=xmaxs,ymin=ymins,ymax=ymaxs,fill=colors),color="black")+
  scale_fill_identity()+
  scale_y_continuous(limits=c(-0.5,7))+
  scale_x_continuous(limits=c(-0.5,7))+
  coord_fixed()+
  theme_void()

new_scale <- function(new_aes) {
  structure(ggplot2::standardise_aes_names(new_aes), class = "new_aes")
}
