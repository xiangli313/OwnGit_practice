# Practical 1
# Jumping Rivers
# September 14, 2017
# Practical 1
# The aim of this practical is to understand the syntax of functions and
# loops. In practical 2, we will use this knowledge in a larger example.
# Basic functions
# Consider the following simple function
v = 5
Fun1 = function() {
  v = 0
  return(v)
}
Fun1()
# 1. Why does the final line return 0 and not 5.
## function reads local variable first

# 2. Delete line 3 in the above piece of code. Now change Fun1() to
# allow v to be passed as an argument, i.e. we can write Fun1(5).
# Call this function to make sure it works.
v = 5
Fun1 = function(v) {
  return(v)
}
Fun1(5)


# Default arguments:
  Fun2 = function(x = 10) {
    return(x)
  }
Fun3 = function(x) {
  return(x)
}
# 1. Why does
Fun2()
# work, but this raises an error
Fun3()

# because Fun2 has x =10 as default

# 2. Change Fun2 so that it returns x*x.
Fun2 = function(x = 10) {
  return(x^2)
}
Fun2(2)
#practical 1
# if statements.
Fun4 = function(x) {
  if (x == 5) {
    y = 0
  } else {
    y = 1
  }
  return(y)
}
Fun4(2)
# Change Fun4 so that it:
#   • returns 1 if x is positive;
# • returns -1 if x is negative;
# • returns 0 if x is zero.

Fun4 = function(x) {
  if (x > 0) {
    return(1)
  } else if (x < 0 ){
    return(-1)
  } else { return(0) }
}
Fun4(0)

# for loops.
total = 0
for (i in 1:5) {
  total = total + i
}
total
# The for loop above calculates
# 5
# ∑
# i =1+2+3+4+5
# i=1
# 1. What is the final value of total in the above piece of code?
# 2. Change the above loop to calculate the following summations:
#   (i)
# 20
# ∑
# (i + 1)
# i=1
# (ii)
# 15
# ∑
# j
# j=−10

total = 0
for (i in 1:20) {
  total = total + i +1
}
total

total = 0
for (i in -10:15) {
  total = total + i
}
total

x <- numeric(20)
for (i in seq_along(x)) x[i] = i+1
sum(x)

x <- -10 : 15
sum(x)

# 1. Rewrite the two loops using the sum() function. For example, the
# for loop in the first example can be written as sum(1:5)
# More for loops:
  a = 2
total = 0
for (blob in a:5) {
  total = total + blob
}
total


# 2practical 1
# 1. In the code above, delete line 1. Now put the above code in a func-
#   tion called Fun5, where a is passed as an argument, i.e. we can call
# Fun5(1)
Fun5 <- function(a){
  total = 0
  for (blob in a:5) {
    total = total + blob
  }
  total
}
Fun5(1)
# 2. Alter the code so that the for loop goes from a to b, rather than
# a to 5. Allow b to be passed as an argument, i.e. we can call
# Fun5(1,5).
Fun5 <- function(a, b){
  total = 0
  for (blob in a:b) {
    total = total + blob
  }
  total
}
Fun5(1, 5)
# 3. Change Fun5 so that it has default arguments of a = 1 and b =
#   10.
Fun5 <- function(a = 1, b = 10){
  total = 0
  for (blob in a:b) {
    total = total + blob
  }
  total
}
Fun5(1, 5)
Fun5()
Fun5(2, )
Fun5(, -2)
# Multiple t-tests
# In the notes, we observed that it was straight forward to loop through
# a data set set and select the maximum values:
#   dd = data.frame(x = rnorm(10), y = rnorm(10), z = rnorm(10))
# max_cols = numeric(ncol(dd))
# for (i in seq_along(dd)) {
#   max_cols[i] = max(dd[, i])
# }
# max_cols
# • Alter the above the code to calculate the mean instead of the maxi-
#   mum value
# • Now, calculate the standard deviation (via sd) as well as the mean.
# You should only have a single loop!

dd = data.frame(x = rnorm(10), y = rnorm(10), z = rnorm(10))
mean_sd = list(numeric(ncol(dd)))
for (i in seq_along(dd)) {
  mean_sd[[i]] = list(max(dd[, i]), sd(dd[, i]))
}
unlist(mean_sd)

#   Solutions
# The solutions can be viewed via
 library(jrProgramming)
 vignette("solutions1", package = "jrProgramming")
# 3