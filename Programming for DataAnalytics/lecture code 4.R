###########################################################
#---------------------------------------------------------#
########## Lecture 4 code: Factors and tables #############
#---------------------------------------------------------#
###########################################################

# Clear everything in the workspace:
rm(list=ls())

###########################################################
# Introduction
# In this lesson, we're going to learn:

# About factors and levels
# The functions tapply() and split()
# Using tables in R
# The aggregate() and cut() functions
# Reading in data

###########################################################
# Simple factor example 
###########################################################

# What are factors?

# Categorical/qualitative data arise in 3 different forms:
# 1. Nominal (e.g. blue, green, brown)
# 2. Ordinal (e.g. A, B, C)
# 3. Interval (e.g. 1-10, 11-20, 21-30)

# We often code the different levels as numbers (e.g. male = 1, female = 2)
# Often these numbers don't mean anything!
# When the data are ordinal however (e.g. small = 1, medium = 2, large = 3),
# these numbers (or rather, their order) does mean something and we need special methods to
# analyse them
# Factors in R store categorical data: they are simply vectors with some
# additional information on them -
# This information is called the levels.

# Here's an example of a factor:
x <- c(1, 3, 6, 3,20)
xf <- factor(x)
xf

# The distinct values are the levels. Looking at the structure:
str(xf)
# The values of xf are now actually level 1, level 2,
# level 3, and level 2, rather than the values in x
# Notice that the levels are characters

# Adding in extra levels (if we know there will be more levels than in the present data)
xf2 <- factor(x, levels = c(1, 3, 6, 20))
xf2
str(xf2)

# If we haven't specified a level then we can't use it in a factor:
xf[2] <- 100
xf

###########################################################
# Functions for factors: tapply()
###########################################################

# Let's suppose we have a list of ages together with political party affiliation
ages <- c(25, 26, 55, 37, 21, 42)
affils <- c('FG', 'Labour', 'Labour', 'FG', 'FF', 'Labour')

# The command is tapply(x, f, g) where x is a vector,
# f is a factor, and g is a function

# tapply() temporarily splits x into groups according
# to the levels in f, and then applies the function g
tapply(ages, affils, mean)

# Note that here we haven't specified affils as a factor
# but tapply applies as.factor() to it

# The tapply function splits the vector of ages up into different
# affiliations/groups and runs mean() on each group

# Let's look at a more complicated example
d <- data.frame(list(gender = c("M", "M", "F", "M", "F", "F", "M"),
                     age = c(47, 59, 21, 32, 33, 24, 52),
                     income = c(55000, 88000, 32450, 76500, 123000, 45650, 28000)))
d$over25 <- ifelse(d$age > 25, 1, 0)
d

# Now let's get the mean over gender *and* over25
tapply(d$income, list(d$gender, d$over25), mean)

# The aggregate function calls tapply for each variable in a group. e.g.:
aggregate(d$income, list(d$gender, d$over25), mean)

# but aggregate applies factor() to list(d$gender, d$over25)
# aggregate() can be a little more useful due to the form of its output

# Discussion on the *apply functions here
# https://stackoverflow.com/questions/3505701/grouping-functions-tapply-by-aggregate-and-the-apply-family

# tapply works on a vector input,
# aggregate can handle more complicated objects: data frames, time series objects etc.

###########################################################
# Functions for factors: split()
###########################################################

# The split function performs the first part of tapply():
# it just splits things into groups:
split(d$income, d$gender)
split(d$age, d$gender)
# Note that split() returns a list (a natural object here,
# since the groups can be of different lengths)
# tapply() takes that list and uses lapply() on it

# split(x, f) also works on a dataframe x - this can be very useful:
split(d, d$gender)

# If you type tapply without brackets at the R prompt you will see the contents
# of the function (this is true for many R functions).
# Note that tapply uses split() and lapply()

###########################################################
# Tables:
###########################################################

# We create a table using the table() function
install.packages("carData")
library(carData)

# Load the dataset GSSvocab:
data(GSSvocab)
help(GSSvocab)
str(GSSvocab)

# From the above commands we can see that there are 8 columns,
# 5 of which are factors

# Arguably one should not be a factor,
# and some of those which are factors should be ordered factors
# But you'll see how to fix this in the tutorial

# For now, let's make some tables:

# Using tables with GSSvocab:
head(GSSvocab)

GSSvocab2 <- GSSvocab[ , c('nativeBorn', 'gender')]
head(GSSvocab2)

# The table function will take a data frame of 2 (or more)
# columns and turn them into a contingency table
table(GSSvocab2)

