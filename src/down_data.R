# author: Jakob Thoms
# date: 2022-11-16

"Downloads csv data from the web to the local /data/raw/ directory as a csv.

Usage: src/down_data.R --url=<url> --out_file=<out_file>
Example: src/down_data.R --url=https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv --out_file=horror_movies_raw

Options:
--url=<url>              URL from where to download the data 
                           (must be in standard csv format)
--out_file=<out_file>    Filename to locally write the file (csv) 
                           (filename only, saves to local /data/raw/<out_file>.csv)
" -> doc

# Setup command line functionality
library(docopt)
opt <- docopt(doc)

# Main driver function
main <- function(url, out_file){
  
  # Imports
  library(tidyverse)
  library(here)
  
  # Safeguard against invalid URLs
  dat <- NULL
  try({
    dat <- read_csv(url, show_col_types = FALSE)
  })
  if (is.null(dat)){
    print("Invalid URL supplied.")
    return()
  }

  # Create the filepath to write the downloaded data to
  out_path <- here() |> paste0("/data/raw/", out_file, ".csv")

  write_csv(dat, out_path)
}

main(opt$url, opt$out_file)
