# horror movie data pipe
# author: Xinru Lu
# date: 2022-12-03

all: results/EDA_keys.html

# download raw data
data/raw/horror_movies_raw.csv: src/down_data.R
	Rscript src/down_data.R \
	--url=https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv \
	--out_file=horror_movies_raw

# pre-process data
data/clean/horror_movies_clean.csv: data/raw/horror_movies_raw.csv \
 src/pre_process_horror.R
	Rscript src/pre_process_horror.R \
	--in_file=horror_movies_raw \
	--out_file=horror_movies_clean

# EDA - probability distributions and correlation plots
image/budget_density.png \
image/vote_avg_density.png \
image/revenue_density.png \
image/horror_scatter_vote.png \
image/rating_revenue_corr.png \
image/attribute_pairs.png: data/clean/horror_movies_clean.csv \
 src/eda_horror.R
	Rscript src/eda_horror.R \
	--in_file=horror_movies_clean \
	--out_dir=image

# hypothesis testing
results/horror_movie_summary_stats.csv \
results/horror_movie_hypothesis_test_results.csv \
results/revenue_null_distribution.png \
results/revenue_violin_by_rating.png: data/clean/horror_movies_clean.csv \
 src/inference_horror.R
	Rscript src/inference_horror.R \
	--in_file=horror_movies_clean \
	--out_dir=results

# render report
results/EDA_keys.html: image/budget_density.png \
 image/vote_avg_density.png \
 image/revenue_density.png \
 image/horror_scatter_vote.png \
 image/rating_revenue_corr.png \
 image/attribute_pairs.png \
 results/revenue_null_distribution.png \
 results/revenue_violin_by_rating.png \
 notebooks/EDA_keys.ipynb
	python -m jupyter nbconvert --to html notebooks/EDA_keys.ipynb --output-dir=results

clean: 
	rm -rf data/* image results
	