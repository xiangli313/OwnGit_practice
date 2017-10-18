## Typically:
## the ui part would be save in ui.R
## the server section in server.R
## The app would be run using runApp()

library("shiny")
ui = fluidPage(
  titlePanel("I love movies"), #title
  ## Sidebar with a slider input for no. of points
  sidebarLayout( 
    sidebarPanel(
      selectInput("movie_type", label = "Movie genre", c("Romance", "Action", "Animation"))
    ),
    ## Show a plot of the generated distribution
    mainPanel(plotOutput("scatter"))
  )
)
