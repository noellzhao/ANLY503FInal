library(shiny)
library(corrplot)
library(dplyr)
library(ggplot2)
library(rsconnect)
rsconnect::setAccountInfo(name='xz377', token='D232117E18E3499AD89F2F46E76D77F9', secret='nhiEtJj+fihvJ1HQupVQP3tS7fF569ycbfKVtKeM')
df <- read.csv('stockTrade.csv')

ui <- fluidPage(
  column(12,offset = 3, titlePanel("Stock Trade by Country")),
  column(12,offset = 3,
         sidebarPanel(
           sliderInput('year_choice','Choose Year',
                        min = 2012, max = 2017, value = 2017
                        ),
           width = 5
         )
  ),

  column(12,
  mainPanel(
    plotOutput('hist',height = "500px",width = "800px")
    
  )
  )
  
  
  
)
server <- function(input, output, session) {
  selectData = reactive({
    df = subset(df, year==input$year_choice)
    return(df)
  })

  output$tot_table <- renderDataTable(selectData(),options = list(pageLength = 10))
    
  output$hist <- renderPlot({
    ggplot(data=selectData(),
           aes(Country))+
      geom_bar(aes(weight = volume))+
      labs(y = 'Stock Trade in total (in trillon USD)', 
           x = 'Country')+
      ggtitle("Stock Trade by Country")+
      theme(plot.title = element_text(size=18,hjust = 0.5))

  })
  
  
  
}

shinyApp(ui, server)

