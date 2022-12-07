# Contributing to the Horror Movie Analysis project

This outlines how to propose a change to the Horror Movie Analysis project.

### Fixing typos

Small typos or grammatical errors in documentation may be edited directly using
the GitHub web interface, so long as the changes are made in the _source_ file.

* YES: you edit a roxygen comment in a `.R` file below `R/`.
* NO: you edit an `.Rd` file below `man/`.

### Prerequisites

Before you make a substantial pull request, you should always file an issue and
make sure someone from the team agrees that it's a problem. If you've found a
bug, create an associated issue and illustrate the bug with a minimal
[reprex](https://www.tidyverse.org/help/#reprex).

### Ways to contribute

* New code should follow the [tidyverse style guide](http://style.tidyverse.org) or [PEP 8 style guide](https://peps.python.org/pep-0008/).
* We use [roxygen2](https://cran.r-project.org/package=roxygen2), with
[Markdown syntax](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd-formatting.html),
for documentation.  
* We use [testthat](https://cran.r-project.org/package=testthat). Contributions
with test cases included are easier to accept.  

#### Core members

* We recommend that the core contributors create a Git branch for each pull request (PR). Each PR will be reviewed by at least one core contributor from the project, and upon approval, merged into the main branch.
* Once a branch is merged, we recommend that the branch to be deleted.

#### Other GitHub users

* We welcome all contributions to the project by forking and submitting a pull request for our core contributors to review. We will typically review the PR within 7 days.
* If you notice a bug or have a feature request, please open an issue [here](https://github.com/UBC-MDS/horror_movies/issues).

### Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to
abide by its terms.

### Attribution
These contributing guidelines were adapted from the [dplyr contributing guidelines](https://github.com/tidyverse/dplyr/blob/main/.github/CONTRIBUTING.md).
