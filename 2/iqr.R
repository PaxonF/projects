# The interquartile range (IQR) is the 75th percentile minus the 25th
# percentile and is a measure of spread.  Complete the function below that
# returns (as a numeric vector of length one) the IQR for data 'x'.
iqr <- function(x) {
  IQR(x) #could also use quantile(x, .75) - quantile(x, .25)
}

# Run the code below to define the vector 'data'.

data <- c(0.9135,1.7965,0.5052,1.0776,0.7507,0.3114,0.834,0.2864,0.7088,    
          1.0913,0.7971,0.3773,0.2546,0.2869,0.2759,1.0178,0.499,1.1363,    
          0.5234,0.8101,1.3569,0.7134,0.1737,0.5188,0.7152,0.4638,0.7805,   
          1.4817,1.0456,1.1129,0.2786,0.5022,0.6373,0.9177,0.5706,0.2636,   
          0.69,0.3312,0.3708,0.2604,0.9143,0.72,0.799,0.8315,0.3099,0.4921, 
          0.5891,0.2542,1.0999,0.7069)                                      
 
# Compute the IQR for this data and provide a 95% confidence interval on the
# population IQR based on the bootstrap.
iqr.boot <- function(x, n.Reps = 10000) {
  sapply(1:n.Reps, function(i)  {
    index <- sample(1:length(x), size = length(x), replace = TRUE)
    iqr(x[index])
  })
}
iqr.data <- mean(iqr.boot(data))
n.Reps <-10000
ci <- iqr.data + c(-1,1)*qt(.975, df = length(data)-1)*sd(data)/sqrt(n.Reps)
iqr.data <- c(iqr.data, ci)
names(iqr.data) <- c("IQR", "Lower.Bound", "Upper.Bound")
iqr.data

# If someone claimed that the IQR of the population from which this data was
# sampled is 0.25, what would you say about this claim?

#I would have to say, that since the value 0.25 does not lie in our confidence interval for the IQR 
#from the bootstrap samples, this claim is false. The true IQR of this sample is in the interval (.488, .503),
# with an estimate of 0.49 at 95% confidence