T79 <- 1:10
Tdelt <- (1:100) / 10
Sales <- c(840,1470,2110,4000, 7590, 10950, 10530, 9470, 7790, 5890)
Cusales <- cumsum(Sales)
Bass.nls <- nls(Sales ~ M * ( ((P+Q)^2 / P) * exp(-(P+Q) * T79) ) /(1+(Q/P)*exp(-(P+Q)*T79))^2, 
                start = list(M=60630, P=0.03, Q=0.38))
summary(Bass.nls)

# get coefficient
Bcoef <- coef(Bass.nls)
m <- Bcoef[1]
p <- Bcoef[2]
q <- Bcoef[3]
# setting the starting value for M to the recorded total sales.
ngete <- exp(-(p+q) * Tdelt)

# plot pdf
Bpdf <- m * ( (p+q)^2 / p ) * ngete / (1 + (q/p) * ngete)^2
plot(Tdelt, Bpdf, xlab = "Year from 1979",ylab = "Sales per year", type='l')
points(T79, Sales)

# plot cdf
Bcdf <- m * (1 - ngete)/(1 + (q/p)*ngete)
plot(Tdelt, Bcdf, xlab = "Year from 1979",ylab = "Cumulative sales", type='l')
points(T79, Cusales)

# when q=0, only Innovator without immitators.
Ipdf<- m * ( (p+0)^2 / p ) * exp(-(p+0) * Tdelt) / (1 + (0/p) * exp(-(p+0) * Tdelt))^2
# plot(Tdelt, Ipdf, xlab = "Year from 1979",ylab = "Isales per year", type='l')
Impdf<-Bpdf-Ipdf
plot(Tdelt, Bpdf, xlab = "Year from 1979",ylab = "Sales per year", type='l', col="red")
lines(Tdelt,Impdf,col="green")
lines(Tdelt,Ipdf,col="blue")

# when q=0, only Innovator without immitators.
Icdf<-m * (1 - exp(-(p+0) * Tdelt))/(1 + (0/p)*exp(-(p+0) * Tdelt))
# plot(Tdelt, Icdf, xlab = "Year from 1979",ylab = "ICumulative sales", type='l')
Imcdf<-m * (1 - ngete)/(1 + (q/p)*ngete)-Icdf
plot(Tdelt, Imcdf, xlab = "Year from 1979",ylab = "Cumulative sales", type='l', col="red")
lines(Tdelt,Bcdf,col="green")
lines(Tdelt,Icdf,col="blue")


#####la version simple
set.seed(1310)
a=2
v=1
ter=2
sdv=.3
N=10000
data=simdiffT(N,a,v,sdv,ter)
rt=data$rt
x=data$x
# fit the traditional diffusion model (i.e., a restricted D-diffusion model,
# see application 3 of the paper by Molenaar et al., 2013)
diffIRT(rt,x,model="D",constrain=c(1,2,3,0,4),start=c(rep(NA,3),0,NA))
# t

anova(T79,Sales)

library(diffIRT)
# simulate data accroding to D-diffusion IRT model
#N=personas, nit= items, model=D,Q depende del que quieras
data=simdiff(N=100,nit=10,model="D")
# fit the D-diffusion IRT model
diffIRT(data$rt, data$x, model="D", constrain=NULL,
        start=NULL, se=F, control=list())
# extract parameter estimates
coef(res1)


data=simdiff(N=100,nit=2,model="D")

summary(data)
#parece que esta es la grafica de las simulaciones
par(mfrow = c(1, 1))
plot(1:100,data$rt[,1],type = 'l')

diffIRT(data$rt, data$x, model="D", constrain=NULL,
        start=NULL, se=F, control=list())

##########mas tests
data(extraversion)
x <- as.matrix(extraversion[,1:2], ncol=2)#:10]
rt <- as.matrix(extraversion[,11:12], ncol=2)#:20]

n <- length(rt[,1])
t <- 1
delta <- t/n
plot(1:length(rt[,1]),rt[,1],type='l')
plot(1:length(rt[,1]),cumsum(delta*rt[,1]),type='l')
#item boundary parameter a[i]
#item drift parameter v[i]
#person boundary gamma[p]
#and person drift theta[p]

# fit an unconstrained D-diffusion model
res1 <- diffIRT(rt,x,model="D")

diffIRT(rt, x, model="D", constrain=NULL,
        start=NULL, se=F)


