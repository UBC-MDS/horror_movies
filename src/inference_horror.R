# author: Jakob Thoms
# date: 2022-11-26

"Performs a simulation-based hypothesis test for the difference of median
revenue of horror movies which have high/low average ratings using the
pre-processed data from the horror movies dataset.
(from https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv).

Saves the results of the hypothesis test (summary stats, 
observed test statistic, p-value, etc.) to two .csv files, and also creates two
plots to visualize the results, which are saved as .png files. 

Usage: src/inference_horror.R --in_file=<in_file> --out_dir=<out_dir>
Example: Rscript src/inference_horror.R --in_file='horror_movies_clean' --out_dir='results'
  
Options:
--in_file=<in_file>       Filename of clean horror movie data (csv) 
                            (filename only, loads from local /data/clean/<in_file>.csv)
--out_dir=<out_dir>       Directory name where the results should be saved
                            (relative to repo root, e.g. 'results', 'data/inference', etc.)
" -> doc

# Setup command line functionality
library(docopt)
opt <- docopt(doc)

# Main driver function
main <- function(in_file, out_dir) {
  
  #-- Setup --#
  
  # Imports
  library(tidyverse)
  library(infer)
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
  
  
  #-- Inferential analysis --#
  
  # Summary statistics
  horror_summary_stats <- horror_movies |> 
    group_by(rating_group) |> 
    summarise(
      sample_median = median(revenue),
      sample_sd = sd(revenue),
      sample_size = n()
    )
  
  # Generate simulation-based null distribution via permutation 
  n_reps <- 20000
  set.seed(1234)
  null_dist_revenue <- horror_movies |>
    specify(formula = revenue ~ rating_group) |> 
    hypothesize(null = 'independence') |> 
    generate(reps = n_reps, type = 'permute') |> 
    calculate(stat = 'diff in medians', order = c('high' , 'low'))
  
  # Calculate the observed test statistic (diff in sample medians)
  sample_median_revenue_high <- horror_summary_stats |>
    filter(rating_group == "high") |>
    pull(sample_median) 
  sample_median_revenue_low <- horror_summary_stats |>
    filter(rating_group == "low") |>
    pull(sample_median) 
  obs_test_stat <- sample_median_revenue_high - sample_median_revenue_low

  # Calculate the the p-value of the test statistic, `obs_test_stat`, using
  # the simulated null distribution, `null_dist_revenue`
  p_val <- null_dist_revenue |> 
    get_pvalue(obs_stat = obs_test_stat, direction = "greater")
  
  # Zero p-value:
  # "Though a true p-value of 0 is impossible, `get_p_value()` may 
  #   return 0 in some cases. The output of this function is an 
  #   approximation based on the number of reps chosen in the generate()
  #   step. When the observed statistic is very unlikely given the null
  #   hypothesis it is possible that the observed statistic will be more 
  #   extreme than every test statistic generated to form the null distribution,
  #   resulting in an approximate p-value of 0. 
  #   In this case, the true p-value is a small value likely less than 3/reps 
  #   (based on a poisson approximation)."
  if (p_val == 0){
    p_val <- 3/n_reps
  }
  
  alpha <- 0.05
  rejection_point<- null_dist_revenue |> 
    pull(stat) |> 
    quantile(1 - alpha)
  
  # Record the results of the hypothesis test in a table
  hypothesis_test_results <- tibble(
    observed_test_stat = obs_test_stat,
    p_value = p_val,
    null_dist_q95 = rejection_point,
    null_dist_mean = null_dist_revenue |> 
      pull(stat) |>
      mean(),
    null_dist_se = null_dist_revenue |> 
      pull(stat) |>
      sd()
  )
  
  
  #-- Plots --#
  
  # Null distribution plot
  revenue_null_dist_plot <- null_dist_revenue |>  
    ggplot(aes(x = stat)) + 
    geom_histogram(
      aes(y = ..density..), 
      colour = 'black', 
      alpha = 0.5,
      binwidth=3e5
    ) +
    geom_density(
      fill = 'black', 
      alpha = 0.3,
      lwd = 0.8
    ) +
    geom_vline(
      xintercept = obs_test_stat, 
      color = 'red', 
      linewidth = 1
    ) + 
    geom_vline(
      xintercept = rejection_point,
      color = 'blue',
      linewidth = 1,
      lty = 5
    ) +
    xlab("Difference of sample medians of revenue") +
    ylab("Density") + 
    ggtitle(
      "Simulation-Based Null Distribution",
      subtitle = "Estimated using r=20,000 permuted datasets"
    ) +
    theme_bw(base_size = 15)
  
  # Violin plot of revenue distribution by rating
  revenue_dist_by_rating_plot <- ggplot(horror_movies) + 
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
      title = 'Distribution of revenue by rating group'
    )
  
  try({
    dir.create(out_dir)
  })
  #-- Saving results --#
  # Create the directory path to write the results to
  out_path <- here() |> paste0('/', out_dir)
  
  write_csv(
    horror_summary_stats, 
    paste0(out_path, "/horror_movie_summary_stats.csv")
  )
  write_csv(
    hypothesis_test_results, 
    paste0(out_path, "/horror_movie_hypothesis_test_results.csv")
  )
  ggsave(
    paste0(out_path, "/revenue_null_distribution.png"), 
    revenue_null_dist_plot,
    width = 8, height = 10
  ) 
  ggsave(
    paste0(out_path, "/revenue_violin_by_rating.png"), 
    revenue_dist_by_rating_plot,
    width = 8, height = 10
  ) 
}

main(opt$in_file, opt$out_dir)
