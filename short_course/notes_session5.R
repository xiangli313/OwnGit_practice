## Functionals Chap 11.

# difference
?apply
?lapply
?vapply
?sapply
?tapply
?mapply

?runif

# play with mtcar and iris
?iris
dat <- iris

# what does package microbenchmark do

?dplyr
library(dplyr)

tapply(mtcars$mpg, mtcars$cyl, mean)
mtcars %>%
  dplyr:: group_by(cyl) %>%
  dplyr::summarise(mpg = mean(mpg))


# do call faster than reduce in terms of merge/rbind when you combined with reduce
?do.call()
?Reduce()

# data <- do.call("rbind", data) <- this helps, similar to refuce you used

a <- outer(1:10, 1:10, "-")
?lower.tri()
?upper.tri()
lower.tri(a)


# parallel package
# it depends on where you work - on your laptop, only 4 cores; more useful when using clusters
slowdouble <- function(n){
  message(n)
  Sys.sleep(sqrt(n))
  n * 2
}

x <- sample(10)
lapply(x, slowdouble)
parallel::mclapply(x, slowdouble, mc.cores = 10)

cl <- parallel::makeCluster(10) # clusters will close once the r session is closed
parallel::parLapply(cl, x, slowdouble)

install.packages("parallel")

system.time()
proc.time()

Sys.info()
