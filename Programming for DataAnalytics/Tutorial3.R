library(boot)
data("melanoma")

str(melanoma)
 # Answer:   str(melanoma)
 # 'data.frame':	205 obs. of  7 variables:
 #   $ time     : num  10 30 35 99 185 204 210 232 232 279 ...
 # $ status   : num  3 3 2 3 1 1 1 3 1 1 ...
#  $ sex      : num  1 1 1 0 1 1 1 0 1 0 ...
 # $ age      : num  76 56 41 71 52 28 77 60 49 68 ...
#  $ year     : num  1972 1968 1977 1968 1965 ...
 # $ thickness: num  6.76 0.65 1.34 2.9 12.08 ...
#  $ ulcer    : num  1 0 0 0 1 1 1 1 1 1 ...

melanoma$age[95]
melanoma[['age']][95]
melanoma[95,4]

lop=2019-melanoma$year
date()
lop=round(lop,1)
melanoma$last.operated= lop

newdata=data.frame(
  time=melanoma$time,
  age=melanoma$age,
  thickness=melanoma$thickness)

ND_Mean=sapply(newdata,mean)
ND_SD=sapply(newdata, sd)
ND_IQR=sapply(newdata, IQR)




