### graphics
drat::addRepo("jr-packages")
install.packages("jrGgplot2")

vignette("practical1", package = "jrGgplot2")
library("jrGgplot2")
library("ggplot2")
data(Beauty)
head(Beauty, 2)
names(Beauty)



### scatter plot
# expr 1
ggplot(data=Beauty) + geom_point(aes(x=age, y=beauty))
#expr 2
g = ggplot(data=Beauty)
g1 = g + geom_point(aes(x=age, y=beauty))
g1
# aesthetics
g + geom_point(aes(x=age, y=beauty, colour=gender))

g + geom_point(aes(x=age, y=beauty,
                   alpha=minority, colour=gender))
## alpha controls the transparency

# Some aesthetics, like shape must be discrete
g + geom_point(aes(x=age, y=beauty,
                   alpha=evaluation, colour=gender, shape=factor(tenured)))
g + geom_point(aes(x=age, y=beauty,
                   alpha=evaluation, colour=gender, shape=tenured)) # therefore, this one gives error

g + geom_point(aes(x=age, y=beauty, colour=factor(tenured)))
g + geom_point(aes(x=age, y=beauty, colour=tenured))

### compare the blow two plots
g + geom_point(aes(x=age, y=beauty, colour="blue"))
# here "blue" is treated as a single factor
g + geom_point(aes(x=age, y=beauty), colour="blue")
# to have "blue" points, you need to have it outside of aesthetic function

g + geom_point(aes(x=age, y=beauty, colour=2))
g + geom_point(aes(x=age, y=beauty), colour=2)


#### boxplot
g + geom_boxplot(aes(x=gender, y=beauty))

g + geom_boxplot(aes(x=gender, y=beauty,
                     colour=factor(tenured)))
g + geom_boxplot(aes(x=gender, y=beauty,
                     colour=tenured)) # this is not working as wanted, because colour is discreat

#### combining plots
### layers defined by the sequence of geom
g + geom_boxplot(aes(x=gender, y=beauty,
                     colour=factor(tenured))) +
  geom_point(aes(x=gender, y=beauty))

g + geom_point(aes(x=gender, y=beauty)) +
      geom_boxplot(aes(x=gender, y=beauty,
                     colour=factor(tenured))) 

g + geom_boxplot(aes(x=gender, y=beauty,
                     colour=factor(tenured))) +
  geom_jitter(aes(x=gender, y=beauty))

g + geom_jitter(aes(x=gender, y=beauty, colour=factor(tenured))) + 
    geom_boxplot(aes(x=gender, y=beauty,
                     colour=factor(tenured))) 

#### barplot
g + geom_bar(aes(x=factor(tenured)))

Beauty$dec = factor(signif(Beauty$age, 1))
g = ggplot(data=Beauty)
g + geom_bar(aes(x=gender, fill=dec))

### 
dodge 
fill
identity
jitter
Stack 

g + geom_bar(aes(x=gender, fill=dec),
             position="dodge")



#######
# ggplot(data = <your_data>, mapping = aes(<default_settings>))
# this points to a copy of your data, and set up defaut aesthetics for later plot development
data(bond)
names(bond)
g = ggplot(bond, aes(x = Alcohol, y = Kills))
g + geom_boxplot(aes(fill = Actor))


g = ggplot(bond, aes(x=Actor, y=Alcohol_Units))
g + geom_boxplot(aes(fill = Actor))
g + geom_boxplot(aes(group = Actor))
g + geom_boxplot(aes(colour = Actor))

g + geom_boxplot(aes(fill = Nationality))
g + geom_boxplot(aes(group = Nationality))
g + geom_boxplot(aes(colour = Nationality))

g + geom_boxplot(aes(fill = Actor, weight = Kills))

g + geom_boxplot(aes(fill = Actor))+ coord_flip()

geom_text()




###### geom_ and stat_ 
g = ggplot(bond, aes(x = Alcohol_Units, y = Kills))

g + stat_smooth(method = "loess", aes(colour = Nationality), span =1, se = TRUE ) 

g + stat_smooth(method = "lm", aes(colour = Nationality), span =1, se = TRUE) 



####
library("jrGgplot2")
library("ggplot2")
df = overplot_data(n=20000)
ggplot(df) + geom_point(aes(x, y))

