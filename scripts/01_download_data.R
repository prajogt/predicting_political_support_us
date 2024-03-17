#### Preamble ####
# Purpose: Download US CES
# Author: Timothius Prajogi, Janssen Myer Rambaud
# Date: 16 March 2024
# Contact: tim.prajogi@mail.utoronto.ca, janssen.rambaud@mail.utoronto.ca
# License: MIT
# Prerequisites: none

#### Workplace setup ####

library(tidyverse)
library(dataverse)

#### Download and save CES data ####

ces2022 <-
  get_dataframe_by_name(
    filename = "CCES22_Common_OUTPUT_vv_topost.csv",
    dataset = "10.7910/DVN/PR4L8P",
    server = "dataverse.harvard.edu",
    .f = read_csv
  ) |>
  select(presvote20post, birthyr, gender4, educ, race, urbancity, religpew, gunown, edloan)
  # presvote20post => Who they voted for for President during the 2020 lecture
  # birthyr       => Birth year
  # gender4       => Identified gender
  # educ          => Highest level of education completed
  # race          => Their race
  # urbancity     => Type of area they live in 
  # religpew      => Their religion
  # gunown        => If they our members of their household own a gun
  # edloan        => If they have education loans

# Save to csv
write_csv(ces2022, "input/data/ces2022.csv")

