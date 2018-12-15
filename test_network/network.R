library(networkD3)

edgelist <- read.csv('edgelist.csv')
nodelist <- read.csv('nodelist.csv')
nodelist$group = bin(nodelist$Rate, nbins = 2,labels = c("Under Developed Stock Market", "Highly Developed Stock Market"),method = "content")
forceNetwork(Links = edgelist, 
             Nodes = nodelist,
             Source = "SourceID", 
             Target = "TargetID",
             Value = "CosSim", 
             NodeID = "NodeName",
             opacity = 0.8,
             Nodesize='Rate',
             legend = TRUE,
             Group = "group",zoom=TRUE,
             colourScale = JS("d3.scaleOrdinal(d3.schemeCategory10);"),
             fontSize = 18,
             fontFamily = "serif", 
             linkDistance = 50
)