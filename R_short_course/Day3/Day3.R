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
