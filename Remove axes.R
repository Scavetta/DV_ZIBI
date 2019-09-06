library(ggplot2)
library(gtable)

d <- ggplot(diamonds, aes(carat, price, fill = ..density..)) +
  xlim(0, 2) + 
  stat_binhex(na.rm = TRUE) + 
  facet_wrap(~ color, nrow = 2)
d

plot_tab <- ggplotGrob(d)

# plot_filtered <- gtable_filter(plot_tab, 
#                                "(background|panel|strip_t|axis_l|xlab|ylab|guide-box|title|axis_b-[1357])",
#                                trim=FALSE)

# plot_filtered <- gtable_filter(plot_tab, 
#                                "(background|panel|strip_t|axis_l|xlab|ylab|guide-box|title|axis_b-1-1)",
#                                trim=FALSE)
# keep this y: "axis-(l)-2"
plot_filtered_y <- gtable_filter(plot_tab, 
                               "axis-(l)-2",
                               trim=FALSE)

# keep this x: "axis-(b)-1"
plot_filtered_x <- gtable_filter(plot_tab, 
                                 "axis-(b)-1",
                                 trim=FALSE)


# plot_filtered
# dev.off()
# grid::grid.newpage()
# grid::grid.draw(plot_filtered)

d +
  theme_classic() +
  theme(panel.background = element_rect(fill = "grey92"),
        axis.line = element_line(colour = NA),
        axis.text = element_text(colour = NA),
        axis.ticks = element_line(colour = NA))
grid::grid.draw(plot_filtered_y)
grid::grid.draw(plot_filtered_x)
