#### Preamble ####
# Purpose: Download US CES
# Author: Timothius Prajogi, Janssen Myer Rambaud
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01_download_data

#### Workplace setup ####

library(tidyverse)

#### Clean CES Data ####

# Read in data
ces2022 <- 
  read_csv(
    "input/ces2022.csv",
    col_types =
      cols(
        "presvote20post" = col_integer(),
        "birthyr" = col_integer(),
        "gender4" = col_integer(),
        "educ" = col_integer(),
        "race" = col_integer(),
        "religpew" = col_integer(),
        "gunown" = col_integer(),
        "edloan" = col_integer()
      )
  )

# According to the dataset's documentation at:
# https://dataverse.harvard.edu/file.xhtml?fileId=7359254&version=3.0 
# and provided in the inputs/literature file, 
# NA values are in religion, presvote20, gunown and edloan (where N != 60,000)
# As will be dealt with later, gunown and edloan NAs are not filtered out yet,
# and we also verify that they voted in the 2020 president election.
# 
# Additionally, we are only considering people who voted for Biden or Trump
# which are labeled 1 and 2 respectively in the data

ces2022 <-
  ces2022 |> 
  filter(
    presvote20post %in% c(1, 2),
    !is.na(religpew)
  )

# The documentation also buckets the age groups into:
# 18-29
# 30-44
# 45-64
# 65 + 
# ages which we calculate using 2022 - birth year.
#
# Additionally, gender was grouped into Male, Female and Other.
# Responses for Non-Binary were made, however, with only 354 responses,
# it is more feasible to group into other.
#
# Many religions have less than 1000 results out of 59949 responses. 
# Therefore, these were labeled "Other" to see if being of a religion
# that is a minority in the US has an impact on their voting habits.

cleaned_ces2022 <- 
  ces2022 |> 
  mutate(
    voted_for = if_else(presvote20post == 1, "Biden", "Trump"),
    voted_for = as_factor(voted_for),
    age = 2022 - birthyr,
    age_group = case_when(
      age < 30 ~ "18-29",
      age >= 30 & age < 45 ~ "30-44",
      age >= 45 & age < 65 ~ "45-65",
      age >= 65 ~ "65+"
    ),
    gender = case_when(
      gender4 == 1 ~ "Male",
      gender4 == 2 ~ "Female",
      gender4 == 3 ~ "Other",
      gender4 == 4 ~ "Other"
    ),
    # As per Rohan Alexander in 
    # https://tellingstorieswithdata.com/13-ijaglm.html#logistic-regression
    education = case_when(
      educ == 1 ~ "No HS",
      educ == 2 ~ "High school graduate",
      educ == 3 ~ "Some college",
      educ == 4 ~ "2-year",
      educ == 5 ~ "4-year",
      educ == 6 ~ "Post-grad"
    ),
    education = factor(
      education,
      levels = c(
        "No HS",
        "High school graduate",
        "Some college",
        "2-year",
        "4-year",
        "Post-grad"
      )
    ),
    race = case_when(
      race == 1 ~ "White",
      race == 2 ~ "Black",
      race == 3 ~ "Hispanic",
      race == 4 ~ "Asian",
      race == 5 ~ "Native American",
      race == 6 ~ "Middle Eastern",
      race == 7 ~ "Multiracial",
      race == 8 ~ "Other"
    ),
    religion = case_when(
      religpew == 1 ~ "Protestant",
      religpew == 2 ~ "Roman Catholic",
      religpew == 3 ~ "Other",
      religpew == 4 ~ "Other",
      religpew == 5 ~ "Jewish",
      religpew == 6 ~ "Other",
      religpew == 7 ~ "Other",
      religpew == 8 ~ "Hindu",
      religpew == 9 ~ "Atheist",
      religpew == 10 ~ "Agnostic",
      religpew == 11 ~ "None",
      religpew == 12 ~ "Other"
    )
    # gunown and edloan to be dealt with
  ) |>
  select(voted_for, age_group, education, race, religion, gunown, edloan)

# Exlcude gunown and edloan
cleaned_ces2022_1 <-
  cleaned_ces2022 |>
  select(voted_for, age_group, education, race, religion)

write_csv(cleaned_ces2022_1, "output/data/cleaned_ces2022_1.csv")

# Gun ownership and education loan status have around 10,000 missing values,
# so we will first store the data with columns not including gunown and edloan, 
# and then store it again, with gunown and edloan, filtering out rows which
# we are missing values for. 
#
# In doing we are able to analyze for the general population, as well as models
# given that we know certain parameters (e.g. results|gunown, edloan)
cleaned_ces2022_2 <-
  cleaned_ces2022 |>
  filter(
    !is.na(gunown),
    !is.na(edloan)
  ) |>
  mutate(
    household_gun_ownership = case_when(
      gunown == 1 ~ "Yes",
      gunown == 2 ~ "Yes",
      gunown == 3 ~ "No",
      gunown == 4 ~ "Unsure"
    ),
    student_loan_status = if_else(
      edloan == 1,
      "Yes",
      "No"
    )
  ) |>
  select(-gunown, -edloan)

write_csv(cleaned_ces2022_2, "output/data/cleaned_ces2022_2.csv")
  
  
