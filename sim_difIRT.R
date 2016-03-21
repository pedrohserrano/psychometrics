#############################################
## Illustration
#############################################

library("diffIRT")
set.seed(1310)

data <- simdiff(100, 10, model = "Q") #100 sujetos, 10 items, modelo Q simula
out <- diffIRT(data$rt, data$x, model = "Q", se = T) #ajusta difusi??n (error TRUE)
summary(out)
View(data)

plot(data$ai, coef(out)$item[, "ai"]) #reales ai vs estimados ai (estimaci??n del umbral de los items)
abline(0, 1)

resp_out <- RespFit(out, 2)
resp_out #Bondad de ajuste Mr, df y p

QQdiff(out, item = 1:3) #distribucion de los parametros

out_vi <- diffIRT(data$rt, data$x, model = "Q", constrain = c(1:10, rep(11, 10), 
  12:21, 22, 23))
anova(out_vi, out)


out_fix <- diffIRT(data$rt, data$x, model = "Q", constrain = c(rep(0, 10), 1:10, 
  11:20, 21, 22), start = c(rep(0.5, 10), rep(NA, 22)))
out_fix
anova(out_fix, out)

fs <- factest(out)
par(mfrow = c(1, 2))
plot(fs[, 1], data$gamma, xlab = "true value", ylab = "estimate", main = expression(gamma[p]))
abline(0, 1)
plot(fs[, 2], data$theta, xlab = "true value", ylab = "estimate", main = expression(theta[p]))
abline(0, 1)

coef(out) 

dataT = simdiff(1000, 2, 1, .3, 3) #simula difusi??n tradicional

#############################################
## Application 1
#############################################

par(mfrow = c(1, 1))
data("extraversion", package = "diffIRT")
data_diffusion <- data.frame(extraversion)
View(data_diffusion)
x <- extraversion[, 1:10]
rt <- extraversion[, 11:20]
res1 <- diffIRT(rt, x, "D", se = TRUE)
summary(res1)
out_resp <- RespFit(res1, 2)
QQdiff(res1, item = 1:6, plot = 1)


#############################################
## Application 2
#############################################

data("rotation", package = "diffIRT")
x <- rotation[, 1:10]
rt <- rotation[, 11:20]

res <- diffIRT(rt, x, "Q", se = TRUE)
summary(res)
RespFit(res, 2)

res_ai_equal <- diffIRT(rt, x, model = "Q", constrain = "ai.equal")
res_vi_equal <- diffIRT(rt, x, model = "Q", constrain = "vi.equal")
res_ter_equal <- diffIRT(rt, x, model = "Q", constrain = "ter.equal")
res_vi_rotation <- diffIRT(rt, x, model = "Q", constrain = c(1:10, c(11, 12, 13, 
  11, 12, 13, 11, 12, 11, 13), 14:23, 24, 25))
res_ai_rotation <- diffIRT(rt, x, model = "Q", constrain = c(c(1, 2, 3, 1, 2, 3, 
  1, 2, 1, 3), 4:13, 14:23, 24, 25))
res_ter_rotation <- diffIRT(rt, x, model = "Q", constrain = c(1:10, 11:20, c(21, 
  22, 23, 21, 22, 23, 21, 22, 21, 23), 24, 25))

anova(res_ai_equal, res)
anova(res_vi_equal, res)
anova(res_ter_equal, res)
anova(res_ai_rotation, res)
anova(res_vi_rotation, res)
anova(res_ter_rotation, res)
 
#############################################
## Application 3
#############################################

set.seed(1310)
alpha <- 2
mu <- 1
ter <- 2
sdv <- 0.3
N <- 10000
data <- simdiffT(N, alpha, mu, sdv, ter)
rt <- data$rt
x <- data$x

## this constrained model is a traditional diffusion model please note
## that the estimated a[i] value = 1/a and that the estimated v[i]
## value = -v
dd <- diffIRT(rt, x, model = "D", constrain = c(1, 2, 3, 0, 4), start = c(rep(NA, 
  3), 0, NA))

data("brightness", package = "diffIRT")
x <- brightness[, 1:12]
rt <- brightness[, 13:24]

res <- diffIRT(rt, x, model = "D", constrain = c(rep(1, 6), rep(2, 6), 3:8, 3:8, 
  rep(9, 12), 0, 10), start = c(rep(NA, 36), 0, NA))
 
#############################################
## Weiner
#############################################
t<-1.2073908
x<-1
a<-0.7982468
v<-1.804
ga<-1.0734053
the<-1.0261136
ter<-0.8596752

n <- 100 # number of end-points of the grid including T
t <- 1 # length of the interval [0, T] in time units
step<-1/sqrt(n)
delta <- the/v
alpha <- ga/a
#dis1 <- rnorm(n, delta, 0.00001) #en wiener la media y varianza son del incremento
#ultima absorcion es exp(-2m/sigma)
#dis1 <- rnorm(n, 0.05, 0.2)
W <- numeric(n+1) #inicializando el vector
time <- seq(0,t, length=n+1)
dist <- rnorm(n, t/n, step)
W <- c(0,cumsum(sqrt(delta)*dist))
plot(time, W, type='l') #ylim=c(-1,1))
#se va a plotear x(el tiempo transcurrido, se extraen los n que cumplen el numero de pasos en los que toca la barrera)
alpha/step#tiempo esperado de tocar la barrera
plot(dis2, type= 'l')#,
#plot(seq(0,.99,.01), dis2, type= 'l')#, 
#puedo hacer la secuencia con el length del boundary
#si imaginamos el alpha como un cuadrado
main= 'Acumulacion de Informacion hasta el punto de desicion',
     xlab='Tiempo', ylab='Desplazamiento')

##Simulation of Wiener process using the
##              definition as independent increments having
##		normal distribution with variance sqrt(Delta)

###EJERCICIO

sims <- simdiff(100,2,model = 'Q') #datos de simulaci??n
data("rotation", package = "diffIRT")
x <- rotation[, 1:2]
rt <- rotation[, 11:12]
rotat<-data.frame(rt,x)

modelo <- diffIRT(sims$rt, sims$x, model = 'Q')
summary(modelo)

plot(sims$ai, coef(modelo)$item[, "ai"]) #reales ai vs estimados de los items
abline(0, 1)

resp_out <- RespFit(modelo, 1)
resp_out #Bondad de ajuste Mr, df y p

QQdiff(modelo, item = 1:2) #distribucion de los parametros

out_vi <- diffIRT(data$rt, data$x, model = "Q", constrain = c(1:10, rep(11, 10), 
                                                              12:21, 22, 23))
anova(out_vi, out)


out_fix <- diffIRT(data$rt, data$x, model = "Q", constrain = c(rep(0, 10), 1:10, 
                                                               11:20, 21, 22), start = c(rep(0.5, 10), rep(NA, 22)))
out_fix
anova(out_fix, out)

fs <- factest(modelo )
par(mfrow = c(1, 2))
plot(fs[, 1], data$gamma, xlab = "true value", ylab = "estimate", main = expression(gamma[p]))
abline(0, 1)
plot(fs[, 2], data$theta, xlab = "true value", ylab = "estimate", main = expression(theta[p]))
abline(0, 1)

coef(out) 

