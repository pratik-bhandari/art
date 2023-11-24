# devtools::install_github("djnavarro/asciify")
# install.packages('Cairo')
library(ggplot2)
#\genuary2021 #\rstats 
# make something human
# https://unsplash.com/photos/mFadZWL9UiI

plot.img <- here::here("rawpics", "bernie01.jpeg") %>%
  asciify::ascii_map(alphabet = 0:9, rescale = 1) %>%
  ggplot(aes(x, -y, label = label)) +
  geom_text(size = .5) +
  theme_void()
# load.image(here("rawpics", "slh.jpg"))
# file <- imager::load.image(here::here("rawpics", "sara04.jpg"))

ggsave(here::here("outputs/bernie_asciified01.jpg"), plot.img, dpi=300, width = 4, height = 7)
