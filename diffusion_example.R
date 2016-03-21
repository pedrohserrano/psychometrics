
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
