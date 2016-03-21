#############################################
## Illustration
#############################################

library("diffIRT")
set.seed(1310)

data <- simdiff(100, 10, model = "Q")
out <- diffIRT(data$rt, data$x, model = "Q", se = T)
summary(out)

plot(data$ai, coef(out)$item[, "ai"])
abline(0, 1)

resp_out <- RespFit(out, 2)
resp_out

QQdiff(out, item = 1:3)

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

#############################################
## Application 1
#############################################

par(mfrow = c(1, 1))
data("extraversion", package = "diffIRT")
x <- extraversion[, 1:10]
rt <- extraversion[, 11:20]
plot(1:143,rt[,1], type='l')
res1 <- diffIRT(rt, x, "D", se = TRUE)
out_resp <- RespFit(res1, 2)
QQdiff(res1, item = 1:6, plot = 1)

#############################################
## Application 2
#############################################

data("rotation", package = "diffIRT")
x <- rotation[, 1:10]
rt <- rotation[, 11:20]

res <- diffIRT(rt, x, "Q", se = T)
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
 
