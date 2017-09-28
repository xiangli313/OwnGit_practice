library(leaflet)
library(ggmap)
library(ggplot2)
dat = geocode ("230011")

dat = ggmap::geocode(
  c("LS21 3DS", 
    "Imperial College London"))

leaflet(dat) %>% addTiles() %>% addMarkers(~lon, ~lat)


round_xl <- function(x, digit = 0){
  sig <- sign(x)
  x <- abs(x)
  pow = 10^digit
  tmp = x * pow *10
  tmp2 = x * pow
  tmp3 = as.integer(tmp2)
  tmp4 = tmp - tmp3*10
  if( tmp4 >= 5){ out = tmp3 + 1} else {out = tmp3}
  out = out/pow*sig
  return(out)
}

round_vec_xl <- function(x, digit){
  sapply(x,digit = digit,round_xl)
}

