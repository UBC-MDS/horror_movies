# horror movie data pipe
# author: Xinru Lu
# date: 2020-12-03

all: data/raw/horror_movies_raw.csv data/clean/horror_movies_clean.csv results image notebooks/EDA_keys.html

# download data
data/raw/horror_movies_raw.csv: src/down_data.R
	Rscript src/down_data.R --url=https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv --out_file=horror_movies_raw

# pre-process data
data/clean/horror_movies_clean.csv: src/pre_process_horror.R
	Rscript src/pre_process_horror.R --in_file=horror_movies_raw --out_file=horror_movies_clean

# exploratory data analysis - probability distributions and correlation
image: src/eda_horror.R data/clean/horror_movies_clean.csv
	Rscript src/eda_horror.R --in_file=horror_movies_clean --out_dir=image

# hypothesis testing
results: src/inference_horror.R data/clean/horror_movies_clean.csv
	Rscript src/inference_horror.R --in_file=horror_movies_clean --out_dir=results

# render report
notebooks/EDA_keys.html: notebooks/EDA_keys.ipynb
	python -m jupyter nbconvert --to html notebooks/EDA_keys.ipynb

clean: 
	rm -rf data/raw/horror_movies_raw.csv
	rm -rf data/clean/horror_movies_clean.csv
	rm -rf image
	rm -rf results
	rm -rf notebooks/EDA_keys.html