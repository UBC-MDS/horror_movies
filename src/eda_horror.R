# author: Raul Aguilar, team 11
# date: Nov 23, 2022

"Creates EDA plots for the pre-processed data from the horror movies dataset.
(from https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv).
Saves the plots as png files.

Usage: src/eda_hmovies.R --in_file=<in_file> --out_dir=<out_dir>
Example: Rscript src/eda_hmovies.R --in_file='horror_movies_clean' --out_dir='image'
  
Options:
--in_file=<in_file>       Filename of clean horror movie data (csv) 
                            (filename only, loads from local /data/clean/<in_file>.csv)
--out_dir=<out_dir>       Directory name where the plots should be saved
                            (relative to repo root, e.g. 'image', 'data/img', etc.)
" -> doc

# Setup command line functionality
library(docopt)
opt <- docopt(doc)

# Main driver function
main <- function(in_file, out_dir) {
  
  # Imports
  library(tidyverse)
  library(here)
  library(ggthemes)
  theme_set(theme_minimal())
  
  # Create the filepath to read the raw data from
  in_path <- here() |> paste0("/data/clean/", in_file, ".csv")
  
  # Safeguard against invalid filenames
  horror_movies <- NULL
  try({
    horror_movies <- read_csv(in_path, show_col_types = FALSE)
  })
  if (is.null(horror_movies)){
    print("Invalid filename supplied.")
    return()
  }
  
  
  # EDA


  horror_scatter_bud <- horror_movies |>
    select(budget, revenue, vote_average) |>
    drop_na() |> 
    ggplot(aes(x = vote_average, y = revenue)) +
    geom_point(alpha = 0.3, color="#ff4500", size=3) +
    ggtitle('Does higher rating movies gross more?') +
    labs(x = 'Vote average',
         y = 'Revenue',
         caption = "Figure 1.2: horror movies revenue - vote average correlation.") +
    theme(text =  element_text(size = 18)) +
    scale_size(range = c(0, 10)) +
    scale_y_continuous(labels = scales::label_number_si()) +
    scale_x_continuous(labels = scales::label_number_si())
  
  data_movie <- glimpse(horror_movies) |>
    select(budget, runtime, revenue, vote_average) |> 
    drop_na()
  
  pairs <- GGally::ggpairs(data_movie, aes(color = "#00AFBB", alpha= 0.3, fill = "#00AFBB"), progress = FALSE) +
    ggtitle('Horror movies attributes correlation') + 
    labs(caption = "Figure 1.1: horror movies revenue, runtime, vote average and budget attributes correlation.") + theme(text =  element_text(size = 18))
  
  horror_scatter_vote <- horror_movies |>
    select(budget, revenue, vote_average) |>
    drop_na() |> 
    ggplot(aes(x = budget, y = revenue, size = vote_average)) +
    geom_point(alpha = 0.3, color="#ff4500", size=3) +
    ggtitle('Does higher budget movies gross more?') +
    labs(x = 'Budget', y = 'Revenue', 
         caption = "Figure 1.3: horror movies revenue - budget correlation.") +
    theme(text =  element_text(size = 18)) +
    scale_size(range = c(0, 10)) +
    scale_y_continuous(labels = scales::label_number_si()) +
    scale_x_continuous(labels = scales::label_number_si())
  
  revenue_density <- horror_movies |> 
    filter(revenue>0) |> 
    drop_na() |> 
    ggplot(aes(x = revenue)) + 
    geom_density(color = "#00AFBB", alpha= 0.3, fill = "#00AFBB") + 
    ggtitle('Revenue of horror movies') +
    scale_x_continuous(labels = scales::label_number_si()) +
    theme(text =  element_text(size = 18)) +
    labs(x = 'Revenue', 
         y = 'Density',
         caption = "Figure 1.4: horror movies revenue distribution.")
  
  vote_avg_density <- horror_movies |>
    filter(vote_average>0)|>
    ggplot(aes(x = vote_average)) +
    geom_density(color = "#00AFBB", alpha= 0.3, fill = "#00AFBB") + 
    ggtitle('Vote average of horror movies') +
    theme(text =  element_text(size = 18)) +
    labs(x = 'Vote average',
         y = 'Density', 
         caption = "Figure 1.5: horror movies vote average distribution.")
  
  budget_density <- horror_movies |> 
    filter(budget>0) |> 
    drop_na() |> 
    ggplot(aes(x = budget)) + 
    geom_density(color = "#00AFBB", alpha= 0.3, fill = "#00AFBB") + 
    ggtitle('Horror movies budget') +
    scale_x_continuous(labels = scales::label_number_si()) +
    theme(text =  element_text(size = 18)) +
    labs(x = 'Budget', 
         y = 'Density',
         caption = "Figure 1.6: horror movies budget distribution.")
  
  
  # Create the directory path to write the images to
  out_path <- here() |> paste0('/', out_dir)
  
  ggsave(paste0(out_path, "/budget_density.png"), 
         budget_density,
         width = 8, 
         height = 10) 
  
  ggsave(paste0(out_path, "/vote_avg_density.png"), 
         vote_avg_density,
         width = 8, 
         height = 10) 
  
  ggsave(paste0(out_path, "/revenue_density.png"), 
         revenue_density,
         width = 8, 
         height = 10) 
  
  ggsave(paste0(out_path, "/horror_scatter_vote.png"), 
         horror_scatter_vote,
         width = 8, 
         height = 10)  
  
  ggsave(paste0(out_path, "/rating_revenue_corr.png"), 
         horror_scatter_bud,
         width = 8, 
         height = 10)
  
  ggsave(paste0(out_path, "/attribute_pairs.png"), 
         pairs,
         width = 8, 
         height = 10)
}


main(opt$in_file, opt$out_dir)
