## ----setup,include=FALSE-------------------------------------------------
library(knitr)

knitr::opts_chunk$set(fig.height=4, fig.width=6,
                      cache=TRUE, autodep = TRUE, cache.path = 'legend-cache/')
knitr::opts_template$set(smallfigure = list(fig.height=2, fig.width=3))

## ----fig.cap='Imprecise positioning of legend with `theme(legend.position)`.'----
library(ggplot2)
library(grid)
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
(d <- ggplot(dsamp, aes(carat, price)) +
  geom_point(aes(colour = clarity)) +
  theme(legend.position = c(0.06, 0.75))
)

## ----echo=FALSE,fig.cap='**Left:** Base font size set to 22 pt. **Right:** Zoom on plot that is plotted at 150% size.'----


vp1 <- viewport(x=0, y=0, width=unit(0.5, 'npc'), just=c(0,0))
vp2 <- viewport(x=0.5, y=1, width=unit(1.5, 'npc'), height=unit(1.5, 'npc'), just=c(0,1))
grid.newpage()
vp0 <- current.viewport()
pushViewport(vp1)
g <- ggplotGrob(d + theme_gray(base_size=26) + theme(legend.position = c(0.06, 0.75)))
grid.draw(g)
popViewport()
pushViewport(vp2)
grid.draw(ggplotGrob(d))


## ----reposition_legend,fig.cap='Exact positioning of legend in the main panel.'----
library(lemon)
reposition_legend(d, 'top left')

## ----echo=FALSE,fig.cap='**Left:** Base font size set to 22 pt. **Right:** Zoom on plot that is plotted at 150% size.'----
vp1 <- viewport(x=0, y=0, width=unit(0.5, 'npc'), just=c(0,0))
vp2 <- viewport(x=0.5, y=1, width=unit(1.5, 'npc'), height=unit(1.5, 'npc'), just=c(0,1))
grid.newpage()
vp0 <- current.viewport()
pushViewport(vp1)
g <- reposition_legend(d + theme_gray(base_size=26) + theme(legend.position = 'left'), 'top left', plot=FALSE)
grid.draw(g)
popViewport()
pushViewport(vp2)
grid.draw(reposition_legend(d, 'top left', plot=FALSE))

## ----fig.cap="Legend with multple guides on a tacky 'snow' background."----
d2 <- d + aes(shape=cut) + 
  theme(legend.box.background = element_rect(fill='#fffafa'),
        legend.background = element_blank())
reposition_legend(d2, 'left')

## ------------------------------------------------------------------------
g1 <- function(a.gplot){
  if (!gtable::is.gtable(a.gplot))
    a.gplot <- ggplotGrob(a.gplot)
  leg <- which(sapply(a.gplot$grobs, function(x) x$name) == "guide-box")
  a.gplot$grobs[[leg]]
}
g2 <- function(a.gplot){
  if (!gtable::is.gtable(a.gplot))
    a.gplot <- ggplotGrob(a.gplot)
  gtable::gtable_filter(a.gplot, 'guide-box', fixed=TRUE)
}

## ----opts.label='smallfigure',fig.cap='Two guides in a single legend, in a grossly undersized figure.'----
(da <- ggplot(dsamp, aes(carat, price)) +
  geom_point(aes(colour = clarity, shape=cut)) +
   theme(legend.box = 'horizontal')
)
print(g1(da))
print(g2(da))

## ----fig.cap="Facetted panels' names."-----------------------------------
d2 <- d + facet_grid(.~cut)
gtable_show_names(d2)

## ----reposition_legend_facet1,fig.cap='Placing the legend in a facet panel.'----
reposition_legend(d2, 'top left', panel = 'panel-3-1')

## ----reposition_legend_facet2,fig.cap='Placing the legend in an empty panel when using `facet_wrap`.'----
reposition_legend(d + facet_wrap(~cut, ncol=3), 'top left', panel='panel-3-2')

## ----reposition_legend_facet3,fig.cap='The looks of the legend is modified with usual ggplot2 options.'----
d3 <- d + facet_wrap(~cut, ncol=3) + scale_color_discrete(guide=guide_legend(ncol=3))
reposition_legend(d3, 'center', panel='panel-3-2')

## ----reposition_multiple_panels,fig.cap='Supplying `reposition_legend` with multple panel-names allows the legend to span them.'----
d4 <- d + facet_wrap(~cut, ncol=4) + scale_color_discrete(guide=guide_legend(nrow=2))
reposition_legend(d4, 'center', panel=c('panel-2-2','panel-4-2'))

## ----gtable_show_names,fig.cap="Use of `gtable_show_names` to reveal the panels' names."----
gtable_show_names(d4)

## ----fig.cap='...'-------------------------------------------------------
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
p1 <- qplot(carat, price, data = dsamp, colour = clarity)
p2 <- qplot(cut, price, data = dsamp, colour = clarity)
p3 <- qplot(color, price, data = dsamp, colour = clarity)
p4 <- qplot(depth, price, data = dsamp, colour = clarity)
grid_arrange_shared_legend(p1, p2, p3, p4, ncol = 2, nrow = 2, position='top')
grid_arrange_shared_legend(p1, p2, p3, p4, ncol = 2, nrow = 2, position='bottom')
grid_arrange_shared_legend(p1, p2, p3, p4, ncol = 2, nrow = 2, position='left')
grid_arrange_shared_legend(p1, p2, p3, p4, ncol = 2, nrow = 2, position='right')

## ----g_legend,include=FALSE,fig.cap=''-----------------------------------
g_legend <- function(a.gplot){
  if (!gtable::is.gtable(a.gplot))
    a.gplot <- ggplotGrob(a.gplot)
  #gtable_filter(a.gplot, 'guide-box', fixed=TRUE)
  leg <- which(sapply(a.gplot$grobs, function(x) x$name) == "guide-box")
  a.gplot$grobs[[leg]]
}

## ------------------------------------------------------------------------
library(gridExtra)
legend <- g_legend(p1 + theme(legend.position='bottom'))
grid.arrange(p1+theme(legend.position='hidden'), p2+theme(legend.position='hidden'),
             p3+theme(legend.position='hidden'), legend)

## ----fig.cap='Using layout_matrix to have plots span different cells of a grid.'----
grid.arrange(p1+theme(legend.position='hidden'), p2+theme(legend.position='hidden'),
             p3+theme(legend.position='hidden'), legend,
             layout_matrix=matrix(c(1,3,4,2,3,4), ncol=2))

## ----fig.cap='Using layout_matrix to have plots span different cells of a grid, but with legend in a separate argument.'----
grid.arrange(p1+theme(legend.position='hidden'), p2+theme(legend.position='hidden'),
             p3+theme(legend.position='hidden'), bottom=legend$grobs[[1]],
             layout_matrix=matrix(c(1,3,2,3), ncol=2))

## ------------------------------------------------------------------------
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
d <- ggplot(dsamp, aes(carat, price)) +
  geom_point(aes(colour = clarity)) 
reposition_legend(d + theme_gray(base_size=26), 'top left')
