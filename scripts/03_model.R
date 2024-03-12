#### Preamble ####
# Purpose: Download US CES
# Author: Timothius Prajogi, Janssen Myer Rambaud
# Date: 23 January 2024
# Contact: tim.prajogi@mail.utoronto.ca
# License: MIT
# Prerequisites: 01_download_data

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
    voted_for = if_else(voted_for == "Biden", 1, 0)
  )

ces2022_2_reduced <-
  ces2022_2 |>
  slice_sample(n = 1000) |>
  mutate(
    voted_for = as_factor(voted_for)
  )
  
# Model
political_preferences_gender_race <-
  stan_glm(
    voted_for ~ gender + race,
    data = ces2022_1_reduced,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = 
      normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 302
  )

saveRDS(
  political_preferences_gender_race,
  file = "output/models/political_preferences_gender_race.rds"
)

#ces2022_1 |>
#  ggplot(aes(x = education, fill = voted_for)) +
#  stat_count(position = "dodge") +
#  facet_wrap(facets = vars(gender)) +
#  theme_minimal() +
#  labs(
#    x = "Highest education",
#    y = "Number of respondents",
#    fill = "Voted for"
#  ) +
#  coord_flip() +
#  scale_fill_brewer(palette = "Set1") +
#  theme(legend.position = "bottom")
