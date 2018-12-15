library(leaflet)
library(rgdal)
library(OneR)
worldmap <- readOGR(dsn = ".", layer = "TM_WORLD_BORDERS_SIMPL-0.3", stringsAsFactors = FALSE)# Look at the info provided with the geospatial object
#head(world_spdf@data)
#summary(world_spdf@data)

df <- read.csv('leatf.csv')
is.na(df$Volume) <- !df$Volume
df = df[complete.cases(df), ]
df = merge(worldmap,df,by='NAME')
df = df[complete.cases(df), ]
is.na(df$Volume) <- !df$Volume


vol_bin=c(0,1e+10,1e+11,5e+11,1e+12,5e+12,1e+13,Inf)
mypalette_1 = colorBin(palette="YlGnBu", domain=df$Volume, na.color="transparent", bins=vol_bin)

gdp_bin=c(0,1e+9,1e+10,5e+10,1e+11,5e+11,1e+12,5e+12,1e+13,Inf)
mypalette_2 = colorBin( palette="YlOrBr", domain=df$GDP, na.color="transparent", bins=gdp_bin)

#create a highlight text
mytext=paste("Country: ", df$NAME,"<br/>", "Stock Market Cap: ", round(df$Volume/1000000000,2), ' billion',"<br/>", "GDP:",round(df$GDP/1000000000,2),' billion', sep="") %>%
  lapply(htmltools::HTML)

#create pop up text
population_pop_up <- paste0("<strong>Country: </strong>", 
                            df$NAME, 
                            "<br><strong>Stock Market Cap: </strong>", 
                            df$Volume,
                            "<br><strong>GDP (in US Dollar): </strong>", 
                            df$GDP,
                            "<br><strong>Population: </strong>", 
                            df$Population)


gmap = leaflet(df) %>%
  addTiles()  %>%
  setView( lng=0, lat=0 , zoom=1) %>%
  #first layer
  addPolygons(
    fillColor = ~mypalette_1(df$Volume), stroke=TRUE, fillOpacity = 0.9, color="white", weight=0.3,
    highlight = highlightOptions( weight = 5, color = ~colorNumeric("Blues", df$Volume), dashArray = "", fillOpacity = 0.3, bringToFront = TRUE),
    label = mytext,
    labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", direction = "auto"),
    group="Stock Market Market Cap"
  ) %>%
  #second layer
  addPolygons(
    fillColor = ~mypalette_2(df$GDP), stroke=TRUE, fillOpacity = 0.9, color="white", weight=0.3,
    highlight = highlightOptions( weight = 5, color = ~colorNumeric("Blues", df$GDP), dashArray = "", fillOpacity = 0.3, bringToFront = TRUE),
    label = mytext,
    labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", direction = "auto"),
    group="GDP"
  ) %>%
  
  #marker layer
  addMarkers(data=df,lat=df$LAT, lng=df$LON, popup=population_pop_up, group = "Country Info") %>% 
  
  # Layers control
  addLayersControl(
    baseGroups = c("Stock Market Market Cap"),
    overlayGroups = c('GDP',"Country Info"),
    options = layersControlOptions(collapsed = FALSE)
  )

gmap
saveWidget(gmap, 'leaflet_map.html', selfcontained = TRUE)