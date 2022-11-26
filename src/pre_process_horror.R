# author: Hongjian Li
# date: 2022-11-25

"Cleans and adds column to the horror movie dataset 
(from https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv).

Usage: src/pre_process_horror.R --in_file=<in_file> --out_file=<out_file>
  
Options:
--in_file=<in_file>       Filename of raw horror movie data (csv) 
                            (filename only, loads from local /data/raw/<in_file>.csv)
--out_file=<out_file>     Filename to locally write clean horror movie data (csv) 
                            (filename only, saves to local /data/clean/<out_file>.csv)
" -> doc

# Setup command line functionality
library(docopt)
opt <- docopt(doc)

# Main driver function
main <- function(in_file, out_file){
  
  # Imports
  library(tidyverse)
  library(here)
  
  # Create the filepath to read the raw data from
  in_path <- here() |> paste0("/data/raw/", in_file, ".csv")
  
  # Safeguard against invalid filenames
  raw_dat <- NULL
  try({
    raw_dat <- read_csv(in_path, show_col_types = FALSE)
  })
  if (is.null(raw_dat)){
    print("Invalid filename supplied.")
    return()
  }
  
  # Clean the data
  movies_clean <- raw_dat |>
    # Drop the columns we don't need
    select(-c(id, original_title, overview, 
              tagline, poster_path, status, 
              backdrop_path, collection, 
              collection_name))|>
    # Drop movies with very low `vote_count` because
    # we are using the `vote_average` column.
    filter(vote_count > 10) |>  
    # Drop movies with zero revenue because we are
    # interested in those with non-zero revenue
    filter(!revenue==0) |> 
    # Create a new column, `rating_group`, which is 'high' for observations
    # with `vote_average` greater than the median horror movie `vote_average`,
    # and 'low' otherwise.
    mutate(
      rating_group = case_when(
        vote_average > median(vote_average) ~ 'high',
        vote_average <= median(vote_average) ~ 'low',
        TRUE ~ as.character(NA)
      )                               
    )

  # Create the filepath to write the cleaned data to
  out_path <- here() |> paste0("/data/clean/", out_file, ".csv")
  
  write_csv(movies_clean, out_path)
}

main(opt$in_file, opt$out_file)
