library(leaflet)
library(ggmap)
library(ggplot2)
dat = geocode ("230011")
leaflet(dat) %>% addTiles() %>% addMarkers(~lon, ~lat)


# need a function for round(x, digit)
