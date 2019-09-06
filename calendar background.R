# coloured rectangles
library(ggplot2)
library(lubridate)

rectDate <- data.frame(x_start = mdy(c("01-01-2019", "03-01-2019", "05-01-2019", "07-01-2019", "09-01-2019", "11-01-2019")),
                       x_end = mdy(c("01-31-2019", "03-31-2019", "05-31-2019", "07-31-2019", "09-30-2019", "11-30-2019")),
                       stringsAsFactors = F)

ggplot(rectDate, aes(xmin = x_start, 
                     xmax = x_end, 
                     ymin = 0, 
                     ymax = 1)) +
  geom_rect(fill = "grey80") +
  scale_x_date(limits = mdy(c("01-01-2019", "12-31-2019"))) +
  coord_cartesian(expand = 0) +
  theme_classic()
