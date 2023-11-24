# devtools::install_github("cutterkom/generativeart")
library(generativeart)
library(tidyverse)
library(ambient) 
library(scico)
library(here)
library(TSP)
library(scales)
# 
# set the paths
IMG_DIR <- "img/"
IMG_SUBDIR <- "everything/"
IMG_SUBDIR2 <- "handpicked/"
IMG_PATH <- paste0(IMG_DIR,
                   IMG_SUBDIR)
LOGFILE_DIR <- "logfile/"
LOGFILE <- "logfile.csv"
LOGFILE_PATH <- paste0(LOGFILE_DIR,
                       LOGFILE)
# create the directory structure
generativeart::setup_directories(IMG_DIR,
                                 IMG_SUBDIR,
                                 IMG_SUBDIR2,
                                 LOGFILE_DIR)
# include a specific formula, for example:

my_formula <- list(
  y = quote(runif(1, -1, 1) * cos(x_i) + sin(y_i^3)),
  x = quote(runif(1, -1, 1) * sin(y_i) + cos(x_i^5))
)

# call the main function to create five images with a polar coordinate system
generativeart::generate_img(formula = my_formula, 
                            nr_of_img = 1, # set the number of iterations
                            polar = TRUE, 
                            filetype = "png", 
                            color = "#D19921",
                            background_color = "#162541")
#[#191C18; #AFB839];[#C1C9E6; #404535]; [#CAFFE2; #646B52]; [#1C1B02;#1EB013]
#[#CC8E37; #100E66]; [#DEB7B4; #3C62A3]; [#DEB7B4; #243A61]

   # Self-test ---------------------------------------------------------------

mydata <- generativeart::generate_data(my_formula)
generativeart::generate_plot(df=mydata,
                             file_name = 'apple.jpg',
                             filetype = 'png', polar = TRUE)

# c1a06e
# 1a3657
# color = "#6515aa", 
# background_color = "#7f897b"
mydata <- generativeart::generate_data(my_formula)
    # ggplot() + geom_path(aes(x_i,y_i), data=mydata, alpha=runif(1, min=0, max=0.1)) + geom_point() +
    #   coord_equal() +
    #   theme_void() +
    #   scale_color_scico(palette = 'roma')

# Start ggplot
plot.imgX=ggplot()  

# This loop adds layers to the plot
for (i in 1:100)
{
  # Weighted sample of pixels
  mydata %>% 
    sample_n(501) %>% 
    select(x_i,y_i) -> data
  
  # Compute distances and solve TSP
  as.TSP(dist(data)) %>% 
    solve_TSP(method = "farthest_insertion") %>% 
    as.integer() -> solution
  
  # Rearrange the original points according the TSP output
  data_to_plot <- data[solution,]
  
  # Add a new layer to prevous plot
  plot.imgX <-  plot.imgX + geom_path(aes(x_i,y_i), data=data_to_plot, alpha=runif(1, min=0, max=0.1))  + 
    geom_point(aes(x_i,y_i), data=data_to_plot, alpha=runif(1, min=0, max=0.1))
}  

# The final plot (at last)
plot.imgX +
  scale_y_continuous(trans=reverse_trans())+
  coord_fixed()+
  theme_void() -> plot.imgX; plot.imgX
ggsave(here("outputs/tsp_randomX.jpg"), plot.imgX, dpi=600, width = 4, height = 5)

