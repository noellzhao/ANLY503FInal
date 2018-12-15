library(plotly)
library(reshape2)
df <- read.csv('3d_plt.csv')


p <- plot_ly(x = df$Volume, y = df$GDP, z = df$Population,name='Country',text = df$NAME) %>%
  add_markers()%>%
  layout(title='Relationship Between Stock Market Volume, GDP and Population',
         scene = list(xaxis = list(title = 'Stock Market Volume (US $)'),
                      yaxis = list(title = 'GDP (US $)'),
                      zaxis = list(title = 'Population')))

chart_link = api_create(p, filename="3d_rotatable2")
chart_link

