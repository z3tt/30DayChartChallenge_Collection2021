library(tidyverse)
library(here)
library(glue)

## get paths to single topic collections
paths <- list.dirs(path = here("contributions"), full.names = TRUE, recursive = TRUE)
## only keep paths to topic days
paths <- paths[which(str_detect(paths, "contributions/[0-9]{2}"))]

## get directory names to loop over
days <- list.dirs(path = here("contributions"), full.names = FALSE, recursive = TRUE)
## only keep challenge days (starting with number)
days <- days[which(str_detect(days, "[0-9]+"))]

## function to turn into collage
make_collage <- function(day, path){
  ## change working directory
  setwd(path)
  ## turn png's into jpg's
  system("magick mogrify -format jpg *.png")
  ## resize all jpg's
  system("magick convert *.jpg -resize 960x720 -gravity center -background white -extent 960x720 resized-%03d.jpg")
  ## add border
  system("magick mogrify -bordercolor black -border 3 -format jpg resized*.jpg")
  ## create grid of all resized jpg's
  system(glue("magick montage -density 100 -tile 4x0 -geometry +5+5 -border 0 resized*.jpg {day}_collage.jpg"))
  ## delete resized jpg's
  unlink("resized*")
  ## delete png's
  unlink("*.png")
}

## map over all days
walk2(days, paths, ~make_collage(.x, .y))
