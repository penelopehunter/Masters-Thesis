
# Function to install (if needed) and load packages
packageLoad <- function(x) {
  for (i in seq_along(x)) {
    if (!x[i] %in% rownames(installed.packages())) {
      install.packages(x[i])
    }
    library(x[i], character.only = TRUE)
  }
}

# Vector of required packages for this project
packages <- c(
  "dplyr",
  "tidyr",
  "ggplot2",
  "lubridate",
  "zoo",
  "data.table",
  "knitr",
  "readr",
  "tools"
)

# Install & load all packages
packageLoad(packages)

# Set knitr defaults
knitr::opts_chunk$set(
  echo = TRUE,
  message = FALSE,
  warning = FALSE,
  fig.width = 7,
  fig.height = 5
)