# Load required libraries
library(shiny)
library(shinydashboard)
library(DT)  # For interactive tables

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Interactive Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Table", tabName = "data_table", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "data_table",
        fluidRow(
          box(
            title = "Interactive Data Table",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            DTOutput("data_table")
          )
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Load data
  data <- read.csv("./CSV_data/Forecasting_Result_2015_TDM.csv")  # Replace "your_file.csv" with the path to your CSV file
  
  # Render interactive data table
  output$data_table <- renderDT({
    datatable(data, options = list(scrollX = TRUE))
  })
  
}

# Run the application
app <- shinyApp(ui = ui, server = server)

# Save as HTML file
saveApp(app, file = "interactive_dashboard.html")
