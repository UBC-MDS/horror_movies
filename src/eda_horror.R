# author: Raul Aguilar, team 11
# date: Nov 23, 2022

"Creates EDA plots for the pre-processed training data from the Horror Movies data.
Saves the plots as png file.
Usage: src/eda_horror.R --train=<train> --out_dir=<out_dir>
Example: Rscript src/eda_horror.R --train='data/raw/horror_movies.csv' --out_dir='image/'
  
Options:
--train=<train>     Path (including filename) to training data (which needs to be saved as a csv file)
--out_dir=<out_dir> Path to directory where the plots should be saved
" -> doc

library(tidyverse)
library(docopt)
library(ggthemes)
theme_set(theme_minimal())

opt <- docopt(doc)

main <- function(train, out_dir) {
  

  horror_movies <- read_csv(train)
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
  
  ggsave(paste0(out_dir, "/budget_density.png"), 
         budget_density,
         width = 8, 
         height = 10) 
  
  ggsave(paste0(out_dir, "/vote_avg_density.png"), 
         vote_avg_density,
         width = 8, 
         height = 10) 
  
  ggsave(paste0(out_dir, "/revenue_density.png"), 
         revenue_density,
         width = 8, 
         height = 10) 
  
  ggsave(paste0(out_dir, "/horror_scatter_vote.png"), 
         horror_scatter_vote,
         width = 8, 
         height = 10)  
  
  ggsave(paste0(out_dir, "/rating_revenue_corr.png"), 
         horror_scatter_bud,
         width = 8, 
         height = 10)
  
  ggsave(paste0(out_dir, "/attribute_pairs.png"), 
         pairs,
         width = 8, 
         height = 10)
}

main(opt[["--train"]], opt[["--out_dir"]])
