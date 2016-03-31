
library(shiny)
library(RWiener)
shinyServer(function(input, output) {
  
  data_weiner <- reactive({
    n <- input$n
    alpha <- as.numeric(input$alpha)
    tau <- as.numeric(input$tau)
    beta <- as.numeric(input$beta)
    delta <- as.numeric(input$delta)
    dat <- rwiener(n,alpha,tau,beta,delta)
    dat
  })
  output$Plot <- renderPlot({
    n <- input$n
    dis <- rnorm(n, 0, 1)
    dis <- cumsum(dis)
    plot(dis, type= 'l',main= 'Brownian One Dimension')
    })
  output$Plot2 <- renderPlot({
    n <- input$n
    delta <- input$delta
    dis1 <- rnorm(n, delta, 5)
    dis2 <- cumsum(dis1)
    plot(dis2, type= 'l',main= 'Con Rwiener', xlab='time', ylab='displacement')
    })
  output$data_w <- renderTable({
    data.frame(data_weiner())
  })
  output$Plot3 <- renderPlot({
    wiener_plot(data_weiner())
   })

})




########################MOVIMIENTO BROWNIANO


############ WEINER PACKAGE

# 
# n=100
# alpha=2
# tau=.3
# beta=.5
# delta=.5
# 
# dat <- rwiener(n, alpha, tau, beta, delta)
# ###
# dis <- rnorm(n, delta, 1)
# dis1 <- cumsum(dis)
# plot(dis1, type= 'l',main= 'Con Rwiener', xlab='time', ylab='displacement')
# 
# #To get the density of a specific quantile, one can use the density function dwiener
# dwiener(dat$q[1], alpha=2, tau=.3, beta=.5, delta=.5, resp=dat$resp[1], give_log=FALSE)
# #plot
# curve(dwiener(x, 2, .3, .5, .5, rep("upper", length(x))),
#       xlim=c(0,3), main="Density of upper responses",
#       ylab="density", xlab="quantile")
# 
# pwiener(dat$q[1], alpha=2, tau=.3, beta=.5, delta=.5, resp=dat$resp[1])
# # lookup of the .2 quantile for the CDF of the lower boundary
# qwiener(p=.2, alpha=2, tau=.3, beta=.5, delta=.5, resp="lower")
# 
# wiener_plot(dat)




