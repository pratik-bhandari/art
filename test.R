
# Metadata ----------------------------------------------------------------
    # Author: Pratik Bhandari
    # Date: December 03, 2020
    # Resources: Fronkonstin AND Navarro
# Libraries ---------------------------------------------------------------
library(imager)
library(tidyverse)
library(imager)
# library(dplyr) #dplyr and ggplot2 are already in tidyverse
# library(ggplot2)
library(scales)
library(TSP)
library(ambient) 
library(scico)
library(here)

# Import image ------------------------------------------------------------
file <- here("rawpics", "sara03.jpg")

# Load, convert to grayscale, filter image (to convert it to bw) and sample
# load.image(file) %>%
#   grayscale() %>%
#   threshold("45%") %>%
#   as.cimg() %>%
#   as.data.frame() %>%
#   filter(value == 0) %>%
#   select(x, y) -> dat.img2

# load.image(file) %>% as.cimg() %>% as.data.frame() -> dat.temp

# Load, convert to grayscale, filter image (to convert it to bw) and sample
load.image(here("rawpics", "sara03.jpg")) %>% 
  grayscale() %>% as.matrix -> dat.img

# Convert the matrix to data frame 
dimnames(dat.img) = list(row = 1:nrow(dat.img), col = 1:ncol(dat.img))
dat.img <- reshape2::melt(dat.img)
colnames(dat.img)=c("x","y","value")

# dat.img %>% 
#   sample_n(400, weight=1-value) %>% 
#   select(x,y) -> state

# Other parameters
art_par <- list(
  seed = 44,        # seed for the random number generator
  n_paths = 500,   # number of distinct paths to draw
  n_steps = 70,    # number of steps along each path
  sz_step = 500,   # what is the size of a typical step?
  sz_slip = 80     # what is the size of a typical slip?
)


set.seed(art_par$seed)

x <- sample_n(dat.img, art_par$n_paths) %>% select(value)
y <- sample_n(dat.img, art_par$n_paths) %>% select(value)
# z <- sample_n(dat.img, art_par$n_paths) %>% select(value)

state <- tibble(
  x = x,
  y = y,
  z = 0
) %>% 
  mutate(
    x=x, y=y,
    path_id = 1:art_par$n_paths,
    step_id = 1
  )

art_dat <- state



# Create a "dummy" variable called stop_painting. This is a logical variable
# that tells R whether we should continue to paint, or whether we should stop!
stop_painting <- FALSE

while(stop_painting == FALSE) {
  
  # This is a little bit of magic... it takes the tibble corresponding to
  # the current "state" and generates a new "step" tibble with x, y and z
  # values that tell us how to move our brush...
  step <- curl_noise(
    generator = gen_simplex,
    x = state$x,
    y = state$y,
    z = state$z,
    seed = c(1, 1, 1) * art_par$seed
  )
  
  # Use the "step" data to mutate/modify the current state, moving the x and y
  # co-ordinates of the brush(es) and possibly "slipping" a little distance in
  # the z dimension...
  state <- state %>% 
    mutate(
      x = x + step$x * art_par$sz_step / 9999, # step along x
      y = y + step$y * art_par$sz_step / 9999, # step along y
      z = z + step$z * art_par$sz_slip / 9999, # step (invisibly) along z
      step_id = step_id + 1                     # increment the step number!
    )
  
  # Append the new data to the bottom of the art_dat tibble
  art_dat <- bind_rows(art_dat, state)
  
  # The value of step_id in the last row in art_dat tells us
  # how many steps we have taken so far
  current_step <- last(art_dat$step_id)
  
  # If we have taken as many steps as were specified in the
  # parameter list, then we should stop the painting!
  if(current_step >= art_par$n_steps) {
    stop_painting <- TRUE
  }
}


# draw the picture --------------------------------------------------------

palette_name <- "oslo"

art_pic <- ggplot(
  data = art_dat,
  mapping = aes(
    x = x, 
    y = y, 
    group = path_id,
    color = step_id
  )
) + 
  geom_point(
    size = .5,
    alpha = .5,
    show.legend = FALSE
  ) +
  coord_equal() +
  theme_void() +
  scale_color_scico(palette = palette_name)


# Save --------------------------------------------------------------------

base::save.image(here::here("art.RData"))
