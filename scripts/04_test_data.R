#### Preamble ####
# Purpose: Download US CES
# Author: Timothius Prajogi, Janssen Myer Rambaud
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01_download_data, 02_clean_data

#### Workplace setup ####

library(testthat)
library(tidyverse)

#### Test that the data is as expected ####

# Load in data
ces2022_1 <- read_csv("output/data/cleaned_ces2022_1.csv")
ces2022_2 <- read_csv("output/data/cleaned_ces2022_2.csv")