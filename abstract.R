library(imager)
library(dplyr)
library(ggplot2)
library(scales)
library(TSP)
library(here)
# Download the image
# urlfile="http://ereaderbackgrounds.com/movies/bw/Frankenstein.jpg"
# file="frankenstein.jpg"
# if (!file.exists(file)) download.file(urlfile, destfile = file, mode = 'wb')

# Load, convert to grayscale, filter image (to convert it to bw) and sample
# load.image(here("rawpics", "bernie07.jpg")) %>% 
load.image(here("me.jpg")) %>% 
  grayscale() %>% as.matrix -> dat.img

# Convert the matrix to data frame 
dimnames(dat.img) = list(row = 1:nrow(dat.img), col = 1:ncol(dat.img))
dat.img <- reshape2::melt(dat.img)
colnames(dat.img)=c("x","y","value")  

# Start ggplot
plot.img=ggplot()  

# This loop adds layers to the plot
for (i in 1:200)
# for (i in 1:100)
{
  # Weighted sample of pixels
  dat.img %>% 
    # sample_n(4000, weight=1-value) %>%
    sample_n(2550, weight=1-value) %>%
    select(x,y) -> data
  
  # Compute distances and solve TSP
  as.TSP(dist(data)) %>% 
    solve_TSP(method = "arbitrary_insertion") %>% 
    as.integer() -> solution
  
  # Rearrange the original points according the TSP output
  data_to_plot <- data[solution,]
  
  # Add a new layer to prevous plot
 plot.img <-  plot.img + geom_path(aes(x,y), data=data_to_plot, alpha=runif(1, min=0, max=0.1))  
}  

# The final plot (at last)
plot.img +
  scale_y_continuous(trans=reverse_trans())+
  coord_fixed()+
  theme_void() -> plot.img

# Do you like the result? Save it! (Change the filename if you want)
ggsave(here("outputs/me200_2550.png"), dpi=300, width = 5, height = 7)
# https://github.com/aschinchon/pencil-scribbles/blob/master/scribbles.R
