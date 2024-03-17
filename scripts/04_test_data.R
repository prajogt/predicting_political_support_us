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


# Test that column types are as expected
expect_equal(class(ces2022_1$voted_for), "character")
expect_equal(class(ces2022_1$age_group), "character")
expect_equal(class(ces2022_1$gender), "character")
expect_equal(class(ces2022_1$education), "character")
expect_equal(class(ces2022_1$race), "character")
expect_equal(class(ces2022_1$religion), "character")

expect_equal(class(ces2022_2$voted_for), "character")
expect_equal(class(ces2022_2$age_group), "character")
expect_equal(class(ces2022_2$gender), "character")
expect_equal(class(ces2022_2$education), "character")
expect_equal(class(ces2022_2$race), "character")
expect_equal(class(ces2022_2$religion), "character")
expect_equal(class(ces2022_2$household_gun_ownership), "character")
expect_equal(class(ces2022_2$student_loan_status), "character")


# Test that data only contains expected values
expect_equivalent(sort(unique(ces2022_1$voted_for)), sort(c("Biden", "Trump")))
expect_equivalent(sort(unique(ces2022_1$age_group)), sort(c("18-29", "30-44", "45-64", "65+")))

