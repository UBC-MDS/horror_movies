# author: Jakob Thoms
# date: 2022-11-16

"Downloads data csv data from the web to a local filepath as a csv.

Usage: src/down_data.R --url=<url> --out_file=<out_file>

Options:
--url=<url>              URL from where to download the data (must be in standard csv format)
--out_file=<out_file>    Path (including filename) of where to locally write the file
" -> doc

library(docopt)
library(tidyverse)
library(here)


opt <- docopt(doc)


main <- function(url, out_file){
  dat <- NULL

  try({
    dat <- read_csv(url)
  })
  if (is.null(dat)){
    print("Invalid URL supplied.")
    return()
  }

  out_path <- here() |>
    paste0("/data/raw/", out_file, ".csv")

  write_csv(dat, out_path)
}


main(opt$url, opt$out_file)