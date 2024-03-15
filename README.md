# Predicting Political Support in the United States

## Overview
Using a Generalized Linear Model (Logistic Regression), predict political support in the US using various parameters.

## File Structure
- `inputs` contains the CES 2022 data, including their 2022 Guide .pdf. This is the raw dataset downloaded directly from the CES 2022 source.

- `other/sketches` contains the sketches of the dataset and figure we want to represent in our paper.

- `output/data` contains the cleaned CES 2022 data which is ready to be processed into the models.

- `output/models` contains the three political preferences models chosen for the development of this paper, each grouped appropriately based on the CES 2022 data.

- `output/paper.qmd` contains the written and programming portion used to generate the paper. Once generated, this Quarto file will output a `paper.pdf` which the user can use to read the paper. 

- `output/references.bib` contains the references used in the development of this paper.

- `scripts` contains the R scripts that simulated the data of the figure as well as download, clean, and create models to be later analyzed for any correlations.


## Execution Instructions

1. [OPTIONAL] Run `scripts/00_simulate_data.R` to see a simulation
2. Run `scripts/01_download_data.R` to download the raw CES 2022 dataset.
3. Run `scripts/02_download_data.R` to clean the CES 2022 dataset.
4. Run `scripts/03_model.R` to create models to later analyze for correlations.
5. Run `scripts/04_tests.R` to test the validity of our code and data.
6. Run `outputs/paper.qmd` and Render to generate the PDF of this paper.


## LLM Statement
No LLM was used in the development of this paper.