# fit a model with equal item boundaries, a[i] using the manual setup
res2=diffIRT(rt,x,model="D",
             constrain=c(rep(1,10),2:11,12:21,22,23))

# fit a model where all item drift parameters,vi, are fixed to 0.
res3=diffIRT(rt,x,model="D",
             constrain=c(1:10,rep(0,10),11:20,21,22),
             start=c(rep(NA,10),rep(0,10),rep(NA,10),NA,NA))



##########weiner process
p <- 0.5
N <- 400

T <- 1

S <- array(0, c(N+1))
rw <- cumsum( 2 * ( runif(N) <= p)-1 )
S[2:(N+1)] <- rw

WcaretN <- function(x) {
  Delta <- T/N
  
  # add 1 since arrays are 1-based
  prior = floor(x/Delta) + 1
  subsequent = ceiling(x/Delta) + 1
  
  retval <- sqrt(Delta)*(S[prior] + ((x/Delta+1) - prior)*(S[subsequent] - S[prior]))
}

plot(WcaretN, 0,1, n=400)

# # alternative plotting method
# # time point grid
# t <- seq(0,T, length=N+1)
# # approximate Wiener process at time point grid
# W <- sapply(t, WcaretN)
# plot(t, W, type = "l")

###simple one
N <- 100
# number of end-points of the grid including T
T <- 1
# length of the interval [0, T] in time units
Delta <- T/N
# time increment
W <- numeric(N+1)
# initialization of the vector W approximating 
# Wiener process
t <- seq(0,T, length=N+1)
W <- c(0, cumsum( sqrt(Delta) * rnorm(N)))
plot( t, W, type="l", main="Wiener process", ylim=c(-1,1))


## FEATURES AND POTENTIAL IMPROVEMENTS:  Note that the vertical axis limits
## are -1 and +1, so the probability is about 0.68 that the endpoint
## W(101) will be in the plot frame.  Plots may be truncated because of
## the choice of plot frame.  This is intentional to illustrate an
## aspect of the Wiener process.

###hitting time
T <- 1#0
a <- 1
time <- 1#2

p <- 0.5
n <- 100#00
k <- 10#00

Delta = T/n

W <- numeric(n+1)
# initialization of the vector W approximating 
# Wiener process
t <- seq(0,T, length=n+1)
W <- c(0, cumsum( sqrt(Delta) * rnorm(n)))
plot( t, W, type="l", main="Wiener process", ylim=c(-1,1))
help(rpois)

winLose <- 2*(array( 0+(runif(n*k) <= p), dim=c(n,k))) - 1
# 0+ coerces Boolean to numeric
totals <- apply( winLose, 2, cumsum)

paths <- array( 0 , dim=c(n+1, k) ) #crea el vector de 0
paths[2:(n+1), 1:k] <- sqrt(Delta)*totals    
W1 <- cumsum(paths[,1])
plot( t, W1, type='l')#,ylim=c(-1,1))
        
fun <- (function(x) match(0, x, nomatch=n+2))
hitIndex <- apply( 0+(paths <= a), 2, fun)
# If no hiting on a walk, nomatch=n+2 sets the hitting
# time to be two more than the number of steps, one more than
# the column length.  Without the nomatch option, get NA which
# works poorly with the comparison

hittingTime = Delta*(hitIndex-1)
## subtract 1 since vectors are 1-based

probHitlessTa <- sum( 0+(hittingTime <= time))/k
probMax = sum( 0+( apply(paths[1:((time/Delta)+1),], 2, max) >= a ) )/k
theoreticalProb = 2*pnorm(a/sqrt(time), lower=FALSE)

cat(sprintf("Empirical probability Wiener process paths hit %f before %f: %f \n", a, time, probHitlessTa ))
cat(sprintf("Empirical probability Wiener process paths greater than %f before %f: %f \n", a, time, probMax ))
cat(sprintf("Theoretical probability: %f \n", theoreticalProb ))


####PROBABILIDAD DE RUINA
p <- 0.5
n <- 150
k <- 60

victory <- 10
# top boundary for random walk
ruin <- -10
# bottom boundary for random walk
interval <- victory - ruin + 1

winLose <- 2 * (array( 0+(runif(n*k*interval) <= p), dim=c(n,k,
                                                           interval))) - 1
# 0+ coerces Boolean to numeric
totals <- apply( winLose, 2:3, cumsum)
# the second argument ``2:3'' means column-wise in each panel
start <- outer( array(1, dim=c(n+1,k)), ruin:victory, "*")

