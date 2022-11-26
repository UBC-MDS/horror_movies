# author: Hongjian Li
# date: 2022-11-25

"Cleans and adds column to the horro movie dataset (from https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv).
Writes the training and test data to separate csv files.

Usage: src/pre_process_horr.r --source_dir=<source_dir> --out_dir=<out_dir>
  
Options:
--source_dir=<source_dir>       Path (including filename) to raw data (data/raw/horror_movies.csv)
--out_dir=<out_dir>             Path to directory where the processed data should be written ((data/raw/clean.csv))
" -> doc

library(docopt)
library(tidyverse)
library(caret)
set.seed(522)

opt <- docopt(doc)
main <- function(source_dir,out_dir){
  # read data and drop the columns we don't need
  data<- read_csv(source_dir)
  movies_clean <- select(data,-c(id, original_title,overview, 
                                 tagline, poster_path, status, 
                                 backdrop_path, collection, 
                                 collection_name))|>
    filter(vote_count>10)
  
movies_clean <- movies_clean|>
  mutate(high_rating = case_when(
  vote_average>=median(movies_clean$vote_average) ~ TRUE,
  vote_average<median(movies_clean$vote_average) ~ FALSE
  )
)
  
# split into training and test data sets
sample <- sample(c(TRUE, FALSE), 
  nrow(movies_clean), 
    replace=TRUE, 
    prob=c(0.8,0.2))
train  <- movies_clean[sample, ]
test   <- movies_clean[!sample, ]
  
  # save the file to clean.csv
write.csv(movies_clean, out_dir,row.names = F)
  # save the training and testing set
write.csv(train, 'data/raw/train.csv',row.names = F)
write.csv(test, 'data/raw/test.csv',row.names = F)
  
}

main(opt$source_dir, opt$out_dir)
