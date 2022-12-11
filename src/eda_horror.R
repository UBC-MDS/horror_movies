# author: Raul Aguilar
# date: 2022-11-23

"Creates EDA plots for the pre-processed data from the horror movies dataset.
(from https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv).
Saves the plots as png files.

Usage: src/eda_horror.R --in_file=<in_file> --out_dir=<out_dir>
Example: Rscript src/eda_horror.R --in_file='horror_movies_clean' --out_dir='image'
  
Options:
--in_file=<in_file>       Filename of clean horror movie data (csv) 
                            (filename only, loads from local /data/clean/<in_file>.csv)
--out_dir=<out_dir>       Directory name where the plots should be saved
                            (relative to repo root, e.g. 'image', 'data/img', etc.)
" -> doc

# Setup command line functionality
library(docopt)
opt <- docopt(doc)

# Correlation plot for meaninful numeric variables
plot_corr <- function(data_movie){
  GGally::ggpairs(data_movie, aes(color = "#00AFBB", alpha= 0.3, fill = "#00AFBB"), progress = FALSE) +
    ggtitle('Horror movies attributes correlation') + 
    labs(caption = "Figure 1.1: horror movies revenue, runtime, vote average and budget attributes correlation.") + theme(text =  element_text(size = 18))
  
}

# Scatter plot of vote average and revenue to identify possible correlation
plot_horror_scatter_bud <- function(horror_movies) {
  horror_movies |>
    select(budget, revenue, vote_average) |>
    drop_na() |> 
    ggplot(aes(x = vote_average, y = revenue)) +
    geom_bin2d() +
    scale_fill_gradient(low="lightblue" ,high="darkblue", trans="log10") +
    ggtitle('Does higher rating movies gross more?') +
    labs(x = 'Vote average',
         y = 'Revenue',
         caption = "Figure 1.2: horror movies revenue - vote average correlation.") +
    theme(text =  element_text(size = 18)) +
    scale_size(range = c(0, 10)) +
    scale_y_continuous(labels = scales::label_number_si()) +
    scale_x_continuous(labels = scales::label_number_si())
}

# Scatter plot of budget and revenue to identify possible correlation for this two variables
plot_horror_scatter_vote <- function(horror_movies) {
  horror_movies |>
    select(budget, revenue, vote_average) |>
    drop_na() |> 
    ggplot(aes(x = budget, y = revenue, size = vote_average)) +
    geom_bin2d() +
    scale_fill_gradient(low="lightblue" ,high="darkblue", trans="log10") +
    ggtitle('Does higher budget movies gross more?') +
    labs(x = 'Budget', y = 'Revenue', 
         caption = "Figure 1.3: horror movies revenue - budget correlation.") +
    theme(text =  element_text(size = 18)) +
    scale_size(range = c(0, 10)) +
    scale_y_continuous(labels = scales::label_number_si()) +
    scale_x_continuous(labels = scales::label_number_si())
}

# Density distribution plot of desired column 
plot_density <- function(horror_movies, col, col_name, figure_name) {
  horror_movies |> 
    filter({{col}}>0) |> 
    drop_na() |> 
    ggplot(aes(x = {{col}})) + 
    geom_density(color = "#00AFBB", alpha= 0.3, fill = "#00AFBB") + 
    ggtitle(paste(col_name,' Density')) +
    scale_x_continuous(labels = scales::label_number_si()) +
    theme(text =  element_text(size = 18)) +
    labs(x = col_name, 
         y = 'Density',
         caption = figure_name)
}

# Violin plot of revenue distribution by rating
plot_revenue_dist_by_rating <- function(horror_movies){
  ggplot(horror_movies) + 
  aes(
    x = revenue,
    y = rating_group
  ) +
  geom_violin(
    fill = 'blue',
    alpha = 0.3
  ) +
  geom_point(
    stat = 'summary', 
    fun = median,
    size = 1,
    color = 'black',
    shape = 16
  ) +
  theme_bw(base_size = 15) +
  labs(
    y = 'Rating group',
    x = 'Revenue',
    title = 'Distribution of revenue by rating group', 
    caption = 'Figure 2.2: Violin plot of revenue distribution by rating,
      larger spread for for high level rating group.'
  )
}

# Main driver function
main <- function(in_file, out_dir) {
  
  # Imports
  suppressPackageStartupMessages({
    library(tidyverse)
    library(here)
    library(ggthemes)
  })
  theme_set(theme_minimal())
  
  # Filepath to read the pre-processed data from
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
  
  
  # Ensure the directory to write the images to exists
  out_path <- here() |> paste0("/", out_dir)
  try({
    dir.create(out_path)
  })

  # Select variables to generate plots
  data_movie <- horror_movies |>
    select(budget, runtime, revenue, vote_average) |> 
    drop_na()
 
  pairs <- plot_corr(data_movie)
  ggsave(paste0(out_path, "/attribute_pairs.png"), 
         pairs,
         width = 16, 
         height = 10)

  horror_scatter_bud <- plot_horror_scatter_bud(horror_movies)
  ggsave(paste0(out_path, "/rating_revenue_corr.png"), 
         horror_scatter_bud,
         width = 8, 
         height = 10)
  
  horror_scatter_vote <- plot_horror_scatter_vote(horror_movies)
  ggsave(paste0(out_path, "/horror_scatter_vote.png"), 
         horror_scatter_vote,
         width = 8, 
         height = 10)
  
  revenue_density <- plot_density(horror_movies, revenue, "Revenue", "Figure 1.4: horror movies revenue distribution.")
  ggsave(paste0(out_path, "/revenue_density.png"), 
         revenue_density,
         width = 8, 
         height = 10) 

  vote_avg_density <- plot_density(horror_movies, vote_average, "Vote average", "Figure 1.5: horror movies vote average distribution.")
  ggsave(paste0(out_path, "/vote_avg_density.png"), 
         vote_avg_density,
         width = 8, 
         height = 10)

  budget_density <- plot_density(horror_movies, budget, 'Budget',"Figure 1.6: horror movies budget distribution." )
  ggsave(paste0(out_path, "/budget_density.png"), 
         budget_density,
         width = 8, 
         height = 10)
  revenue_dist_by_rating <- plot_revenue_dist_by_rating(horror_movies)
  ggsave(paste0(out_path, "/revenue_dist_by_rating.png"), 
         revenue_dist_by_rating,
         width = 8, 
         height = 10)
}

main(opt$in_file, opt$out_dir)
