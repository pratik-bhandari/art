library(imager)
library(scales)
library(TSP)
library(ambient) 
library(scico)
library(here)
library(generativeart)
library(tidyverse)
library(ambient) 
library(here)
library(tictoc)

x=NULL; y=NULL; z=NULL
# list4df <- list()
for (n in 1:20002) {
  x[[n]] = runif(1, -1, 20) - 2*(n^3 + 3*(n^3) ) #y[[n]] = runif(1, -1, 20) - 2*(n^3 + 3*(n^3) )
  y[[n]] = runif(1, -1, 2) + cos(n^3)
  # z[[n]] = log(n)
}
df <- data.frame(x,y,n)

plot.img <- df %>% #sample_n(df, 6789) %>% 
  ggplot(aes(x,y, color=x)) +
  geom_point(size=.01) + # geom_point(alpha=runif(1, min=0, max=0.1), size=.01) +
  geom_path(alpha=.03) + # geom_path(alpha=runif(1, min=0, max=0.2)) +
  coord_polar() +
    scale_y_continuous(trans=reverse_trans()) +
    # coord_equal() +
    theme_void() +
    scale_color_scico(palette = 'grayC') +
  theme(legend.position = 'none');
plot.img
plot.img <- df %>% #sample_n(df, 6789) %>% 
  ggplot(aes(x,y, color=y)) +
  geom_point(size=.5, alpha=.03) + # geom_point(alpha=runif(1, min=0, max=0.1), size=.01) +
  geom_path(alpha=.03, size = 55) + # geom_path(alpha=runif(1, min=0, max=0.2)) +
  coord_polar() +
  scale_y_continuous(trans=reverse_trans()) +
  # coord_equal() +
  theme_void() +
  scale_color_scico(palette = 'grayC') +
  theme(legend.position = 'none');

# ggsave(here("outputs/old-record-player.jpg"), dpi=600, width = 8, height = 8)
ggsave(here("2022-02-20_for-postcard-gift/two.jpg"), dpi=600, width = 8, height = 8)

    