paths <- array( 0 , dim=c(n+1, k, interval) )
paths[2:(n+1), 1:k, 1:interval] <- totals    
paths <- paths + start

hitVictory <- apply(paths, 2:3, (function(x)match(victory,x, nomatch=n+2)));
hitRuin    <- apply(paths, 2:3, (function(x)match(ruin,   x, nomatch=n+2)));
# the second argument ``2:3'' means column-wise in each panel
# If no ruin or victory on a walk, nomatch=n+2 sets the hitting
# time to be two more than the number of steps, one more than
# the column length.  Without the nomatch option, get NA which
# works poorly with the comparison hitRuin < hitVictory next.

probRuinBeforeVictory <- 
  apply( (hitRuin < hitVictory), 2, 
         (function(x)length((which(x,arr.ind=FALSE)))) )/k

startValues <- (ruin:victory);
ruinFunction <- lm(probRuinBeforeVictory ~ startValues)
# lm is the R function for linear models, a more general view of
# least squares linear fitting for response ~ terms
cat(sprintf("Ruin function Intercept: %f \n", coefficients(ruinFunction)[1] ))
cat(sprintf("Ruin function Slope: %f \n", coefficients(ruinFunction)[2] ))

plot(startValues, probRuinBeforeVictory);
abline(ruinFunction)


#####PROPIEDADES DE TRAYECTORIAS
p <- 0.5
N <- 1000

T <- 1

S <- array(0, c(N+1))
rw <- cumsum( 2 * ( runif(N) <= p)-1 )
S[2:(N+1)] <- rw

WcaretN <- function(x) {
  Delta <- T/N
  
  # add 1 since arrays are 1-based
  prior = floor(x/Delta) + 1
  subsequent = ceiling(x/Delta) + 1
  
  retval <- sqrt(Delta)*(S[prior] + ((x/Delta+1) - prior)*(S[subsequent] - S[prior]))
}

h0 <- 1e-7
h1 <- 1e-2
m = 30
basepoint = 0.5

h <- seq(h0, h1, length=m)
x0 <- array(basepoint, c(m))

diffquotients <- abs(WcaretN( x0 + h) - WcaretN(x0) )/h

plot(h, diffquotients, type = "l", log = "y", xlab = expression(h),
     ylab = expression(abs(W(x0+h) - W(x0))/h))
max(diffquotients, na.rm=TRUE)


##procesos multiples
N = 1000;
dis = rnorm(N, 0 ,1);
dis = cumsum(dis);
plot(dis, type = 'l', main='Pseudo-fractal simulation with Brownian motion',xlim=c(0,1000), ylim=c(-70,70))
fnorm = matrix(nrow= 5, ncol = N)
for(i in 1:5){
  for(j in 1:N){
    fnorm[i,j] = rnorm(1,0,1)
  }}
node = c(100,300,500,700,900);
fdis = matrix(nrow= 5, ncol = N)
for(i in 1:5){
  fdis[i,] = cumsum(fnorm[i,]) + dis[node[i]]
}
for(i in 1:5){
  lines(node[i]:N,fdis[i,1:(N-node[i]+1)])
}


########################MOVIMIENTO BROWNIANO
N = 1000
dis = rnorm(N, 0, 1)
dis = cumsum(dis)
plot(dis, type= 'l',main= 'Brownian Motion in One Dimension', xlab='time', ylab='displacement')


############ WEINER PACKAGE
library(RWiener)
set.seed(0)
n=100
alpha=2
tau=.3
beta=.5
delta=.5

dat <- rwiener(n, alpha, tau, beta, delta)
###
dis <- rnorm(n, delta, 1)
dis1 <- cumsum(dis)
plot(dis1, type= 'l',main= 'Brownian Motion in One Dimension', xlab='time', ylab='displacement')

#To get the density of a specific quantile, one can use the density function dwiener
dwiener(dat$q[1], alpha=2, tau=.3, beta=.5, delta=.5, resp=dat$resp[1], give_log=FALSE)
#plot
curve(dwiener(x, 2, .3, .5, .5, rep("upper", length(x))),
      xlim=c(0,3), main="Density of upper responses",
      ylab="density", xlab="quantile")

pwiener(dat$q[1], alpha=2, tau=.3, beta=.5, delta=.5, resp=dat$resp[1])
# lookup of the .2 quantile for the CDF of the lower boundary
qwiener(p=.2, alpha=2, tau=.3, beta=.5, delta=.5, resp="lower")

wiener_plot(dat)
