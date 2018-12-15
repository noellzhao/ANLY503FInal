

#Histogram
library(plotly)
data = read.csv('stockTrade.csv')
x = data$Country.Name
y = data$X2017
p <- plot_ly(y=y, x=x, type = "bar",
             marker = list(color = 'rgb(158,202,225)',
                           line = list(color = 'rgb(8,48,107)',
                                       width = 1.5))) %>%
  layout(title = "Total Stock Trade in US$",
         xaxis = list(title = ""),
         yaxis=list(type='linear'))
chart_link = api_create(p, filename="bar-text")
chart_link

#ggplot2 with 3 layers
#1
library(ggplot2)
data1 = read.csv('ggplot2.csv')
p=ggplot(data1, aes(unemployment, stock.trade)) + 
  geom_point() +
  geom_smooth(aes(colour = "loess"), method = "loess", se = FALSE) + 
  geom_smooth(aes(colour = "lm"), method = "lm", se = FALSE)
p = p + labs(y = 'Stock Trade Volume in US$', 
             x = 'Unemployment Rate(%)', 
             color='Method',
             title = 'General Relation between Unemployment and Stock Market')+
  theme(plot.title = element_text(size=15,hjust = 0.5))
p


#2

p=ggplot(data1, aes(unemployment, stock.trade, colour = stock.volume)) + 
  geom_point() + 
  geom_smooth(se = FALSE)+
  geom_rug()
p = p + labs(y = 'Stock Trade Volume in US$', 
             x = 'Unemployment Rate (%)', 
             color = 'Stock Volume Level',
             title = 'Relationship between Unemployment and Stock Market')+
  theme(plot.title = element_text(size=15,hjust = 0.5))
p



#3
library(gridExtra)
data2 = read.csv('stockTrade_ggplot.csv')
p <- ggplot(data = data2, mapping = aes(x = year, y = trade.vol, group = Country,color=Country))
p <- p + geom_path()+geom_point()+geom_abline(intercept = 900000000000)
p = p + labs(y = 'Stock Trade Volume in US$', 
             x = 'Year', 
             title = 'Stock Volume in Different Countries')+
  theme(plot.title = element_text(size=15,hjust = 0.5))


p1=ggplot(data = data2, mapping = aes(y = trade.vol,x=Country,group=Country))+
  geom_violin(size=1,color="darkblue",alpha=0.8)+
  geom_count(color="darkorange",alpha=0.6)+
  geom_abline(intercept = 900000000000,color='darkblue',size=1.5,alpha=0.6)
p1 = p1 + labs(y = 'Trade Volume in US$', 
             x = 'Country', 
             title = 'Volin Chart of Stock Trade by Countries')+
  theme(plot.title = element_text(size=15,hjust = 0.5))
grid.arrange(p,p1,nrow=1)
