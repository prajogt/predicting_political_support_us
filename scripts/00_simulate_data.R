#### Preamble ####
# Purpose: Simulates data for survey results regarding financial attitudes
# Author: Janssen Myer Rambaud & Timothius Prajogi
# Data: March 11 2024
# Contact: janssen.rambaud@mail.utoronto.ca timothius.prajogi@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Assumptions:

#### Workspace setup ####
library(tidyverse)


#### Simulate data ####

set.seed(111)
num_obs <- 1000

# this is % of electorate to calculate the eligible voters (RIGHT SIDE OF COLUMN CES2022 PG 24-25)
us_political_preferences <- tibble(
  registered_to_vote = sample(c("Yes", "No", "Don't know"), size = num_obs, replace = TRUE, prob = c(0.932, 0.062, 0.006)),
  birth_year = sample(1940:2006, size = num_obs, replace = TRUE),
  gender = sample(c(0, 1), size = num_obs, replace = TRUE, prob = c(0.48, 0.52)),
  education = sample(c(0, 1, 2, 3), size = num_obs, replace = TRUE, prob = c(0.29, 0.29, 0.26, 0.16)),
  race = sample(c(0, 1, 2, 3, 4), size = num_obs, replace = TRUE, prob = c(0.75, 0.09, 0.09, 0.04, 0.02)),
  religion = sample(c(0, 1, 2, 3, 4), size = num_obs, replace = TRUE, prob = c(0.39, 0.17, 0.03, 0.08, 0.32)),
  gun_ownership = sample(c(0, 1, 2, 3), size = num_obs, replace = TRUE, prob = c(0.242, 0.115, 0.589, 0.055)),
  education_loans = sample(c(0, 1), size = num_obs, replace = TRUE, prob = c(0.815, 0.185))
) |>
  
  # sorting/categorizing/bucketing
  mutate(
    age_group = cut(2024 - birth_year, breaks = c(17, 29, 44, 64, Inf), labels = c("18-29", "30-44", "45-64", "65+"), right = FALSE),
    gender = if_else(gender == 0, "Male", "Female"),
    education = case_when(
      education == 0 ~ "High school or less",
      education == 1 ~ "Some college",
      education == 2 ~ "College",
      education == 3 ~ "Post-grad"
    ),
    race = case_when(
      race == 0 ~ "White",
      race == 1 ~ "Black",
      race == 2 ~ "Hispanic",
      race == 3 ~ "Asian",
      race == 4 ~ "Other"
    ),
    religion = case_when(
      religion == 0 ~ "Protestant/other Christian",
      religion == 1 ~ "Catholic",
      religion == 2 ~ "Jewish",
      religion == 3 ~ "Something else",
      religion == 4 ~ "None"
    ),
    gun_ownership = case_when(
      gun_ownership == 0 ~ "Personally own a gun",
      gun_ownership == 1 ~ "Don't personally own a gun, but someone in the household owns a gun",
      gun_ownership == 2 ~ "No one in the household owns a gun",
      gun_ownership == 3 ~ "Not sure"
    ),
    education_loans = if_else(education_loans == 0, "No", "Yes")
  ) |>
  # % for republicans
  mutate(
    support_prob = case_when(
      
      ## This skews the results way too much
      #registered_to_vote == "Yes" ~ 0.932,
      #registered_to_vote == "No" ~ 0.062,
      #registered_to_vote == "Don't know" ~ 0.006,
      gender == "Male" ~ 0.48,
      gender == "Female" ~ 0.52,
      education == "< High school" ~ sum(education == 0) / num_obs,
      education == "High school" ~ sum(education == 1) / num_obs,
      education == "Some college" ~ sum(education == 2) / num_obs,
      education == "College" ~ sum(education == 3) / num_obs,
      education == "Post-grad" ~ sum(education == 4) / num_obs,
      race == "White" ~ 0.75,
      race == "Black" ~ 0.09,
      race == "Hispanic" ~ 0.09,
      race == "Asian" ~ 0.04,
      race == "Other" ~ 0.02,
      religion == "Protestant/other Christian" ~ 0.39,
      religion == "Catholic" ~ 0.17,
      religion == "Jewish" ~ 0.03,
      religion == "Something else" ~ 0.08,
      religion == "None" ~ 0.32,
      gun_ownership == "Personally own a gun" ~ 0.242,
      gun_ownership == "Don't personally own a gun, but someone in the household owns a gun" ~ 0.115,
      gun_ownership == "No one in the household owns a gun" ~ 0.589,
      gun_ownership == "Not sure" ~ 0.055,
      education_loans == "Yes" ~ 0.185,
      education_loans == "No" ~ 0.815
    )
  ) |>
  mutate(
    supports_biden = if_else(runif(n = num_obs) < support_prob, "yes", "no")
  ) |>
  select(registered_to_vote, birth_year, age_group, gender, education, race, religion, gun_ownership, education_loans, supports_biden)

