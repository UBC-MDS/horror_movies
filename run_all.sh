# run_all.sh
# author: Jakob Thoms
# date: 2022-11-26

# This driver script completes the EDA and inferential analysis 
# of the horror movie data set found at 
# https://github.com/rfordatascience/tidytuesday/tree/master/data/2022/2022-11-01
# It takes no arguments.

# example usage:
# bash run_all.sh


set -x # Output commands to terminal as they are run

# Download the raw data
Rscript src/down_data.R \
	--url=https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv \
	--out_file=horror_movies_raw

# Pre-process the raw data
Rscript src/pre_process_horror.R \
	--in_file=horror_movies_raw \
	--out_file=horror_movies_clean

# Create EDA plots
Rscript src/eda_horror.R \
	--in_file=horror_movies_clean \
	--out_dir=image

# Run simulation-based hypothesis tests
Rscript src/inference_horror.R \
	--in_file=horror_movies_clean \
	--out_dir=results

# Render the report
python -m jupyter nbconvert \
--to html notebooks/report.ipynb \
--output-dir=results

