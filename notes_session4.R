#========R-book-club session 4: functional programming

# Not yet done any practices. Come here to take notes.
# web link for this chapter - http://adv-r.had.co.nz/Functional-programming.html

funs <- list(
  sum = sum,
  mean = mean,
  median = median
)
y <- 1:10
lapply(funs, function(f,object) f(object), y)

lapply(funs, function(object, f) f(object), object = y)
# both of the above work, interesting, but see if you can understand why they work - the form of the codes


# when two functions are of the same name, but if they are in different enviroment, they are different
# identical(fun_a, fun_b)

#match.fun() function
mapply() uses this

t<-mtcars$mpg
t[1]<-NA
mean(t)

#lapply changes names? check that

# sometimes , we just do not need the name of a function, that's why anonoymous function still matteres
#eg integrate(function() x^2, 0 ,10)


#?D
# this is something about symbolic integration differentiation

## ctrl + i rearange your codes

#interesting the ... in function
#eg 
read_csv <- function(...) {
  read.csv(...,stringsAsFactors = FALSE)
}
# or
read_csv<-purrr::partial(read,csv,stringsAsFactors = FALSE)

# functional programming makes your code nice and easy to read

#attach brings dataframe into the global enviroment - not a good way to do
#==
# seems to me it is crucial to understand environment
#==


