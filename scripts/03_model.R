#### Preamble ####
# Purpose: Create GLM on CES cleaned data
# Author: Timothius Prajogi, Janssen Myer Rambaud
# Date: 16 March 2024
# Contact: tim.prajogi@mail.utoronto.ca, janssen.rambaud@mail.utoronto.ca
# License: MIT
# Prerequisites: 01_download_data, 02_clean_data

#### Workplace setup ####

library(rstanarm)
library(tidyverse)
library(modelsummary)

#### Create the Model ####

# Load in data
ces2022_1 <- read_csv("output/data/cleaned_ces2022_1.csv")
ces2022_2 <- read_csv("output/data/cleaned_ces2022_2.csv")

# Ensure reproducibility
set.seed(302)

# Take a sample of 1000 rows
ces2022_1_reduced <-
  ces2022_1 |>
  slice_sample(n = 1000) |>
  mutate(
    # Ensure that Biden is being selected as 1, and Trump is 0
    voted_for = if_else(voted_for == "Biden", 1, 0)
    # voted_for = as_factor(voted_for)
  )

ces2022_2_reduced <-
  ces2022_2 |>
  slice_sample(n = 1000) |>
  mutate(
    # Ensure that Biden is being selected as 1, and Trump is 0
    voted_for = if_else(voted_for == "Biden", 1, 0)
    # voted_for = as_factor(voted_for)
  )
  
# Model with gender, age_group, race, religion, education
political_preferences_cultural <-
  stan_glm(
    voted_for ~ gender + age_group + race + religion,
    data = ces2022_1_reduced,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = 
      normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 302
  )

saveRDS(
  political_preferences_cultural,
  file = "output/models/political_preferences_cultural.rds"
)

# Model with only race, used to verify race's effect on the intercept.
political_preferences_race <-
  stan_glm(
    voted_for ~ race,
    data = ces2022_1_reduced,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = 
      normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 302
  )

saveRDS(
  political_preferences_race,
  file = "output/models/political_preferences_race.rds"
)

# Model with education, gunown, edloan (political differences)
political_preferences_importances <-
  stan_glm(
    voted_for ~ education + household_gun_ownership + student_loan_status,
    data = ces2022_2_reduced,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = 
      normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 302
  )

saveRDS(
  political_preferences_importances,
  file = "output/models/political_preferences_importances.rds"
)
