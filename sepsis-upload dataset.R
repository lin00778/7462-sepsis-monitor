library(tidyverse)
library(data.table) ## For the fread function
library(lubridate)
library(googledrive)
library(tictoc)
library(ggplot2)

source("sepsis_monitor_functions.R")

file_link <- "https://drive.google.com/file/d/1c8AS8bL1nI0-DCFGnA4mPkSXF_zjFlmS"
folder_link <- "https://drive.google.com/drive/folders/17_HtqnNzCDliJ_LodgaujNFQIAvpnAzU"

df <- makeSepsisDataset()

# We have to write the file to disk first, then upload it
df %>% write_csv("sepsis_data_temp.csv")

# Uploading happens here
sepsis_file <- drive_put(media = "sepsis_data_temp.csv", 
                         path = folder_link,
                         name = "sepsis_data.csv")

# Set the file permissions so anyone can download this file.
sepsis_file %>% drive_share_anyone()

new_data <- updateData(file_link)
most_recent_data <- new_data %>%
  group_by(PatientID) %>%
  filter(obsTime == max(obsTime))
