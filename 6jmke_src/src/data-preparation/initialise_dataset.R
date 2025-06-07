# start-script for reading dataset and codebook, based on .csv

# March 2021, Theo Pleizier

# dataset: NCLS Pilot 2019
# data: Spring 2019
# license: 
# publication: in preparation

# Required R-packages:
# here, haven, labelled, likert, ggplot2, Hmisc, flextable


# LOAD LIBRARIES AND SETTINGS
# ---------------------------
library(here)
library(haven)
library(labelled)

source(here("src/custom_functions.R"))

input_path <- "data/openaccess/"
input_file <- "ncls_pilot_2019_EN"  #without extension

# READ DATASET WITH CODEBOOK
# --------------------------

# uncomment the choice for format: Rds, sav, or csv (standard)
#dataset <- readRDS(here(input_path,paste0(input_file, ".Rds")))
#dataset <- haven::read_sav(here(input_path,paste0(input_file, ".sav")))

dataset <- read.csv(here(input_path,paste0(input_file, ".csv")), header = TRUE, row.names = 1) 

cb <- read.csv(here(input_path,paste0("codebook_",input_file, ".csv")), header = TRUE) # identifies languages (works well with Rds and sav)

# define labels in language
language("EN") 

