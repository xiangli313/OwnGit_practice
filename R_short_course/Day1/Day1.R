# morning session

library(microbenchmark)

microbenchmark(
  code_a,
  code_b
)

x <- 1:10
microbenchmark(
sum(x^2),
{
total<-0
for (i in x){
  total = total +i^2
}
}
)

# this compares the calculation time

max(x = 1:3)
x
max(x <- 1:3)
x

# '<-' always define a variable

# 'alt' + '-' gives '<-' 

# (x = 5)
# x = 5
# the differnence between these two is that the first one prints x

library(leaflet)
library(ggmap)
library(ggplot2)
dat = geocode ("YO1 8AQ")
leaflet(dat) %>% addTiles() %>% addMarkers(~lon, ~lat)


x = 0; y =0
if(x == 0 & y == 1){
  message("x and y are 0s")
}

is_even <- function(x){
  if ( x%%2 == 0 ) {
    return(TRUE)
    } else { return(FALSE)}
}

round_xl <- function(x, digit){
if (digit == 0){
  return(ceiling(x))
}else{
 return(round(x,digit)) 
}
}

x <- seq(-1,1,0.025)
x
round(x,1)
sapply(x, digit = 2, round_xl)

rm(list = ls())
x = 115
ceiling(x)

# afternoon session
data(movies, package = "ggplot2movies")

head(movies, 3)
names(movies)

grep("[r1 - r10]", names(movies))

apply( multidimentional object (dataframe, matrix, sd array), dimention to excute, function)
tapply ( vector of data, vector to identify groups, function)
lapply(1d (list or vector), function)
sapply(1d (list or vector), function, simplify =TRUE)
eapply(collection of enviroments, function(named values in enviromments))

# on window
library(parallel)
cl = makeCluster(detectCores() - 1)
clusterExport()
parLapply(cl, X, FUN)
stopCluster()

##non-windows
FUN <- function(x){x^2}
mclapply(1:10, FUN, mc.cores = detectCores() -1)



####
example(plot)
colours()
plot( runif(1000), runif(1000), col = rainbow(100), pch = 19)

rainbow(7)
rgb(.170, .200, .100)
?rgb


# dataframe

which() is faster than data$col == sth. because which() records the row number,
which data$col == sth records all rows (as T/F)

data(movies, package = "ggplot2movies")
library(dplyr)
a = filter(movies, Action == 1)


install.packages("roxygen2")







round_num <- function(x, digit){
    ob = x*10^(digit+1)
    main = as.integer(ob) 
    remain = main - as.integer(main/10)
    if(remain == 5) 
}
x  = 0.15
digit =1
round_num(x, digit)

format(round(x, 0), nsmall = 2)
