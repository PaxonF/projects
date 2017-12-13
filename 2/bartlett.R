# Read the Wikipedia entry on Bartlett's test:
#
# https://en.wikipedia.org/wiki/Bartlett's_test
#
# Complete the function below that takes a list of k numeric vectors
# (representing k random samples from the k populations) and returns Bartlett's
# test statistic (given on the Wikipedia page) as a numeric vector of length
# one.
#
# A few notes:  1. 'ln' in the equation is the natural logarithm, which is
# implemented in R as the 'log' function.  2. Your implementation may *not*
# call R's builtin function 'bartlett.test', but you may find it helpful in
# checking your code. 3. If you correctly implement the function, the following
# code will return something close to '25.96':
#
# bartlett(lapply(split(InsectSprays,InsectSprays$spray),function(x) x$count))
#

bartlett <- function(samples) {
  k <- length(samples)
  n <- lengths(samples)
  N <- sum(n)
  variances <- numeric()
  for ( i in 1:k ) { variances[i] <- var(samples[[i]]) }
  Spi <- as.numeric(variances)
  Sp2 <- 1/(N-k) * sum((n-1)*Spi)
  sum1 <- sum((n-1)*log(Spi))
  sum2 <- sum(1/(n-1) - (1/(N-k)))
  test.stat <- ((N-k)*log(Sp2) - sum1) / (1 + 1/(3*(k-1))*(sum2))
  test.stat
}

# Complete the function below where 'n', 'mean', and 'var' are all numeric
# vectors that can be assumed to be of length k, for k >= 2.  The function
# should return a list of k numeric vectors, where the i^th vector (for
# i=1,..,k) is drawn from a normal distribution with mean 'mean[i]' and
# standard deviation 'sqrt(var[i])'.  Although your numbers will be slightly
# different because of sampling variability, your function should behave as
# follows:
##
# > simulate.data(c(2,5,3),c(0,10,30),c(1,1,10))
# [[1]]
# [1] -0.5879083 -0.5065722
# 
# [[2]]
# [1]  9.138581 10.211088 10.266380 12.587052  8.068297
# 
# [[3]]
# [1] 29.56058 32.59358 29.92688
#  

simulate.data <- function(n, mean, var) {
  k <- length(n)
  x <- list()
  for ( i in 1:k ) { 
    x[[i]] <- rnorm(n[i], mean[i], sqrt(var[i]))
  }
  x
}

# Using the two functions that you wrote above, perform a simulation study to
# calculate the power of Bartlett's test when sampling from k=3 normally
# distributed populations with: 1. sample sizes 20, 25, and 15 respectively, 2.
# means 0, 1, and 3 respectively, and 3. variances 1, 2, and 3 respectively.
# Assume a Type I error rate of 0.05 (i.e., alpha = 0.05).  Make sure you
# assess your Monte Carlo error.
#
# A few notes: 1. Recall that Bartlett's test rejects the null hypothesis when
# the test statistic exceeds the critical value, i.e., the 95% percentile of a
# chi-square distribution with k-1 degrees of freedom.  You can use the
# 'qchisq' function to compute the critical value. 2. The approximate power is
# '0.485'.
k <- 3
n.Reps <- 10000
critical.value <- qchisq(.95, df = k - 1)
sample.Ha <- sapply(1:n.Reps, function(i) bartlett((simulate.data(n=c(20,25,15), mean = c(0,1,3), var = c(1,2,3)))))
power <- mean(sample.Ha >= critical.value)
ci <- power + c(-1,1)*qnorm(1-0.05/2)*sqrt(power*(1-power)/n.Reps)
power <- c(power, ci)
names(power) <- c("Power", "Lower.Bound", "Upper.Bound")
power