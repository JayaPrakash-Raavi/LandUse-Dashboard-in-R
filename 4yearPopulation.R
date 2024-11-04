library(ggplot2)
library(plotly)
library(plyr)
library(flexdashboard)
library(leaflet)
library(sf)
library(readr)
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)
library(readxl)

# create some data
# Load the shapefile
shape_data <- st_read("./TAZ_Shapefile/TN_TAZ_2010.shp")

shape_data <- st_transform(shape_data, 4326)



# Load the CSV file
data_2015 <- read_excel("./Forecasts_test/Forecasting_Result_2015_TDM.xlsx")
data_2018 <- read_excel("./Forecasts_test/Forecasting_Result_2018_TDM.xlsx")
data_2020 <- read_excel("./Forecasts_test/Forecasting_Result_2020_TDM.xlsx")
data_2025 <- read_excel("./Forecasts_test/Forecasting_Result_2025_TDM.xlsx")
data_2030 <- read_excel("./Forecasts_test/Forecasting_Result_2030_TDM.xlsx")
# Add year to all column names
column_names_2015 <- paste0(names(data_2015), "_", "2015")
column_names_2018 <- paste0(names(data_2018), "_", "2018")
column_names_2020 <- paste0(names(data_2020), "_", "2020")
column_names_2025 <- paste0(names(data_2025), "_", "2025")
column_names_2030 <- paste0(names(data_2030), "_", "2030")

names(data_2015) <- column_names_2015
names(data_2018) <- column_names_2018
names(data_2020) <- column_names_2020
names(data_2025) <- column_names_2025
names(data_2030) <- column_names_2030

left_join_result <- left_join(data_2015, data_2018, by = c("TAZ_ID_2015" = "TAZ_ID_2018")) %>%
  left_join(data_2020, by = c("TAZ_ID_2015" = "TAZ_ID_2020")) %>%
  left_join(data_2025, by = c("TAZ_ID_2015" = "TAZ_ID_2025")) %>%
  left_join(data_2030, by = c("TAZ_ID_2015" = "TAZ_ID_2030"))

# Ensure the key columns are of the same data type

data <- left_join(shape_data, left_join_result, by = c("TAZID" = "TAZ_ID_2015"))

library(leaflet)

# Assuming merged_data has a geometry column for plotting with leaflet
# and TOTPOP is the total population you want to color by

# Create a color palette for TOTPOP
popPalette <- colorNumeric(palette = "Oranges", domain = data$TOTPOP_2015)

leaflet(data) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~popPalette(TOTPOP_2015),  # Color by total population
    color = NA,  # Set border color to transparent
    weight = 1,  # Border width
    opacity = 1,  # Border opacity
    fillOpacity = 0.7,  # Fill opacity
    highlightOptions = highlightOptions(
      weight = 2,
      color = NA,
      fillOpacity = 0.9,
      bringToFront = TRUE,
      
    ),group="2015",
    label = ~paste("Population:", TOTPOP_2015),  # Show population on hover
    labelOptions = labelOptions(
      style = list("font-weight" = "normal"),
      textsize = "13px",
      direction = "auto"
    )
  ) %>%
  addPolygons(
    fillColor = ~popPalette(TOTPOP_2018),  # Color by total population
    color = NA,  # Set border color to transparent
    weight = 1,  # Border width
    opacity = 1,  # Border opacity
    fillOpacity = 0.7,  # Fill opacity
    highlightOptions = highlightOptions(
      weight = 2,
      color = NA,
      fillOpacity = 0.9,
      bringToFront = TRUE
      
    ),group="2018",
    label = ~paste("Population:", TOTPOP_2018),  # Show population on hover
    labelOptions = labelOptions(
      style = list("font-weight" = "normal"),
      textsize = "13px",
      direction = "auto"
    )
  ) %>%
   addPolygons(
    fillColor = ~popPalette(TOTPOP_2020),  # Color by total population
    color = NA,  # Set border color to transparent
    weight = 1,  # Border width
    opacity = 1,  # Border opacity
    fillOpacity = 0.7,  # Fill opacity
    highlightOptions = highlightOptions(
      weight = 2,
      color = NA,
      fillOpacity = 0.9,
      bringToFront = TRUE
      
    ),group="2020",
    label = ~paste("Population:", TOTPOP_2020),  # Show population on hover
    labelOptions = labelOptions(
      style = list("font-weight" = "normal"),
      textsize = "13px",
      direction = "auto"
    )
)%>%
  addPolygons(
    fillColor = ~popPalette(TOTPOP_2025),  # Color by total population
    color = NA,  # Set border color to transparent
    weight = 1,  # Border width
    opacity = 1,  # Border opacity
    fillOpacity = 0.7,  # Fill opacity
    highlightOptions = highlightOptions(
      weight = 2,
      color = NA,
      fillOpacity = 0.9,
      bringToFront = TRUE
      
    ),group="2025",
    label = ~paste("Population:", TOTPOP_2025),  # Show population on hover
    labelOptions = labelOptions(
      style = list("font-weight" = "normal"),
      textsize = "13px",
      direction = "auto"
    )
)%>%
  addLegend(
    position = "bottomright",
    pal = popPalette,
    values = ~TOTPOP_2018,
    title = "Total Population",
    opacity = 0.7
  )%>%
  addLayersControl(baseGroups = c("2015","2018","2020","2025"),options = layersControlOptions(collapsed= F))