# If we just wanted counts on one of the variables we could use, for example
table(GSSvocab$gender)
table(GSSvocab$nativeBorn)

# A multi-dimensional table becomes more difficult to follow:
table(GSSvocab$nativeBorn, GSSvocab$ageGroup, GSSvocab$gender)

# Notice that a table looks a lot like a matrix
# A multi-dimensional table is just an array
# We can use all the matrix/array functions on tables

###########################################################
# Operations on tables:
###########################################################

tab1 <- table(GSSvocab$nativeBorn, GSSvocab$ageGroup)

# We can access part of a table in exactly the same way as a matrix/array
tab1[1, 2]
tab1[1, ]
tab1[ , 2]
tab1[,'50-59']

# We can perform scalar multiplication on a table:
# Normalising tab1, so all add up to 1 (useful for proportions/percentages):
tab1 / sum(tab1)
tab2=round(tab1 / sum(tab1), 3)

# Marginal counts can be found using apply
# apply works across the rows (1) or columns (2)
apply(tab1, 1, sum)
apply(tab1, 2, sum)

# A nicer way of displaying this is with addmargins:
# Useful for getting the row totals, column totals and table totals:
addmargins(tab1)

###########################################################
# The cut() function:
###########################################################

# cut() allows you to map numerical data
# to factors - very useful for analysis
# It generates a factor from a list of bins
# The general use is cut(x, b) where x is a numeric variable
# and b is a set of bins

# Let's look back at the airquality data:
data(airquality)
head(airquality)

# You can optionally give labels to the bins too:
cut(airquality$Temp,
    breaks = c(50, 60, 70, 80, 90, 100),
    labels = c('Cool', 'Fresh', 'Warm', 'Hot', 'Very Hot'))

# Here we cut the raw temperature data into 5 categories, 50 - 60F,
# 60 - 70F, 70 - 80F, 80 - 90F, and 90 - 100F,
# and give them five labels
cut(airquality$Temp,
    breaks = c(50, 60, 70, 80, 90, 100),
    labels = c('Cool', 'Fresh', 'Warm', 'Hot', 'Very Hot'),
    ordered_result = T)

# What is the difference between the two results above?
fact1 <- cut(airquality$Temp,
             breaks = c(50, 60, 70, 80, 90, 100),
             labels = c('Cool', 'Fresh', 'Warm', 'Hot', 'Very Hot'),
             ordered_result = T)
table(fact1)

###########################################################
# Extras 1: Working directory
###########################################################

# It is often convenient to set a 'working directory' from which to call files
# R will create, read & save files to the working directory
# unless told otherwise

# We can see the directory R currently believes to be the working directory with
# the command
getwd()

# You can set the working directory with the command:
setwd('path/to/somewhere')
# where the path is the directory with which you want to work. You can also set the
# working directory using the 'Session' menu in RStudio

# R has a number of useful functions to interact with files in a directory, e.g.
# list.files(), file.choose(), file.info() etc.

# We will see more about these later

# See help(files) for many more commands

###########################################################
# Extras 2: Reading in files
###########################################################

# So far we have created data ourselves or loaded in data that are already
# in R (e.g. the airquality data). When loading in data from other sources we can
# use some of R's built in functions

# The basic read file command in R is read.table:
?read.table

# The general method is:
read.table(file = "path/to/somewhere.txt", header = FALSE, sep = "")
# This will read in the file given in the file argument

# If the top row has names in it then header = TRUE
# will remove them and set the column names to be
# these

# The sep argument gives the delimiters for the different data points,
# sep = "," for example would read in a comma-separated file

# Right method:
mydata1 <- read.table(file = "mydata1.txt", header = TRUE, sep = " ")
mydata2 <- read.table(file = "mydata2.txt", header = FALSE, sep = " ")

# Wrong method:
mydata1 <- read.table(file = "mydata1.txt", header = FALSE, sep = " ")
mydata2 <- read.table(file = "mydata2.txt", header = TRUE, sep = " ")

# csv format is very common:
mydata3 <- read.table(file = "mydata3.txt", header = TRUE, sep = ",")
# or:
mydata3.1 <- read.csv(file = "mydata3.txt", header = TRUE)

###########################################################
# Summary:
###########################################################

# Factors are useful for storing nominal/ordinal data in a compressed format
# and useful for further analysis

# R makes sure they are handled correctly in other functions

# Tables are just matrices/arrays - all the usual functions apply

# Some useful functions are tapply, split, aggregate, and cut

# It's a good idea to always set your working directory
# and to read files in using read.table