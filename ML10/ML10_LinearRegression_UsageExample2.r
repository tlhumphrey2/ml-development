#UsageExample3_LinearRegression.r
fpe <- read.table("http://data.princeton.edu/wws509/datasets/effort.dat")
write.csv(fpe, file = "effort.csv")
attach(fpe)
lmfit = lm( change ~ setting + effort )

fitted_fpe <- fitted(lmfit)

len <- length(fpe[,1])

total_diff <- 0
for ( i in 1:len ){
   total_diff <- total_diff + abs(fpe[i,3]-fitted_fpe[i])
}

avg_diff <- total_diff / len;

