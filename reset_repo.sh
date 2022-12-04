# reset_repo.sh
# author: Jakob Thoms
# date: 2022-12-04

# This script deletes all intermediate files and results files from the
# horror_movies project repo. 
# This will reset the repo to a clean state (for testing reproducibility)

# example usage:
# bash reset_repo.sh


set -x  # Output commands to terminal as they are run

# Delete all intermediate files and results files
rm -rf data/* image results