ggplot(df) + geom_point(aes(x, y), colour="red", shape="k", alpha = 1)

ggplot(df) + geom_point(aes(x, y, shape="."), alpha=1.e-1, colour="red")

df$z = round(df$y, 1)
df$w = round(df$y, 0)
ggplot(df) + geom_bar(aes(z, colour=w)) +
    coord_flip()

ggplot(df) + geom_point(aes(x, y)) +
  stat_density2d(aes(x,y, fill=..density..),
                 contour=FALSE, geom="tile")


### 
data("diamonds", package = "ggplot2")

# ggplot(data=diamonds) +
#   geom_histogram(aes(x=depth), binwidth=sd(diamonds$depth)*0.1)

data(movies, package = "ggplot2movies")
ggplot(movies, aes(x=length)) + xlim(0, 200) +
  geom_histogram(aes(y=..density..), binwidth=3) +
  facet_grid(Comedy ~ ., margins = TRUE)

library(plyr)
movies$decade = round_any(movies$year, 10, floor)

ggplot(movies, aes(x=length)) + geom_histogram() +
  facet_wrap( ~ decade, ncol=6) + xlim(0, 200)



library("ggjoy")
ggplot(movies,
       aes(x = length, y=year, group=year, height = ..density..)) +
  geom_joy(scale = 10, alpha = 0.7) +
  theme_joy(grid=FALSE) +
  scale_x_log10(limits = c(1, 500),
                breaks = c(1, 10, 100, 1000),
                expand = c(0.01, 0)) +
  scale_y_reverse(breaks = seq(2000, 1900, by = -20),
                  expand = c(0.01, 0))


ggplot(movies,
       aes(x = length, y=year, group=year, height = ..density..)) +
  geom_joy(scale = 10, alpha = 0.7) +
   theme_joy(grid=FALSE) +
   scale_x_log10(limits = c(1, 500),
                 breaks = c(1, 10, 100, 1000),
                 expand = c(0.01, 0)) #+
  # scale_y_reverse(breaks = seq(2000, 1900, by = -20),
  #                 expand = c(0.01, 0))



#####

data(aphids, package="jrGgplot2")
names(aphids)
g = ggplot(data=aphids, aes(x=Time, y=Aphids))
g + geom_line(aes(colour=factor(Block)), linetype=6) +
  facet_grid( Nitrogen ~ Water ) +
  scale_colour_manual(name = "Block", 
                      values =factor(aphids$Block))


RColorBrewer::display.brewer.all()

scale_*_gradient creates a two colour gradient (low-high), 
scale_*_gradient2 creates a diverging colour gradient (low-mid-high), 
scale_*_gradientn creats a n-colour gradient.

## scale_fill_*
ggplot(bond, aes(x=Actor, y=Alcohol_Units)) +
  geom_boxplot(aes(fill=Actor)) +
  scale_fill_brewer(palette = "PRGn")

data(raster_example)
raster_example$w = round(raster_example$z,1)
ggplot(raster_example, aes(x, y)) +
  geom_raster(aes(fill=z)) +
  scale_fill_gradient(low= "pink", high="blue") 
  #scale_fill_gradient2(low= "pink", mid="yellow", high="orange", midpoint=0.5) 

+   guides(fill=FALSE) # this removes the lend



library(gridExtra)

d = data.frame(x = 1:10, y = -1:-10, z = 1:10)
g1 = ggplot(d)
g2 = plot(2,2)
library(grid)
vplayout = function(x, y){
  viewport(layout.pos.row = x, layout.pos.col = y)
}
pushViewport( viewport(layout = grid.layout(100, 100)))
  print(g1, vp = vplayout(1:100, 1:100))
  print(g2, vp = vplayout(1:100, 1:100))

  
##### example find functions of a package  
(names=  getNamespaceExports("ggplot2"))
  names[order(names)]
  names[grepl("geom_p", names)]
  
  
  
  # library(hrbrthemes)
  # library(dplyr)
  g = count(data, column_1) %>%
    mutate(n=n) %>%
    arrange(n) %>%
    mutate()
  
  
  %>% is a function from library - magrittr
  it takes an object on the left and passes the object to a function on the right as its first argument