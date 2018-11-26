## Bayesian Computation with R
## notebook of the book
## 1. An Introduction to R

## 1.3 exploring the robustness of the t statistic
## 1.3.1 introduction

# two independent samples x=(x_1,...,x_m), y = (y_1,...,y_n)
# the hypothesis: the mean of two ppltions is equal:
# H_0: \mu_x - \mu_y = 0
# standard test of H_0 is based on t stat:
# T = (\bar(X) - \bar(Y))/(s_p \sqrt(1/m + 1/n))
# where \bar(.) is the sample mean, and s_p is the pooled sd:
# s_p = \sqrt(((m-1)*sd(x)^2+(n-1)*sd(y)^2)/(m+n-2))
# Under the following assumptinos, and H_0, T has t distribution with m+n-2 deg of freedom
# * x and y are independent random samples from normal distribution
# * sd of two pplations are equal

## 1.3.2 witte a function to compute t stat

# generate 10 samples from a normal dist with mean=50, sd=10
x=rnorm(10, mean = 50, sd = 10)
y=rnorm(10, mean = 50, sd = 10)

# size of samples
m=length(x)
n=length(y)

# pooled standard deviation
sp = sqrt(((m-1)*sd(x)^2+(n-1)*sd(y)^2)/(m+n-2))

# t statistic
t.stat = (mean(x)-mean(y))/(sp*sqrt(1/m+1/n))

# combine them into a funciton, "tstatistic"
tstatitic = function(x,y){
  # two args: x and y
  m = length(x)
  n = length(y)
  sp = sqrt(((m-1)*sd(x)^2+(n-1)*sd(y)^2)/(m+n-2))
  t.stat = (mean(x)-mean(y))/(sp*sqrt(1/m+1/n))
  return(t.stat)
}

# if the function is saved in a file "tstatistic.R" then
# one can recall this by > source("tstatistic.R")

# try to implement tstatictic with a data
data.x = c(1,4,3,6,5)
data.y = c(5,4,7,6,10)
tstatitic(data.x, data.y)
# [1] -1.937926

#######################################
## 1.3.3 programming a MC simulation

# significance level for the t stat when ppltions dont follow the standard assumptions
# i.e. normality and equal vars. the ture significance level depends on..
# * stated level of significance \alpha
# * shape of ppltions
# * spreads of two ppltions measured by the two sd 
# * sample sizes m and n
# given params, we want to estimate true significance level
# \alpha^T = Pr(|T|\geq t_{n+m-2,\alpha/2})

# Outline of simulating \alpha^T
# 1. simulate random sample x from the first ppl and y from the second ppl
# 2. compute t statistic T
# 3. decide if  H_0 is rejected (|T| exceeds the critical point)
# repeats N times and estimate significance level by
# \hat{\alpha^T} = (num of rejections)/N

alpha = 0.1; m = 10; n = 10
N = 10000  # number of simulations
n.reject = 0 # counter for rejection
for (i in 1:N){
  x = rnorm(m, mean = 0, sd = 1)  # generate samples
  y = rnorm(n, mean = 0, sd = 1)
  t.stat = tstatitic(x,y) # compute t stat with the function
  if (abs(t.stat) > qt(1-alpha/2, m+n-2)){
    n.reject=n.reject+1  # increment reject if t.stat exceeds the point
  }
}
true.sig.level = n.reject/N  # est is proportion of rejections

#######################################
## 1.3.4 alpha^T under different assumptions
# what happens if we change the distribution of the two ppls

# here we test the true significance level if
# x = rnorm(m, mean = 10, sd = 2)
# y = rexp(n, rate=1/10)
m=10; n=10;
my.tsimulation = function()
  tstatitic(rnorm(m,mean=10,sd=2), rexp(n,rate = 1/10))

tstat.vector = replicate(10000, my.tsimulation())

# see the density of t stats
# compare with the exact result with the theoretical one
plot(density(tstat.vector),xlim = c(-5,8), ylim = c(0,.4),lwd=3)
curve(dt(x, df=18), add=TRUE)
legend(4,.3,c("exact","t(18)"),lwd = c(3,1))


