# Horror Movie Revenue and Ratings

## Authors

We are team 11 for DSCI 522 of the UBC MDS program (2022/23 cohort). 

- Raul Aguilar
- Hongjian (Sam) Li
- Xinru Lu
- Jakob Thoms



## Project Proposal

### Dataset

For this project, we are interested in a dataset consisting of information about a range of horror movies. The original dataset was adopted from the [tidytuesday repo](https://github.com/rfordatascience/tidytuesday/tree/master/data/2022/2022-11-01). The link to access the data is [here](https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv).
   > A dataset about horror movies dating back to the 1950s. Data set was extracted from **[The Movie Database](https://www.themoviedb.org)** via the tmdb API using R <code>httr</code>. There are ~35K movie records in this dataset.
   

We will conduct inferential research with the dataset to determine the relationship between a horror movie's average rating and its revenue. Our population of interest will be the set of all horror movies with a non-zero revenue. The reason we add this non-zero revenue constraint is we are interested in comparing the median revenues of two subsets of the population (high/low rated), and in the raw dataset the vast majority of the movies have zero revenue. As such, the median revenue of both groups is equal to zero if the full dataset is used, and no interesting conclusions can be drawn. Therefore we will consider only the horror movies which have non-zero revenue.

In the dataset, each movie has an associated `vote_average` and `vote_count`. These represent each movie's average rating (on a scale of 1 to 10) together with the total number of votes that movie received to calculate its average rating (i.e. the `vote_count` column is the number of observations used to calculate the mean rating displayed in the `vote_average` column). We will be using the `vote_average` of each movie to classify it as either `'high'` rated or `'low'` rated, depending on whether its `vote_average` is greater than or less than the median `vote_average` of all horror movies with non-zero revenue. In the interest of accurate classification of a movie as being `'high'` or `'low'` rated, we will be discarding the entries in the dataset which have a `vote_count` of 10 or less.


### Research question

Our primary inferential research question is whether `'high'` rated horror movies have a larger median revenue than `'low'` rated horror movies (among those with non-zero revenue). 

Considering only horror movies with non-zero revenue, let $R_h$ be the population median revenue (in USD) of horror movies with average ratings greater than the median average rating of horror movies, let $R_l$ be the population median revenue (in USD) of horror movies with average ratings no greater than the median average rating of horror movies, and let $\delta = R_h - R_l$ be the difference in population median revenues. Then our hypotheses are:

$\text{H}_0:\ \delta = 0$
and
$\text{H}_a:\ \delta > 0.$

Our significance level will be the standard $\alpha = 0.05$.

Our test statistic will be the difference in sample median revenues, $\delta^* = \hat{R}_h - \hat{R}_l$. 

Since we are doing inference about the median, a CLT-based approach is not applicable here. Thus we will be using the simulation-based approach for this hypothesis test. In particular, we will use a permutation test. This makes the assumption that our sample is a good representative sample of our population of interest.

### EDA

For exploratory data analysis, we will have a table for each numerical attribute with their mean, median, quartiles and standard deviations so that we get a rough idea on the distribution of data values. In addition, we will create some tick plots. We will also have pairplots for the correlation between attributes to show the distribution of data points on a pair of attributes. 

The final report can be found [here](https://github.com/UBC-MDS/horror_movies/tree/main/notebooks/EDA_keys.html).





## Running the Analysis


### Dependencies
- R version 4.2.2 with the following libraries:
   - [docopt](https://github.com/docopt/docopt.R)
   - [here](https://here.r-lib.org/)
   - [tidyverse](https://www.tidyverse.org/)
   - [infer](https://github.com/tidymodels/infer)
   - [ggthemes](https://jrnold.github.io/ggthemes/)
   - [GGally](https://www.r-project.org/nosvn/pandoc/GGally.html)


### Usage

There are two suggested ways to run this analysis:

#### 1\. Using Make (without Docker)

To replicate this analysis:

0. Clone this repository and install the [dependencies](#dependencies) listed above
1. Open command line and navigate to the root directory the local repository
2. Run `make all`.


To reset the local repository to a clean state, with no intermediate files or results files:

1. Open command line and navigate to the root directory the repository
2. Run `make clean`

#### 2\. Using Docker

*note - the instructions in this section also depends on running this in
a unix shell (e.g., terminal or Git Bash)*

To replicate this analysis:

0. Clone this repository and install [Docker](https://www.docker.com/get-started)
1. Open command line and navigate to the root directory the local repository
2. Run `docker build -t horror_movies:v1 . `
3. Run `docker run --rm -v /$(pwd):/home/data_analysis_eg horror_movies:v1 make -C '/home/data_analysis_eg' all`


To reset the local repository to a clean state, with no intermediate files or results files:

1. Open command line and navigate to the root directory the repository
2. Run `docker run --rm -v /$(pwd):/home/data_analysis_eg horror_movies:v1 make -C '/home/data_analysis_eg' clean`






## Licenses

All material for this project is made available under the **Creative Commons Attribution 4.0 Canada License** ([CC BY 4.0 CA](https://creativecommons.org/licenses/by-nc-nd/4.0/)).

This allows for the sharing and adaptation of the datasets for any purpose, provided that the appropriate credit is given.

#### The MIT License
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)  
