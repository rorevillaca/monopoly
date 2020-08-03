library(tidyverse)
library(hrbrthemes)
library(openxlsx)
library(magrittr)
library(extrafont)
library(ggnewscale)
library(cowplot)
library(ggforce)


#ROI

property_attributes <- read.xlsx("C:/Users/rodrigo.revilla/Desktop/monopoly/property_attributes.xlsx")
streets <- property_attributes %>% filter(type=="streets") %>% mutate(rent = as.numeric(rent))

streets %<>% mutate(roi_no_houses=rent/printed_price) %>%
  mutate(roi_one_house=(rent_with_one_house)/(printed_price+building_costs*1)) %>% 
  mutate(roi_two_houses=(rent_with_two_houses)/(printed_price+building_costs*2)) %>% 
  mutate(roi_three_houses=(rent_with_three_houses)/(printed_price+building_costs*3)) %>%
  mutate(roi_four_houses=(rent_with_four_houses)/(printed_price+building_costs*4)) %>% 
  mutate(roi_hotel=(rent_with_hotel)/(printed_price+building_costs*5))
                   
payback_period_streets <- streets %>% select(-roi_no_houses,-roi_one_house,-roi_two_houses,-roi_three_houses,-roi_four_houses,-roi_hotel)

#PAYBACK PERIOD WITH NO BUIDLINGS
a <- payback_period_streets %>% select(name,type,color_code,id,rent,printed_price) %>%
  mutate(landed_35=rent*35-printed_price) %>% 
  ggplot() +
  geom_hline(aes(yintercept=0),size=1,color="gray70")+
  geom_segment(aes(x=0,y=-printed_price,xend=35,yend=landed_35,color=color_code),size=1.2)+
  scale_color_identity()+
  scale_y_continuous(labels=scales::comma,breaks=seq(-1000,2000,250))+
  scale_x_continuous(breaks=seq(0,35,5),expand=expansion(mult=c(0,0),add=c(1,0)))+
  geom_text(aes(x=4.7,y=125,label="Shortest payback period"),size=4,color="gray60")+
  geom_segment(aes(x=8,y=10,xend=6,yend=100),color="gray60",size=0.75)+
  labs(y="Earnings ($)",x="Number of Landings",title="Earnings vs. number of landings per property - 0 buildings")+
  theme_minimal()+
  theme(axis.title.x = element_text(hjust = 0, vjust=0, colour="darkgrey",size=12,face="bold"))+
  theme(axis.title.y = element_text(hjust = 0, vjust=3, colour="darkgrey",size=12,face="bold"))+
  theme(plot.margin = margin(t = .1, r = 2, b = 0.1, l = 0.1, unit = "in"))
additional_elements <- ggdraw(a)
additional_elements <- additional_elements + draw_label("BOARDWALK",y=0.91,x=0.81,color="#0072ba",size=12,fontfamily="Kabel-Heavy",hjust = 0)
additional_elements <- additional_elements + draw_label("PARK PLACE",y=0.69,x=0.81,color="#0072ba",size=12,fontfamily="Kabel-Heavy",hjust = 0)
additional_elements <- additional_elements + draw_label("PENNSYLVANIA AVE.",y=0.61,x=0.81,color="#1fb259",size=12,fontfamily="Kabel-Heavy",hjust = 0)
additional_elements <- additional_elements + draw_label("PACIFIC AVE.",y=0.59,x=0.81,color="#1fb259",size=12,fontfamily="Kabel-Heavy",hjust = 0)
additional_elements <- additional_elements + draw_label("NORTH CAROLINA AVE.",y=0.57,x=0.81,color="#1fb259",size=12,fontfamily="Kabel-Heavy",hjust = 0)
additional_elements <- additional_elements + draw_label("MEDITERRANEAN AVE.",y=0.3,x=0.81,color="#955537",size=12,fontfamily="Kabel-Heavy",hjust = 0)
additional_elements <- additional_elements + draw_label("BALTIC AVE.",y=0.34,x=0.81,color="#955537",size=12,fontfamily="Kabel-Heavy",hjust = 0)
additional_elements

#PAYBACK PERIOD ADJUSTED FOR LANDING PROBABILITY w HOTEL

a <- payback_period_streets %>% 
  mutate(value_at_100=((100*rent_with_hotel)/(1/landing_probability))-printed_price-5*building_costs) %>% 
  ggplot() +
  geom_hline(aes(yintercept=0),size=1,color="gray70")+
  geom_segment(aes(x=0,y=-printed_price-5*building_costs,xend=100,yend=value_at_100,color=color_code),size=1.2)+
  scale_color_identity()+
  scale_y_continuous(labels=scales::comma)+
  scale_x_continuous(breaks=seq(0,100,10),expand=expansion(mult=c(0,0),add=c(1,0)))+
  labs(y="Earnings ($)",x="Number of turns",title="Earnings vs. number of dice rolls - 1 hotel")+
  theme_minimal()+
  theme(axis.title.x = element_text(hjust = 0, vjust=0, colour="darkgrey",size=12,face="bold"))+
  theme(axis.title.y = element_text(hjust = 0, vjust=3, colour="darkgrey",size=12,face="bold"))+
  theme(plot.margin = margin(t = .1, r = 2, b = 0.1, l = 0.1, unit = "in"))
additional_elements <- ggdraw(a)
additional_elements <- additional_elements + draw_label("BOARDWALK",y=0.91,x=0.81,color="#0072ba",size=12,fontfamily="Kabel-Heavy",hjust = 0)
additional_elements <- additional_elements + draw_label("ILLINOIS AVENUE",y=0.725,x=0.81,color="#ed1b24",size=12,fontfamily="Kabel-Heavy",hjust = 0)
additional_elements <- additional_elements + draw_label("NEW YORK AVENUE",y=0.7,x=0.81,color="#f0932d",size=12,fontfamily="Kabel-Heavy",hjust = 0)
additional_elements <- additional_elements + draw_label("BALTIC AVENUE",y=0.44,x=0.81,color="#955437",size=12,fontfamily="Kabel-Heavy",hjust = 0)
additional_elements <- additional_elements + draw_label("MEDITERRANEAN AVE.",y=0.39,x=0.81,color="#955437",size=12,fontfamily="Kabel-Heavy",hjust = 0)
additional_elements




