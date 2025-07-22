## ----setup,include=FALSE------------------------------------------------------
library(knitr)

knitr::opts_chunk$set(fig.height=4, fig.width=6,
                      cache=TRUE, autodep = TRUE, cache.path = 'geoms-cache/')

## ----fig.height=8,fig.cap=''--------------------------------------------------
library(ggplot2)
library(ggh4x)
library(gridExtra)

data(sunspot.year)
sunspots <- data.frame(count = as.numeric(sunspot.year), year = seq.int(start(sunspot.year)[1], end(sunspot.year)[1]))
sunspots <- subset(sunspots, year > 1900)

point <-  ggplot(sunspots, aes(x = year, y = count)) + geom_point() + geom_line() + labs(title = "geom_point + geom_line")
pointline <- ggplot(sunspots, aes(x = year, y = count)) + geom_pointpath(mult = 0.4) + labs(title = 'ggh4x geom_pointline')
grid.arrange(point, pointline)

## ----fig.height=4,fig.cap=''--------------------------------------------------
library(lemon)
x <- rnorm(25)
df <- data.frame(x = x, y = x + rnorm(25, sd = 0.2), 
                 a = sample(c("horse", "goat"), 25, replace = TRUE), 
                 stringsAsFactors = FALSE)
df$y <- with(df, ifelse(y > 1 & a == 'horse', 1, y))
p <- ggplot(df, aes(x = x, y = y, colour = a)) + geom_point(shape = 1)

p + geom_siderange(start = 19)

## ----fig.height=4,fig.cap=''--------------------------------------------------
p + geom_siderange(start = 19, end = 22, fill='black', sides = 'b') +
  geom_siderange(sides = 'tl')

## ----fig.height=4,fig.cap=''--------------------------------------------------
p <- ggplot(mpg, aes(displ, hwy, colour = fl)) +
  geom_point() +
  facet_wrap(~class, nrow = 4)

p + geom_siderange()

