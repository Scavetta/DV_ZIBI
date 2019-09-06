# Intro to Data Viz
# Rick Scavetta
# 06/09/2019
# Workshop at ZIBI, Berlin

# Clear workspace
rm(list = ls())

# load packages
library(ggplot2)
library(RColorBrewer)
library(Hmisc)

# Colours
# colorbrewer2.org
# View all palettes:
display.brewer.all()
display.brewer.all(type = "seq")
display.brewer.pal(9, "Blues")

# get the actual hex codes:
brewer.pal(9, "Blues")

# extract specific colors: 4th, 6th, 8th
myBlues <- brewer.pal(9, "Blues")[c(4,6,8)]

# Plotting with ggplot2
# 7 layers

# The first 3 "essential" layers
# 1 - Data
mtcars

# 2 - The aesthetics - Mapping a variable onto a scale
# 3 - The geometries - begin with geom_, add with +

# Histogram - univariate continuous
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram(aes(y = ..density..), 
                 binwidth = 1, center = 0.5,
                 fill = "#e41a1c")
# 2/32 = 0.0625, first bin
# density is always height*width!!!

# Aesthetics - MAPPING a variable
# Attributes - SETTING a parameter

# "stripchart"
# ggplot(mtcars, aes(x = mpg, y = 1)) +
#   geom_point()
# 
# ggplot(mtcars, aes(x = mpg)) +
#   geom_density()
# density(mtcars$mpg) # 'bw' = 2.477

# Scatter plot - bivariate continuous
# Watch for overplotting!
# Solutions: jittering, alpha, outline
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point(shape = 16, alpha = 0.6, size = 3, 
             color = "#e41a1c")

# Typically:
# "color =" is for the outline, but in points, it's the inside
# "fill =" is normally used for the inside

# outline, use shape argument
# 19, default, fill with outline
# 16, fill without outline
# 1, no fill, only outline (hollow)
# 21, fill with different colour outline

# Changing positions
# positions include:
# "jitter", "dodge", "jitterdodge"
# "fill", "stack", "nudge"
# "identity" - no position change

# e.g. in a bar plot:
table(mtcars$am, mtcars$cyl)

# First, look at the data:
str(mtcars)
# qualitative, categorical, factor, discrete

# First, convert variables to factor
mtcars$am <- as.factor(mtcars$am)
mtcars$cyl <- as.factor(mtcars$cyl)

# defualt position = "stack"
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar()

# "dodge"
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "dodge")

# "fill"
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "fill")

# Modifying scales
# scale = aes = axes
# i.e. MUST have been defined in aes()
p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point(shape = 16, alpha = 0.6, 
             color = "#e41a1c") +
  scale_x_continuous("Weight (1000 lbs)",
                     limits = c(0,6),
                     breaks = 0:6,
                     expand = c(0,0)) +
  scale_y_continuous("Miles per (US) gallon",
                     limits = c(10, 40),
                     expand = c(0,0))

# 4 - The stats layer

# plotting models
# Default LOESS model
p +
  stat_smooth(span = 0.4, se = F)

# lm
p +
  stat_smooth(method = "lm", se = F)

# Multiple models:
# Use the invisible "group" aes
# or inherit it from the color aes
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(aes(col = cyl)) +
  stat_smooth(method = "lm", se = F)


# Applying error bars

# Establish positions
posn_d <- position_dodge(0.2)
posn_j <- position_jitter(0.3)
posn_jd <- position_jitterdodge(0.3, dodge.width = 0.2)

# Base layer
q <- ggplot(mtcars, aes(cyl, wt, color = am))

# Raw values
# Use _jd or _j
q +
  geom_point(position = posn_j)

# Apply some stats functions
# mean with 1 sd error bar
m <- q +
  stat_summary(fun.data = mean_sdl, 
               fun.args = list(mult = 1),
               position = posn_d)

# This comes from Hmisc
# smean.sdl(1:100, mult = 1)

# 95% CI
q +
  stat_summary(fun.data = mean_cl_normal, position = posn_d)

# 5 - Coordinate
# e.g. coord_fixed() for a 1:1 aspect ratio

# CAREFUL!!! scale_ functions FILTER out data
m +
  scale_y_continuous(limits = c(1.5,5), expand = c(0,0))

# coord_ ZOOM-IN on the data
m +
  coord_cartesian(ylim = c(1.5, 5)) +
  scale_y_continuous(expand = c(0,0))

# 6 - Facets (small multiples)
# managing factor variables with a small number of levels
# e.g. gear, carb, vs, cyl

# By columns
p +
  facet_grid(. ~ am)

# By rows
p + 
  facet_grid(gear ~ .)

# By rows and columns
p + 
  facet_grid(gear ~ am)

# 7 - Theme (non-data ink)
# bulit-in themes
p +
  theme_classic() +
  theme(axis.text = element_text(color = "#e41a1c"),
        panel.grid.major.x = element_line(color = "grey65"))

# Saving our plots
# Raster - have pixels and resolution
# jpg, png, gif, tif, bmp

# Vectors - instructions to build an image, no resolution
# pdf, svg, ps, eps, ai

ggsave("myPlot.pdf", height = 6, width = 6, units = "in")
ggsave("myPlot.png", height = 6, width = 6, units = "in")


# relevel a factor variable
# i.e. it has to say "levels"
mtcars$am <- as.factor(mtcars$am)
mtcars$am
library(forcats)
mtcars$am <- fct_recode(mtcars$am, 
            "automatic" = "0",
            "manual" = "1")



