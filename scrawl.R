

# preliminaries -----------------------------------------------------------


# Load the packages we need
library(tidyverse)
library(ambient) 
library(scico)
library(here)

# Store the parameters that specify the piece in a list. In each case the 
# parameters should be a positive integer
art_par <- list(
  seed = 897,        # seed for the random number generator
  n_paths = 200,   # number of distinct paths to draw
  n_steps = 70,    # number of steps along each path
  sz_step = 500,   # what is the size of a typical step?
  sz_slip = 80     # what is the size of a typical slip?
)


# initialising the canvas -------------------------------------------------


# To ensure reproducibility, set the "seed" of the pseudorandom number 
# generator to the value specified in the parameter list
set.seed(art_par$seed)

# To start drawing our scrawl we need to specify the "state" of the picture
# after the first "step". Each of the paths starts at a random location on 
# the canvas (varibles: x and y), and has a hidden z co-ordinate that is 
# initially set to 0 for every path.
state <- tibble(
  x = runif(art_par$n_paths, min = 0, max = 9), # uniform random number between 0 and 2
  y = runif(art_par$n_paths, min = 0, max = 9), # uniform random number between 0 and 2
  z = 0
)

# It is good practice to assign each path a specific identifier number (path_id)
# and similarly we should assign each step its own id (this is the first step so
# step_id = 1 for all paths)
state <- state %>% 
  mutate(
    path_id = 1:art_par$n_paths,
    step_id = 1
  )

# Finally, we'll create a new variable art_dat in which data for every step will
# accumulate as we apply our "brush" repeatedly
art_dat <- state


# creating the artwork data -----------------------------------------------


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

palette_name <- "lapaz"

art_pic <- ggplot(
  data = art_dat,
  mapping = aes(
    x = x, 
    y = y, 
    group = path_id,
    color = step_id
  )
) + 
  geom_path(
    size = .5,
    alpha = .5,
    show.legend = FALSE
  ) +
  coord_equal() +
  theme_void() +
  scale_color_scico(palette = palette_name)



# save the ggplot to a png ------------------------------------------------

pixels_wide <- 3000
pixels_high <- 3000

filename <- art_par %>% 
  str_c(., collapse = "-") %>% 
  str_c("scrawl_",palette_name, "_", ., ".png", collapse = "")

ggsave(
  filename = filename,
  path = here("outputs"),
  plot = art_pic,
  width = pixels_wide/300,
  height = pixels_high/300,
  dpi = 300
)




# “acton”, “bamako”, “batlow”, “berlin”, “bilbao”, “broc”, “buda”, “cork”, “davos”, “devon”,
# “grayC”, “hawaii”, “imola”, “lajolla”, “lapaz”, “lisbon”, “nuuk”, “oleron”, “oslo”, “roma”,
# “tofino”, “tokyo”, “turku”, “vik”

