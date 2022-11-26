# A Simple Research on Horror Movie Dataset

## Authors

We are the team 11 for DSCI 522 course at UBC MDS program (Fall 2022, Block 3). 

- Raul Aguilar
- Hongjian (Sam) Li
- Xinru Lu
- Jakob Thoms

## Project Proposal

For this project, we are interested in a dataset consisting of information for a range of horror movies. The original dataset was adopted from the [tidytuesday](https://github.com/rfordatascience/tidytuesday/blob/master/data/2022/2022-11-01/horror_movies.csv) repo. The link to access the data is [here](https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv).

We will conduct inferential research with the dataset to explore the correlation between different attributes of the horror movies, such as between its ratings and its generated revenue, its budget and its generated revenue, etc. The primary inferential research question is whether horror movies which are highly rated tend to generate more revenue than those that aren't highly rated. We are also interested in whether budget affects these conclusions. 

We plan to use a hypothesis test on the samples drawn from the dataset. We will split the movies into two classes, one for higher ratings and the other for lower ratings, and perform hypothesis test with the null hypothesis being that the two groups have the same mean revenue. 

For exploratory data analysis, we will have a table for each numerical attribute with their mean, median, quartiles and standard deviations so that we get a rough idea on the distribution of data values. In addition, we will create some tick plots We will also have pairplots for the correlation between attributes to show the distribution of data points on a pair of attributes. 

For the analysis, we plan to have them on Jupyter Notebook. Therefore, the tables and plots will be saved as outputs. In the end, we will export the notebook as WebPDF to ensure proper display. 


Dependencies: 
- R version 4.2.2 with the following libraries:
   - [docopt](https://github.com/docopt/docopt.R)
   - [here](https://here.r-lib.org/)
   - [tidyverse](https://www.tidyverse.org/)
   - [infer](https://github.com/tidymodels/infer)
   - [ggthemes](https://jrnold.github.io/ggthemes/)



## The MIT License
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)  
